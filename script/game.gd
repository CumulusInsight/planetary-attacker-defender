extends Node2D

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
	if attack_id != encounter.active_contact_id:
		_set_reading(false)
	for attacker in $EnemyContainer.get_children():
		attacker.set_selected(attacker.attack_id == attack_id)
	if not encounter_error.is_empty():
		$HUD/AttackInfoPanel.show_unavailable()
	else:
		$HUD/AttackInfoPanel.show_contact(encounter.public_view(attack_id))
		_update_clock()


func _on_attacker_hovered(attack_id: int) -> void:
	hovered_attack_id = attack_id


func _on_command_requested(action: String) -> void:
	if not data_error.is_empty() or not encounter_error.is_empty():
		return
	_sync_deadline()
	var result: Dictionary = encounter.act(selected_attack_id, action)
	if result.ok:
		if encounter.resolved:
			_set_reading(false)
			closed_remaining = deadline.remaining(active_contact)
		$HUD/AttackInfoPanel.show_contact(encounter.public_view(selected_attack_id), true)
		_update_clock()


func _on_replay_requested() -> void:
	if data_error.is_empty() and encounter_error.is_empty() and encounter.reset(selected_attack_id):
		_set_reading(false)
		deadline.restore(active_contact)
		closed_remaining = -1.0
		$HUD/AttackInfoPanel.show_contact(encounter.public_view(selected_attack_id))
		_update_clock()


func _process(_delta: float) -> void:
	_sync_deadline()
	_update_clock()


func _sync_deadline() -> void:
	if active_contact == null or not encounter_error.is_empty() or encounter.resolved:
		return
	if deadline.remaining(active_contact) <= 0.0 and encounter.expire():
		closed_remaining = 0.0
		if selected_attack_id == encounter.active_contact_id:
			$HUD/AttackInfoPanel.show_contact(encounter.public_view(selected_attack_id), true)


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
	if strategic_managed and strategic_pause:
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
	for contact in $EnemyContainer.get_children():
		contact.get_node("Area2D").input_pickable = value
		if not value:
			contact._on_area_2d_mouse_exited()
