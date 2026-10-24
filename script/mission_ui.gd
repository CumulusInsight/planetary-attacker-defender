extends CanvasLayer
## Receives public mission projections only. Never receives result codes or private review.
const DISPOSITIONS = {"deploy": "Deploy defense", "hold_fire": "Hold fire", "expired": "Deadline expired (no timely decision)"}

signal level_requested(level: String)
signal scorecard_requested(visible: bool)
var level_control: OptionButton
var scorecard_button: Button
var network_label: Label
var local_panel: Panel
var local_label: Label
var modal: ColorRect
var card: Panel
var card_title: Label
var card_label: Label
var card_scroll: ScrollContainer
var close_button: Button

func _ready() -> void:
	layer = 20
	var shell := Control.new()
	shell.size = Vector2(1600, 900)
	shell.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var theme := Theme.new()
	theme.default_font = load("res://fonts/routed-gothic-wide.ttf")
	theme.default_font_size = 18
	shell.theme = theme
	add_child(shell)
	level_control = OptionButton.new()
	level_control.add_item("Operations Commander")
	level_control.add_item("Tactical Officer")
	level_control.clip_text = true
	level_control.fit_to_longest_item = false
	level_control.add_theme_font_size_override("font_size", 16)
	place(shell, level_control, Rect2(920, 8, 310, 36))
	level_control.item_selected.connect(func(index): level_requested.emit("operations" if index == 0 else "tactical"))
	scorecard_button = Button.new()
	scorecard_button.text = "Mission scorecard"
	scorecard_button.add_theme_font_size_override("font_size", 16)
	place(shell, scorecard_button, Rect2(1250, 8, 318, 36))
	scorecard_button.pressed.connect(func(): scorecard_requested.emit(true))
	network_label = label(16)
	place(shell, network_label, Rect2(32, 140, 1536, 72))
	local_panel = Panel.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.04, 0.065, 0.085, 1)
	style.border_color = Color(0.25, 0.32, 0.4, 1)
	style.set_border_width_all(1)
	local_panel.add_theme_stylebox_override("panel", style)
	place(shell, local_panel, Rect2(16, 56, 300, 420))
	local_label = label(15)
	place(local_panel, local_label, Rect2(12, 12, 276, 396))
	modal = ColorRect.new()
	modal.color = Color(0.015, 0.025, 0.04, 0.94)
	place(shell, modal, Rect2(0, 0, 1600, 900))
	card = Panel.new()
	card.add_theme_stylebox_override("panel", style)
	place(modal, card, Rect2(140, 65, 1320, 770))
	card_title = label(26)
	place(card, card_title, Rect2(24, 16, 1272, 42))
	var notice := label(16)
	notice.text = "Confirmed evidence only. Opening this view does not pause simulation. Use Learning strategic pause before reading."
	place(card, notice, Rect2(24, 62, 1272, 44))
	card_scroll = ScrollContainer.new()
	card_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	place(card, card_scroll, Rect2(24, 112, 1272, 574))
	card_label = label(18)
	card_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card_scroll.add_child(card_label)
	close_button = Button.new()
	close_button.text = "Return to command"
	close_button.add_theme_font_size_override("font_size", 16)
	place(card, close_button, Rect2(1028, 712, 268, 40))
	close_button.pressed.connect(func(): scorecard_requested.emit(false))
	modal.hide()

static func label(font_size: int) -> Label:
	var result := Label.new()
	result.add_theme_font_size_override("font_size", font_size)
	result.mouse_filter = Control.MOUSE_FILTER_IGNORE
	result.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return result

static func place(parent: Node, control: Control, bounds: Rect2) -> void:
	parent.add_child(control)
	control.position = bounds.position
	control.size = bounds.size

static func performance(view: Dictionary) -> String:
	if view.is_empty() or view.confirmed_points == null:
		return "Unassessed (no confirmed disposition yet)"
	return "%.1f confirmed; %.1f assessed capacity; %.1f unassessed" % [view.confirmed_points, view.assessed_maximum, view.unassessed_maximum]

func render(network: Dictionary, local: Dictionary, live: Dictionary, center: String, paused: bool, error: String) -> void:
	var tactical := not center.is_empty()
	level_control.select(1 if tactical else 0)
	network_label.visible = not tactical
	local_panel.visible = tactical
	if not error.is_empty():
		network_label.text = "MISSION CONFIGURATION UNAVAILABLE: see Godot output. Tactical simulation remains available."
		local_label.text = "Tactical Officer / %s\nMission scoring unavailable; see Godot output." % center
		scorecard_button.disabled = true
		return
	if network.is_empty():
		return
	scorecard_button.disabled = false
	scorecard_button.text = "Final mission scorecard" if network.complete else "Mission scorecard"
	network_label.text = "Operations Commander | Operational health: unassessed (%d centers monitored) | Live encounters: %d active / %d resolved | Deadlines: %d\nConfirmed performance: %s (mission maximum %.0f)\nObjectives: %d/%d official dispositions; %d timely, %d expired. Protection / engagement necessity / resources: unassessed. Replays after the first result are practice." % [live.centers, live.active, live.resolved, live.deadlines, performance(network), network.maximum, network.resolved, network.participants, network.timely, network.expired]
	if tactical and not local.is_empty():
		var points := "Unassessed" if local.confirmed_points == null else "%.1f / %.1f assessed" % [local.confirmed_points, local.assessed_maximum]
		var goals: Array[String] = []
		for objective in local.objectives:
			goals.append(objective.short_text)
		local_label.text = "TACTICAL OFFICER / %s\n%s\n\nLOCAL MISSION GOALS\n%s\n\nCONFIRMED PERFORMANCE\n%s\nUnassessed: %.1f of %.1f\nOfficial decisions: %d/%d\nTimely: %d | Expired: %d\nLive center deadlines: %d\nHealth / necessity / cost:\nunassessed. See scorecard.\n\nAfter the first result, replay\nis practice; official score stays." % [center, "PAUSED: encounter clocks held" if paused else "Simulation running", "\n".join(goals), points, local.unassessed_maximum, local.maximum, local.resolved, local.participants, local.timely, local.expired, live.local_deadlines]
	card_title.text = ("FINAL MISSION SCORECARD" if network.complete else "MISSION SCORECARD / IN PROGRESS") + " - " + network.title
	var sections: Array[String] = ["Confirmed performance: %s\nMaximum: %.0f. Scores are not rescaled to hide unassessed categories.\n%s" % [performance(network), network.maximum, network.replay_policy]]
	for category in network.categories:
		var points := "Unassessed" if category.points == null else "%.1f confirmed / %.1f assessed" % [category.points, category.assessed_maximum]
		sections.append("%s | %s | category maximum %.0f\n%s. %s" % [category.label.to_upper(), points, category.maximum, category.status, category.reason])
	sections.append("MISSION OBJECTIVES")
	for objective in network.objectives:
		sections.append(objective.text + " " + objective.status)
	sections.append("OFFICIAL OBSERVABLE OUTCOMES (identity and intent remain unverified)")
	for outcome in network.outcomes:
		sections.append("%s / C-%03d | %s\n%s\n%s\n%s" % [outcome.center_id, outcome.contact_id, DISPOSITIONS[outcome.decision], outcome.observation, outcome.explanation, outcome.uncertainty])
	var content := "\n\n".join(sections)
	if card_label.text != content:
		card_label.text = content
