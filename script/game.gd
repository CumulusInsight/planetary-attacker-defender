extends Node2D
signal public_action_recorded(receipt: Dictionary)
var report_timestamps_enabled := false
var center_identifier := "Standalone"
var simulation_elapsed := 0.0

const AttackDataLoader = preload("res://script/attack_data_loader.gd")
const EncounterDataLoader = preload("res://script/encounter_data_loader.gd")
const CommandStatus = preload("res://script/command_status.gd")
const EncounterSession = preload("res://script/encounter_session.gd")

@export_file("*.json") var attack_data_path: String = "res://data/attacks.json"
@export_file("*.json") var encounter_data_path: String = "res://data/encounters.json"
@export_enum("H", "N", "N100") var developer_fixture: String = "H"
@export_range(1.0, 315360000.0) var decision_window_seconds: float = 300.0
@export var learning_mode: bool = true
var reading: bool = false
var strategic_managed: bool = false
var strategic_pause: bool = false
var contact_ids: Array[int] = []
var active_contact_index: int = 0
var deadline = preload("res://script/orbital_deadline.gd").new()
var active_contact: Node
var closed_remaining: float = -1.0
var attack_records: Array = []
var data_error: String = ""
var encounter_error: String = ""
var encounter = EncounterSession.new()

var _surveillance_paths: Array = []
var intelligence: RefCounted
var _intelligence_revision := -1

var after_actions: Array = []
var action_feedback: CanvasLayer
var _action_attempt := 1

var selected_attack_id: int = -1
var hovered_attack_id: int = -1
var _previous_picking_sort: bool = false
var _previous_picking_first_only: bool = false


func _enter_tree() -> void:
	# Load atomically before child _ready callbacks; never display substitute identities.
	var attackers := $EnemyContainer.get_children()
	var result := AttackDataLoader.load_attacks(attack_data_path, attackers.size())
	data_error = result.error
	if not data_error.is_empty():
		$EnemyContainer.hide()
		$EnemyContainer.process_mode = Node.PROCESS_MODE_DISABLED
		push_error(data_error)
		return
	attack_records = result.records
	if not contact_ids.is_empty():
		var source_records: Array = attack_records.duplicate(true)
		var templates := attackers.duplicate()
		while $EnemyContainer.get_child_count() > contact_ids.size():
			var extra := $EnemyContainer.get_child($EnemyContainer.get_child_count() - 1)
			$EnemyContainer.remove_child(extra)
			extra.free()
		while $EnemyContainer.get_child_count() < contact_ids.size():
			var index := $EnemyContainer.get_child_count()
			var extra = load("res://scene/enemy.tscn").instantiate()
			extra.enemy_texture = templates[index % templates.size()].enemy_texture
			extra.orbit_angle = TAU * index / contact_ids.size()
			for property in source_records[index % source_records.size()]:
				extra.set(property, source_records[index % source_records.size()][property])
			extra.attack_id = contact_ids[index]
			extra.contact_identifier = EncounterSession.contact_label(contact_ids[index])
			$EnemyContainer.add_child(extra)
		attackers = $EnemyContainer.get_children()
		attack_records = []
		for index in range(contact_ids.size()):
			var record: Dictionary = source_records[index % source_records.size()].duplicate(true)
			record.attack_id = contact_ids[index]
			attack_records.append(record)
	for index in range(attackers.size()):
		var attacker = attackers[index]
		for property in attack_records[index]:
			attacker.set(property, attack_records[index][property])
		attacker.contact_identifier = EncounterSession.contact_label(attacker.attack_id)
		attacker.attacker_selected.connect(_on_attacker_selected)
		attacker.attacker_hovered.connect(_on_attacker_hovered)


