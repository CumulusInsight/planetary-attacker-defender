extends PanelContainer
## Only accepts the session's public projection, never a private scenario fixture.

const CommandStatus = preload("res://script/command_status.gd")
var status_data: Dictionary = {}
@onready var resources_label: Label = %Resources

signal command_requested(action: String)
signal mode_requested(learning: bool)
signal reading_requested(reading: bool)
signal replay_requested

var displayed_attack_id: int = -1
var _reveal_update: bool = false
@onready var contact_label: Label = %Contact
@onready var identifier_label: Label = %Identifier
@onready var status_label: Label = %Status
@onready var reports_label: Label = %Reports
@onready var reports_scroll: ScrollContainer = %ReportsScroll
@onready var investigate_button: Button = %Investigate
@onready var deploy_button: Button = %Deploy
@onready var hold_button: Button = %HoldFire
@onready var replay_button: Button = %Replay


func _ready() -> void:
	reports_scroll.get_v_scroll_bar().changed.connect(_scroll_to_update)
	investigate_button.pressed.connect(func(): command_requested.emit("investigate"))
	deploy_button.pressed.connect(func(): command_requested.emit("deploy"))
	hold_button.pressed.connect(func(): command_requested.emit("hold_fire"))
	replay_button.pressed.connect(func(): replay_requested.emit())
	%Mode.item_selected.connect(func(index): mode_requested.emit(index == 0))
	%Reading.toggled.connect(func(enabled): reading_requested.emit(enabled))
	show_empty()


func show_contact(view: Dictionary, reveal_update: bool = false) -> void:
	_reveal_update = reveal_update
	displayed_attack_id = view.contact_id
	resources_label.text = CommandStatus.present(status_data, displayed_attack_id)
	contact_label.text = view.title
	identifier_label.text = "Contact " + view.identifier
	status_label.text = view.status
	var sections: Array[String] = ["INTELLIGENCE\n" + view.intelligence, "SIGINT\n" + view.sigint, "CAPABILITY ESTIMATE\n" + view.capabilities]
	if not view.follow_up.is_empty():
		sections.append("FOLLOW-UP\n" + view.follow_up)
	sections.append("PLAYER DECISION\n" + view.decision)
	if not view.observation.is_empty():
		sections.append("OBSERVED AFTERWARD\n" + view.observation)
	if not view.uncertainty.is_empty():
		sections.append("STILL UNCERTAIN\n" + view.uncertainty)
	var sources: Array = view.get("source_reports", [])
	if not sources.is_empty():
		sections = _source_sections(sources) + sections
	reports_label.text = "\n\n".join(sections)
	investigate_button.disabled = not view.can_investigate
	deploy_button.disabled = not view.can_deploy
	hold_button.disabled = not view.can_hold_fire
	replay_button.disabled = not view.can_reset
	reports_scroll.scroll_vertical = 0
	if reveal_update:
		_scroll_to_update.call_deferred()


func _scroll_to_update() -> void:
	# Range changes after wrapped text is laid out; follow that event, not a timer.
	if _reveal_update:
		reports_scroll.set_deferred("scroll_vertical", int(reports_scroll.get_v_scroll_bar().max_value))


func show_empty() -> void:
	_clear_details()
	contact_label.text = "Select a contact"
	status_label.text = "Reports and commands appear here."


func show_unavailable() -> void:
	_clear_details()
	contact_label.text = "Command unavailable"
	status_label.text = "Data unavailable. See Godot output."


func _clear_details() -> void:
	_reveal_update = false
	displayed_attack_id = -1
	resources_label.text = CommandStatus.present(status_data, -1)
	identifier_label.text = ""
	status_label.text = ""
	reports_label.text = ""
	reports_scroll.scroll_vertical = 0
	for button in [investigate_button, deploy_button, hold_button, replay_button]:
		button.disabled = true


func set_status_data(data: Dictionary) -> void:
	status_data = data.duplicate(true)
	resources_label.text = CommandStatus.present(status_data, displayed_attack_id)


func show_clock(seconds: float, closed: bool = false) -> void:
	%Countdown.text = CommandStatus.format_time(ceil(seconds)) if seconds >= 0.0 else "--:--:--"
	var state := "No active deadline"
	if seconds >= 0.0:
		state = "Decision recorded" if closed and seconds > 0.0 else "DEADLINE EXPIRED" if closed else "URGENT: final 10 seconds" if seconds <= 10.0 else "Approaching deadline" if seconds <= 20.0 else "Orbital decision window"
	%Urgency.text = state
	%Countdown.modulate = Color(1, 0.8, 0.4) if seconds >= 0.0 and seconds <= 10.0 else Color.WHITE


func show_learning(learning: bool, reading: bool, can_read: bool, progress: String) -> void:
	%Mode.select(0 if learning else 1)
	%Reading.disabled = not learning or not can_read
	%Reading.set_pressed_no_signal(reading)
	%Progress.text = progress
	if reading:
		%Urgency.text = "READING: contact paused"


func set_strategic_managed() -> void:
	# The command shell owns mode and pause scope in multi-center play.
	%Mode.hide()
	%Reading.hide()


func show_strategic_pause() -> void:
	%Urgency.text = "STRATEGIC PAUSE: clocks held"


static func _source_sections(reports: Array) -> Array[String]:
	var latest: Dictionary = reports.back()
	var confidence := "Not supplied" if latest.get("confidence") == null else "%s%% confidence in assessment" % str(latest.confidence)
	var result: Array[String] = ["CURRENT PUBLIC ASSESSMENT\n%s | %s\nLatest: %s\nAnalyst opinion, not verified identity." % [latest.assessment, confidence, latest.source_type]]
	var superseded := {}
	for report in reports:
		if not report.get("supersedes", "").is_empty(): superseded[report.supersedes] = true
	result.append("INTELLIGENCE HISTORY / oldest first; scroll to review")
	var marks := {"SIGINT": "[S]", "Platform Profile": "[P]", "Trajectory Assessment": "[T]", "Follow-up Analysis": "[F]"}
	for report in reports:
		var state := "PRIOR / newer assessment exists" if superseded.has(report.report_id) else "LATEST"
		var text := "%s %s / %s\n%s\nAssessment: %s\nConfidence: %s (opinion, not fact)" % [marks[report.source_type], report.source_type, state, report.text, report.assessment, "Not supplied" if report.get("confidence") == null else str(report.confidence) + "%"]
		text += "\nPossible payload: " + report.get("suspected_payload", "Not reported")
		var options: Array = report.get("recommendations", [])
		text += "\nADVISORY ONLY: " + ("; ".join(options) if not options.is_empty() else "No recommendation supplied")
		if not report.get("supersedes", "").is_empty(): text += "\nREVISED: supersedes " + report.supersedes
		result.append(text)
	return result
