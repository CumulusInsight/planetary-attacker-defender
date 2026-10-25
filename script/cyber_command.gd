extends Node
## Orchestrates public UI and canonical operational events. Never edits the official mission ledger.
var command: Node
var session = preload("res://script/cyber_session.gd").new()
var error := ""
var journal: Array = []
var canvas: CanvasLayer
var modal: ColorRect
var history: ColorRect
var report: Label
var receipt: Label
var history_text: Label
var choice_buttons: Array = []
var choice_labels: Array = []
var opener: Button
var history_button: Button
var strategic_buttons := {}
var selected := -1
var _token := 0
var _seen := {}
func _ready() -> void:
	process_priority = 25
	var data: Dictionary = preload("res://script/cyber_data.gd").load_data()
	error = data.error
	if error.is_empty(): session.configure(data)
	else: push_error(error)
	command.operations.session.context_provider = context
	command.operations.session.event_recorded.connect(record_operation)
	for tactical in command.tactical_centers.values(): tactical.public_action_recorded.connect(record_original)
	build_ui()
func context(id: int) -> Dictionary:
	if not command.registry.contacts.has(id): return {}
	var info: Dictionary = command.registry.contacts[id].tactical.contact_context(id)
	if session.has_contact(id): info.cyber_assessment = session.public_view(id).assessment
	return info
func record_operation(event: Dictionary) -> void:
	var entry := event.duplicate(true)
	entry.simulation_elapsed = event.time
	append_event("operation/%d" % event.event_id,entry)
func record_original(event: Dictionary) -> void:
	var entry := event.duplicate(true)
	entry.kind = "original encounter decision"
	entry.contact_simulation_elapsed = event.simulation_elapsed
	entry.simulation_elapsed = command.operations.session.now
	append_event("original/%s/%d" % [event.center_id,event.receipt_id],entry)
func append_event(key: String, entry: Dictionary) -> void:
	if _seen.has(key): return
	_seen[key] = true
	var details: Dictionary = entry.get("details",{})
	entry.command_status = entry.get("acceptance",details.get("acceptance","RECORDED"))
	entry.selected_response = entry.get("command",details.get("response",details.get("action",entry.get("kind",""))))
	entry.observed_outcome = entry.get("observation",details.get("observation",details.get("text","No new effect observed; command/state record only.")))
	entry.remaining_at_acceptance = entry.get("remaining",details.get("remaining"))
	entry.disposition = entry.get("disposition",details.get("outcome",details.get("disposition","Not a final resolution.")))
	entry.sequence = journal.size()+1
	journal.append(entry)
	refresh_history()
func place(parent: Node, node: Control, bounds: Rect2) -> void:
	parent.add_child(node)
	node.position = bounds.position
	node.size = bounds.size
func label(parent: Node, bounds: Rect2, size: int = 18) -> Label:
	var node := Label.new()
	node.add_theme_font_size_override("font_size",size)
	node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	place(parent,node,bounds)
	return node
func button(parent: Node, text: String, bounds: Rect2, callback: Callable) -> Button:
	var node := Button.new()
	node.text = text
	node.add_theme_font_size_override("font_size",17)
	place(parent,node,bounds)
	node.pressed.connect(callback)
	return node
func build_ui() -> void:
	canvas = CanvasLayer.new()
	canvas.layer = 40
	add_child(canvas)
	var root := Control.new()
	root.size = Vector2(1600,900)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var theme := Theme.new()
	theme.default_font = load("res://fonts/routed-gothic-wide.ttf")
	root.theme = theme
	canvas.add_child(root)
	history_button = button(root,"Network after-action history",Rect2(16,850,300,38),func(): history.show(); refresh_history())
	opener = button(root,"Cyber response console",Rect2(16,795,300,38),func(): open_contact(current_id()))
	modal = ColorRect.new()
	modal.color = Color(0.02,0.035,0.05,1)
	place(root,modal,Rect2(0,0,1600,900))
	label(modal,Rect2(60,48,1100,44),28).text = "CYBER DEFENSE / EVIDENCE AND RESPONSE"
	button(modal,"Return to tactical view",Rect2(1210,48,330,44),close)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	place(modal,scroll,Rect2(60,120,720,550))
	report = Label.new()
	report.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	report.add_theme_font_size_override("font_size",18)
	report.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(report)
	label(modal,Rect2(830,118,710,40),20).text = "THREE CYBER COUNTERMEASURES / purpose, not a success guarantee"
	for i in range(3):
		var index := i
		choice_buttons.append(button(modal,"",Rect2(830,175+i*140,710,42),func(): respond(index)))
		choice_labels.append(label(modal,Rect2(842,224+i*140,686,78),18))
	receipt = label(modal,Rect2(60,686,1480,110),18)
	button(modal,"Escalate / operational commands",Rect2(60,820,460,42),func(): close(); command.operations.ui.open_console(selected))
	strategic_buttons["continue"] = button(modal,"Continue monitoring",Rect2(540,820,420,42),func(): strategic_action("continue"))
	strategic_buttons["hold_fire"] = button(modal,"Hold fire / allow departure",Rect2(980,820,560,42),func(): strategic_action("hold_fire"))
	history = ColorRect.new()
	history.color = Color(0.02,0.035,0.05,1)
	place(root,history,Rect2(0,0,1600,900))
	label(history,Rect2(60,46,1100,44),26).text = "NETWORK AFTER-ACTION HISTORY / PUBLIC EVIDENCE ONLY"
	button(history,"Return",Rect2(1240,48,300,44),func(): history.hide())
	var history_scroll := ScrollContainer.new()
	history_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	place(history,history_scroll,Rect2(60,120,1480,700))
	history_text = Label.new()
	history_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	history_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	history_text.add_theme_font_size_override("font_size",17)
	history_scroll.add_child(history_text)
	modal.hide()
	history.hide()