func _ready() -> void:
	process_priority = 10 # Observe after moving contacts (priority 0).
	action_feedback = preload("res://script/action_feedback.gd").new()
	add_child(action_feedback)
	encounter.resolution_recorded.connect(_on_public_resolution)
	# One deterministic hover/click target, even where interaction circles overlap.
	var viewport := get_viewport()
	_previous_picking_sort = viewport.physics_object_picking_sort
	_previous_picking_first_only = viewport.physics_object_picking_first_only
	viewport.physics_object_picking_sort = true
	viewport.physics_object_picking_first_only = true
	$HUD/AttackInfoPanel.command_requested.connect(_on_command_requested)
	$HUD/AttackInfoPanel.replay_requested.connect(_on_replay_requested)
	$HUD/AttackInfoPanel.mode_requested.connect(_set_learning_mode)
	$HUD/AttackInfoPanel.reading_requested.connect(_set_reading)
	if strategic_managed:
		$HUD/AttackInfoPanel.set_strategic_managed()
	if not data_error.is_empty():
		$HUD/AttackInfoPanel.show_unavailable()
		return
	# Fixture selection is developer-only; no hidden fixture name is sent to UI.
	if OS.is_debug_build() and not strategic_managed:
		for argument in OS.get_cmdline_user_args():
			if argument.begins_with("--fixture="):
				developer_fixture = argument.trim_prefix("--fixture=")
	var result := EncounterDataLoader.load_fixtures(encounter_data_path)
	encounter_error = result.error
	if encounter_error.is_empty() and not result.fixtures.has(developer_fixture):
		encounter_error = "Unknown developer fixture '%s'. Encounter unavailable." % developer_fixture
	if encounter_error.is_empty():
		encounter_error = encounter.configure(result.fixtures[developer_fixture], attack_records[active_contact_index].attack_id)
	if encounter_error.is_empty():
		active_contact = $EnemyContainer.get_child(active_contact_index)
		if not deadline.capture(active_contact, decision_window_seconds):
			encounter_error = "Invalid orbital deadline configuration."
		$HUD/AttackInfoPanel.set_status_data(CommandStatus.demonstration(encounter.active_contact_id))
	if not encounter_error.is_empty():
		push_error(encounter_error)
		$HUD/AttackInfoPanel.show_unavailable()


func _exit_tree() -> void:
	var viewport := get_viewport()
	viewport.physics_object_picking_sort = _previous_picking_sort
	viewport.physics_object_picking_first_only = _previous_picking_first_only


func _draw() -> void:
	for radius in Enemy.RING_RADII:
		draw_arc(Vector2(800, 450), radius, 0.0, TAU, 192, Color(0.25, 0.32, 0.4, 0.65), 1.5, true)

	for trajectory in _surveillance_paths:
		var points := PackedVector2Array()
		for step in range(129):
			var angle := TAU * step / 128.0
			points.append(Vector2(800,450) + Vector2(trajectory.horizontal_radius * cos(angle), trajectory.vertical_radius * sin(angle)).rotated(trajectory.orientation))
		draw_polyline(points, Color(0.3,0.46,0.52,0.32), 1.0, true)


func _on_attacker_selected(attack_id: int) -> void:
	var selected_record: Dictionary = {}
	for record in attack_records:
		if record.attack_id == attack_id:
			selected_record = record
			break
	if selected_record.is_empty():
		push_error("Cannot display attack information: unknown attack_id %d." % attack_id)
		$HUD/AttackInfoPanel.show_unavailable()
		return
	_sync_deadline()
	selected_attack_id = attack_id
	action_feedback.publish(after_actions,attack_id,_action_attempt)
	if attack_id != encounter.active_contact_id:
		_set_reading(false)
	for attacker in $EnemyContainer.get_children():
		attacker.set_selected(attacker.attack_id == attack_id)
	if not encounter_error.is_empty():
		$HUD/AttackInfoPanel.show_unavailable()
	else:
		$HUD/AttackInfoPanel.show_contact(_public_contact_view(attack_id))
		_update_clock()


func _on_attacker_hovered(attack_id: int) -> void:
	hovered_attack_id = attack_id


func _on_command_requested(action: String) -> void:
	if not data_error.is_empty() or not encounter_error.is_empty():
		return
	_sync_deadline()
	var result: Dictionary = encounter.act(selected_attack_id, action)
	if result.ok:
		if action == "investigate": _record_investigation()
		_advance_intelligence()
		if encounter.resolved:
			_set_reading(false)
			closed_remaining = deadline.remaining(active_contact)
		$HUD/AttackInfoPanel.show_contact(_public_contact_view(selected_attack_id), true)
		_update_clock()
	else:
		_record_rejection(action,result.error)
		$HUD/AttackInfoPanel.show_contact(_public_contact_view(selected_attack_id))
		_update_clock()


func _on_replay_requested() -> void:
	if data_error.is_empty() and encounter_error.is_empty() and encounter.reset(selected_attack_id):
		_set_reading(false)
		_action_attempt += 1
		action_feedback.publish(after_actions,selected_attack_id,_action_attempt)
		deadline.restore(active_contact)
		closed_remaining = -1.0
		if intelligence != null:
			intelligence.reset_contact(active_contact)
			_advance_intelligence()
		$HUD/AttackInfoPanel.show_contact(_public_contact_view(selected_attack_id))
		_update_clock()


