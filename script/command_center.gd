extends Node
## Reuses the same tactical scene/component per data-driven center, never recreates on navigation.
const Loader = preload("res://script/strategic_data_loader.gd")
const Registry = preload("res://script/strategic_registry.gd")
const Tactical = preload("res://scene/game.tscn")
@export_file("*.json") var strategic_data_path := "res://data/strategic_centers.json"
var registry = Registry.new()
var tactical_centers: Dictionary = {}
var center_buttons: Dictionary = {}
var data_error := ""
var focused_center := ""
var learning_mode := true
var strategic_paused := false
var sort_mode := 0
var sort_control: OptionButton
var overview: Control
var queue: Tree
var queue_rows: Dictionary = {}
var mode_control: OptionButton
var pause_control: CheckButton
var back_button: Button
var context_label: Label
var _refreshing := false
var _sort_signature := ""

func _ready() -> void:
	process_priority = 20
	_build_ui()
	var result := Loader.load_centers(strategic_data_path)
	data_error = result.error
	if not data_error.is_empty():
		push_error(data_error)
		context_label.text = "Strategic data unavailable. See Godot output."
		return
	for definition in result.centers:
		var tactical = Tactical.instantiate()
		tactical.strategic_managed = true
		tactical.developer_fixture = definition.developer_fixture
		tactical.decision_window_seconds = definition.get("decision_window_seconds", 300.0)
		for contact in definition.contacts:
			tactical.contact_ids.append(int(contact.contact_id))
			if contact.contact_id == definition.active_contact_id:
				tactical.active_contact_index = tactical.contact_ids.size() - 1
		add_child(tactical)
		if not tactical.data_error.is_empty() or not tactical.encounter_error.is_empty():
			data_error = "Tactical setup failed for " + definition.center_id
			push_error(data_error)
			for existing in tactical_centers.values():
				existing.queue_free()
			tactical.queue_free()
			tactical_centers.clear()
			registry = Registry.new()
			context_label.text = "Strategic setup unavailable. See Godot output."
			return
		tactical.set_tactical_visible(false)
		tactical_centers[definition.center_id] = tactical
		registry.register(definition.center_id, definition.contacts, tactical)
	_build_center_cards()
	show_overview()

func _build_ui() -> void:
	var hud := CanvasLayer.new()
	hud.layer = 10
	add_child(hud)
	var shell := Control.new()
	shell.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shell.size = Vector2(1600, 900)
	var theme := Theme.new()
	theme.default_font = load("res://fonts/routed-gothic-wide.ttf")
	theme.default_font_size = 18
	shell.theme = theme
	hud.add_child(shell)
	back_button = Button.new()
	back_button.text = "STRATEGIC OVERVIEW"
	place(shell, back_button, Rect2(24, 8, 250, 36))
	back_button.pressed.connect(show_overview)
	mode_control = OptionButton.new()
	mode_control.add_item("Learning Mode")
	mode_control.add_item("Active Challenge Mode")
	mode_control.add_theme_font_size_override("font_size", 16)
	place(shell, mode_control, Rect2(294, 8, 280, 36))
	mode_control.item_selected.connect(func(index): set_learning_mode(index == 0))
	pause_control = CheckButton.new()
	pause_control.text = "Strategic pause (read)"
	pause_control.add_theme_font_size_override("font_size", 16)
	place(shell, pause_control, Rect2(594, 8, 300, 36))
	pause_control.toggled.connect(set_strategic_pause)
	context_label = Label.new()
	context_label.add_theme_font_size_override("font_size", 16)
	context_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	place(shell, context_label, Rect2(920, 8, 650, 36))
	overview = Control.new()
	overview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	place(shell, overview, Rect2(0, 56, 1600, 844))
	var background := ColorRect.new()
	background.color = Color(0.025, 0.04, 0.06, 1)
	place(overview, background, Rect2(0, 0, 1600, 844))
	var title := Label.new()
	title.text = "STAR FINK / ORBITAL DEFENSE COMMAND"
	title.add_theme_font_size_override("font_size", 28)
	place(overview, title, Rect2(32, 8, 1536, 40))
	var caption := Label.new()
	caption.text = "Public assessments only. Unknown is not hostile. Select a center or contact for tactical focus."
	place(overview, caption, Rect2(32, 50, 1536, 30))
	var queue_title := Label.new()
	queue_title.text = "CONTACT TRIAGE / click a row to inspect"
	place(overview, queue_title, Rect2(32, 306, 900, 40))
	sort_control = OptionButton.new()
	var sorting := sort_control
	sorting.add_item("Earliest applicable deadline")
	sorting.add_item("Highest assessed threat")
	place(overview, sorting, Rect2(1040, 306, 528, 40))
	sorting.item_selected.connect(func(index): sort_mode = index; _sort_signature = ""; refresh())
	queue = Tree.new()
	queue.columns = 7
	queue.hide_root = true
	queue.column_titles_visible = true
	queue.select_mode = Tree.SELECT_ROW
	queue.allow_reselect = true
	queue.add_theme_font_size_override("font_size", 16)
	queue.add_theme_constant_override("v_separation", 10)
	var headings := ["Contact", "Center", "Public intelligence assessment", "Confidence", "Severity", "Time to act", "Encounter status"]
	var widths := [100, 90, 455, 145, 155, 160, 270]
	for column in range(7):
		queue.set_column_title(column, headings[column])
		queue.set_column_expand(column, false)
		queue.set_column_custom_minimum_width(column, widths[column])
	place(overview, queue, Rect2(32, 358, 1536, 400))
	queue.item_selected.connect(_on_queue_selected)
	var note := Label.new()
	note.text = "Severity = assessed impact, not urgency or proof. Confidence = officer opinion. No combined threat score.\nFixture windows: 5 min default; DC-02 6 min / DC-03 4 min demonstration overrides.\nLearning strategic pause holds all encounter contacts; background traffic continues. Hover holds only the tactical contact."
	note.add_theme_font_size_override("font_size", 16)
	place(overview, note, Rect2(32, 770, 1536, 70))