func is_cyber_contact(id: int) -> bool:
	return session.has_contact(id) or (not error.is_empty() and id in range(10,15))
func current_id() -> int:
	if command.focused_center.is_empty(): return -1
	return command.tactical_centers[command.focused_center].selected_attack_id
func _process(_delta: float) -> void:
	opener.hide() # Tactical entry reuses the existing left operational-card button; no overlapping controls.
	for tactical in command.tactical_centers.values(): tactical.action_feedback.history_button.hide()
	if modal.visible: render()
func open_contact(id: int) -> void:
	if command.decision_pages != null:
		command.decision_pages.open_page(1,id)
		return
	if not is_cyber_contact(id): return
	selected = id
	command.operations.set_console(false)
	command.operations.navigate(id)
	for tactical in command.tactical_centers.values(): tactical.set_tactical_visible(false)
	modal.show()
	receipt.text = "Inspect evidence, explicitly escalate, then choose a response. Cyber containment does not destroy the spacecraft."
	render()
func close() -> void:
	modal.hide()
	if not command.focused_center.is_empty(): command.focus_center(command.focused_center,selected)
func render() -> void:
	if not error.is_empty():
		report.text = "CYBER DATA UNAVAILABLE: " + error
		for control in choice_buttons: control.disabled = true
		for control in strategic_buttons.values(): control.disabled = true
		return
	var view: Dictionary = session.public_view(selected)
	var operation: Dictionary = command.operations.session.view(selected)
	for action in strategic_buttons: strategic_buttons[action].disabled = not command.operations.session.can(selected,action)
	var tactical = command.registry.contacts[selected].tactical
	var latest: Dictionary = tactical.intelligence.latest(selected)
	var text := "C-%03d / %s / %s\nPath: %s\nNo confirmed deadline.\n\nINITIAL CYBER ASSESSMENT\n%s\nConfidence in this assessment: %s%%; not verified identity.\n\n" % [selected,command.registry.contacts[selected].center_id,operation.state,context(selected).path_id,view.assessment,str(view.confidence)]
	for source in view.sources: text += source.source + ": " + source.text + "\n\n"
	if not latest.is_empty(): text += "LATEST SURVEILLANCE ASSESSMENT\n%s / %s%%\n%s\n\n" % [latest.assessment,str(latest.get("confidence","not supplied")),latest.text]
	text += "INTELLIGENCE HISTORY (old reports are retained)\n"
	for item in tactical.intelligence.history(selected): text += "%s / %s / %s\n%s\n\n" % [item.report_id,item.source_type,item.assessment,item.text]
	if not view.result.is_empty(): text += "OBSERVED CYBER STATUS: " + view.result.outcome.to_upper() + "\n" + view.result.observation + "\n" + view.result.education
	report.text = text
	for i in range(3):
		var choice: Dictionary = view.choices[i]
		choice_buttons[i].text = "%s. %s (DB %d)%s" % [char(65+i),choice.name,choice.defense_id," / already issued" if choice.used else ""]
		choice_buttons[i].disabled = operation.state != "ESCALATED" or choice.used
		choice_labels[i].text = choice.purpose
func respond(index: int) -> Dictionary:
	var view: Dictionary = session.public_view(selected)
	_token += 1
	var token := "cyber-%d" % _token
	var id: int = view.choices[index].defense_id
	var result: Dictionary = session.evaluate(selected,id,token,command.operations.session.view(selected).state == "ESCALATED")
	command.operations.session.record_cyber(selected,result,token)
	var stamp: Dictionary = journal.back()
	receipt.text = "%s / C-%03d / %s\n%s\n%s" % [stamp.local_datetime,selected,"COMMAND ACCEPTED / EXECUTED" if result.ok else "COMMAND REJECTED",result.get("observation",result.error),"Observed containment; resolved. Spacecraft remains in orbit." if result.get("final",false) else "Encounter remains unresolved; no confirmed interception or destruction."]
	render()
	return result
func strategic_action(action: String) -> void:
	var result: Dictionary = command.operations.execute(selected,action)
	receipt.text = command.operations.ui.command_receipt(selected,action,result)
	render()
func refresh_history() -> void:
	if history_text == null: return
	var texts := []
	for entry in journal:
		texts.append("#%d / %s / simulation %.3fs\nC-%03d / %s / %s\nAssessment at event: %s\n%s / %s / Response: %s\nDeadline at acceptance: %s\nDisposition: %s\nObserved: %s\n%s" % [entry.sequence,entry.get("local_datetime",""),entry.simulation_elapsed,entry.contact_id,entry.get("center_id",""),entry.get("path_id",""),entry.get("assessment","Not supplied"),entry.kind,entry.command_status,entry.selected_response,"No confirmed deadline" if entry.remaining_at_acceptance == null else "%.3fs" % entry.remaining_at_acceptance,entry.disposition,entry.observed_outcome,entry.get("execution",entry.get("details",{}).get("execution",""))])
	history_text.text = "No significant commands recorded yet." if texts.is_empty() else "\n\n".join(texts)