func _process(_delta: float) -> void:
	if not strategic_pause and not reading: simulation_elapsed += _delta
	_advance_intelligence()
	_sync_deadline()
	_update_clock()


func _sync_deadline() -> void:
	if active_contact == null or not encounter_error.is_empty() or encounter.resolved:
		return
	if deadline.remaining(active_contact) <= 0.0 and encounter.expire():
		closed_remaining = 0.0
		if selected_attack_id == encounter.active_contact_id:
			$HUD/AttackInfoPanel.show_contact(_public_contact_view(selected_attack_id), true)


func _update_clock() -> void:
	var available: bool = active_contact != null and encounter_error.is_empty() and selected_attack_id == encounter.active_contact_id
	var seconds := -1.0
	if available:
		seconds = closed_remaining if encounter.resolved else deadline.remaining(active_contact)
	$HUD/AttackInfoPanel.show_clock(seconds, encounter.resolved if available else false)

	var progress := "No encounter progression"
	if available:
		progress = "Ring %d (%s) | Orbit %.0f%%" % [active_contact.current_ring + 1, ["inner", "middle", "outer"][active_contact.current_ring], active_contact.orbit_progress / TAU * 100.0]
		progress += "\nWindow used: %.1f%%" % clampf((active_contact.total_orbit_travel - deadline.initial.travel) / deadline.budget * 100.0, 0.0, 100.0)
	$HUD/AttackInfoPanel.show_learning(learning_mode, reading, available and not encounter.resolved, progress)
	if strategic_managed and strategic_pause and not (available and encounter.resolved):
		$HUD/AttackInfoPanel.show_strategic_pause()


func _set_learning_mode(enabled: bool) -> void:
	learning_mode = enabled
	if not enabled:
		_set_reading(false)
	_update_clock()


func _set_reading(enabled: bool) -> void:
	reading = enabled and learning_mode and active_contact != null and selected_attack_id == encounter.active_contact_id and not encounter.resolved
	if active_contact != null:
		active_contact.learning_paused = reading


func apply_strategic_pause(value: bool) -> void:
	strategic_pause = value
	if active_contact != null:
		active_contact.strategic_paused = value


func set_tactical_visible(value: bool) -> void:
	visible = value
	$HUD.visible = value
	if action_feedback != null:
		action_feedback.visible = value
		if not value: action_feedback.modal.hide()
	for contact in $EnemyContainer.get_children():
		contact.get_node("Area2D").input_pickable = value
		if not value:
			contact._on_area_2d_mouse_exited()


func install_surveillance(traffic: Array, reports: Array, truth: Dictionary) -> void:
	for record in traffic:
		_surveillance_paths.append(record.path.duplicate(true))
		var contact = preload("res://script/surveillance_contact.gd").new()
		contact.configure(int(record.contact_id), record.path)
		$EnemyContainer.add_child(contact)
		contact.get_node("Area2D").input_pickable = visible
		contact.attacker_selected.connect(_on_attacker_selected)
		contact.attacker_hovered.connect(_on_attacker_hovered)
		attack_records.append({"attack_id": int(record.contact_id)})
	queue_redraw()
	intelligence = preload("res://script/intelligence_session.gd").new()
	intelligence.capture_timestamps = report_timestamps_enabled
	intelligence.clock_provider = func(): return simulation_elapsed
	intelligence.configure(reports, truth, $EnemyContainer.get_children())
	_advance_intelligence()

func _advance_intelligence() -> void:
	if intelligence == null: return
	var investigated_id: int = encounter.active_contact_id if encounter.investigated else -1
	var held: bool = strategic_pause or reading
	intelligence.advance($EnemyContainer.get_children(), investigated_id, held)
	if intelligence.revision != _intelligence_revision:
		_intelligence_revision = intelligence.revision
		if selected_attack_id >= 0:
			var panel = $HUD/AttackInfoPanel
			var scroll: int = panel.reports_scroll.scroll_vertical
			panel.show_contact(_public_contact_view(selected_attack_id))
			panel.reports_scroll.set_deferred("scroll_vertical", scroll)