static func place(parent: Node, control: Control, bounds: Rect2) -> void:
	parent.add_child(control)
	control.position = bounds.position
	control.size = bounds.size

func _build_center_cards() -> void:
	var count: int = registry.centers.size()
	var width: float = (1536.0 - 16.0 * (count - 1)) / count
	for index in range(count):
		var id: String = registry.centers[index].center_id
		var button := Button.new()
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.add_theme_font_size_override("font_size", 19)
		place(overview, button, Rect2(32 + index * (width + 16), 96, width, 194))
		button.pressed.connect(func(): focus_center(id))
		center_buttons[id] = button

func _process(_delta: float) -> void:
	if data_error.is_empty():
		refresh()

func refresh() -> void:
	_refreshing = true
	for id in center_buttons:
		var summary: Dictionary = registry.center_summary(id)
		center_buttons[id].text = "%s / TACTICAL VIEW\n%d monitored | %d active deadlines\nMost urgent: %s / %s\nHighest assessed: %s\n%s" % [id, summary.count, summary.active, summary.urgent_id, Registry.time_text(summary.remaining), Registry.SEVERITY[summary.highest], summary.attention]
		center_buttons[id].modulate = Color(1, 0.87, 0.6) if summary.attention != "MONITOR" else Color.WHITE
	var rows: Array[Dictionary] = registry.triage(sort_mode)
	var signature := str(rows.map(func(row): return row.contact_id))
	if signature != _sort_signature:
		queue.clear()
		queue_rows.clear()
		var tree_root := queue.create_item()
		for row in rows:
			var item := queue.create_item(tree_root)
			item.set_metadata(0, row.contact_id)
			queue_rows[row.contact_id] = item
		_sort_signature = signature
	for row in rows:
		var item: TreeItem = queue_rows[row.contact_id]
		var assessment: String = row.assessment
		item.set_text(0, row.identifier)
		item.set_text(1, row.center_id)
		item.set_text(2, assessment.left(44) + ("..." if assessment.length() > 44 else ""))
		item.set_tooltip_text(2, assessment + "\nOfficer assessment, not independently verified fact.")
		item.set_text(3, "Not given" if row.confidence == null else "%s%%" % str(row.confidence))
		item.set_text(4, Registry.SEVERITY[row.severity])
		item.set_text(5, Registry.time_text(row.remaining))
		item.set_text(6, row.status)
	var location := "Strategic Overview" if focused_center.is_empty() else "Tactical / " + focused_center
	context_label.text = location + (" | PAUSED: all encounters" if strategic_paused else " | Simulation running")
	_refreshing = false

func focus_center(center_id: String, contact_id: int = -1) -> bool:
	if not tactical_centers.has(center_id):
		return false
	focused_center = center_id
	for id in tactical_centers:
		tactical_centers[id].set_tactical_visible(id == center_id)
	overview.hide()
	if contact_id >= 0:
		var entry: Dictionary = registry.contacts.get(contact_id, {})
		if entry.is_empty() or entry.center_id != center_id:
			show_overview()
			return false
		tactical_centers[center_id]._on_attacker_selected(contact_id)
	refresh()
	return true

func show_overview() -> void:
	focused_center = ""
	for tactical in tactical_centers.values():
		tactical.set_tactical_visible(false)
	overview.show()
	refresh()

func _on_queue_selected() -> void:
	if _refreshing:
		return
	var item := queue.get_selected()
	if item != null:
		var id: int = item.get_metadata(0)
		focus_center(registry.contacts[id].center_id, id)

func set_learning_mode(enabled: bool) -> void:
	learning_mode = enabled
	mode_control.select(0 if enabled else 1)
	pause_control.disabled = not enabled
	if not enabled:
		set_strategic_pause(false)
	for tactical in tactical_centers.values():
		tactical.learning_mode = enabled

func set_strategic_pause(enabled: bool) -> void:
	strategic_paused = enabled and learning_mode
	pause_control.set_pressed_no_signal(strategic_paused)
	for tactical in tactical_centers.values():
		tactical.apply_strategic_pause(strategic_paused)
	refresh()