func _public_contact_view(id: int) -> Dictionary:
	var view: Dictionary = encounter.public_view(id)
	if action_feedback != null:
		var receipt: Dictionary = action_feedback.latest_for(id)
		if not receipt.is_empty() and receipt.attempt == _action_attempt:
			view.feedback_text = preload("res://script/action_feedback.gd").format_brief(receipt)
	if intelligence != null:
		view.source_reports = intelligence.history(id)
		if id != encounter.active_contact_id and not view.source_reports.is_empty():
			view.title = "Monitored contact"
			view.status = "Passive surveillance / no encounter"
			view.intelligence = "See source reports below. Assessment is not verified identity."
	return view


func _on_public_resolution(event: Dictionary) -> void:
	# Existing session signal is authoritative. Store only its public projection.
	var view: Dictionary = encounter.public_view(event.contact_id)
	var expired: bool = event.decision == "expired"
	var receipt := {"receipt_id":after_actions.size()+1,"attempt":_action_attempt,"contact_id":event.contact_id,
		"acceptance":"DEADLINE EXPIRED" if expired else "COMMAND ACCEPTED",
		"command":view.decision,"remaining":0.0 if expired else deadline.remaining(active_contact),
		"execution":"No timely defensive action executed." if expired else "Existing abstract defense executed." if event.decision == "deploy" else "Deliberate hold fire recorded.",
		"disposition":"Expired without timely decision" if expired else "Resolved before expiry",
		"observation":view.observation,"uncertainty":view.uncertainty}
	stamp_receipt(receipt)
	after_actions.append(receipt)
	public_action_recorded.emit(receipt.duplicate(true))
	action_feedback.publish(after_actions,selected_attack_id,_action_attempt)

func _record_rejection(action: String, reason: String) -> void:
	var view: Dictionary = encounter.public_view(selected_attack_id)
	var remaining := -1.0
	if selected_attack_id == encounter.active_contact_id:
		remaining = closed_remaining if encounter.resolved else deadline.remaining(active_contact)
	var receipt := {"receipt_id":after_actions.size()+1,"attempt":_action_attempt,"contact_id":selected_attack_id,
		"acceptance":"COMMAND REJECTED","command":action,"remaining":remaining,
		"execution":"No new action executed: " + reason,
		"disposition":view.status,"observation":view.observation if not view.observation.is_empty() else "No new outcome observed.","uncertainty":view.uncertainty}
	# Coalesce repeated identical rejections; accepted resolution signal still emits once.
	var duplicate := false
	if not after_actions.is_empty():
		var previous: Dictionary = after_actions.back().duplicate(true)
		previous.receipt_id = receipt.receipt_id
		for key in ["local_datetime","timezone","wall_unix","simulation_elapsed","center_id","path_id","assessment"]: previous.erase(key)
		duplicate = previous == receipt
	if not duplicate:
		stamp_receipt(receipt)
		after_actions.append(receipt)
		public_action_recorded.emit(receipt.duplicate(true))
	action_feedback.publish(after_actions,selected_attack_id,_action_attempt)

func contact_context(id: int) -> Dictionary:
	var index := -1
	for i in range($EnemyContainer.get_child_count()):
		if $EnemyContainer.get_child(i).attack_id == id: index = i; break
	var latest: Dictionary = intelligence.latest(id) if intelligence != null else {}
	return {"center_id":center_identifier,"path_id":center_identifier + ("/CIRCULAR-%d" % (index+1) if index < 3 else "/ELLIPSE-%d" % (index-2)),"assessment":latest.get("assessment",encounter.public_view(id).get("intelligence","Not supplied"))}
func stamp_receipt(receipt: Dictionary) -> void:
	receipt.merge(preload("res://script/event_stamp.gd").capture())
	receipt.merge(contact_context(int(receipt.contact_id)))
	receipt.simulation_elapsed = simulation_elapsed

func _record_investigation() -> void:
	var view: Dictionary = encounter.public_view(selected_attack_id)
	var receipt := {"receipt_id":after_actions.size()+1,"attempt":_action_attempt,"contact_id":selected_attack_id,"acceptance":"COMMAND ACCEPTED","command":"Investigate further","remaining":deadline.remaining(active_contact),"execution":"Authored intelligence follow-up delivered.","disposition":"Unresolved / assessment updated","observation":view.follow_up,"uncertainty":view.uncertainty}
	stamp_receipt(receipt)
	after_actions.append(receipt)
	public_action_recorded.emit(receipt.duplicate(true))
	action_feedback.publish(after_actions,selected_attack_id,_action_attempt)
