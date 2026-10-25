extends Node
## One owner/one clock for the network scheduler. Never reads private fixtures or mission internals.
var command: Node
var session = preload("res://script/operations_session.gd").new()
var ui: CanvasLayer
var error := ""
var _token := 0
func _ready() -> void:
	process_priority = 15
	var ids: Array = command.registry.contacts.keys().filter(func(id): return command.registry.contacts[id].metadata.has("path"))
	var result: Dictionary = preload("res://script/operations_data_loader.gd").load_data(command.operations_data_path, ids)
	error = result.error
	if error.is_empty(): error = session.configure(result.data,ids)
	if not error.is_empty(): push_error(error)
	ui = preload("res://script/operations_ui.gd").new()
	ui.host = self
	add_child(ui)
	command.queue_heading.text = "CONTACT TRIAGE / select or scroll"
func _process(delta: float) -> void:
	if error.is_empty():
		session.advance(delta,command.strategic_paused)
		for report in session.take_deliveries():
			var tactical = command.registry.contacts[int(report.contact_id)].tactical
			tactical.intelligence.append_operational_report(report)
			tactical._advance_intelligence()
		if not command.focused_center.is_empty():
			var tactical = command.tactical_centers[command.focused_center]
			if session.has_contact(tactical.selected_attack_id):
				var text: String = "Operational state: " + session.view(tactical.selected_attack_id).state
				if command.cyber != null and command.cyber.session.has_contact(tactical.selected_attack_id):
					var cyber_view: Dictionary = command.cyber.session.public_view(tactical.selected_attack_id)
					if not cyber_view.result.is_empty(): text += " / Cyber: " + cyber_view.result.outcome.to_upper()
				tactical.get_node("HUD/AttackInfoPanel").status_label.text = text
	ui.render()
func evidence(id: int) -> Dictionary:
	if not command.registry.contacts.has(id): return {}
	var latest: Dictionary = command.registry.contacts[id].tactical.intelligence.latest(id)
	var result := {}
	for key in ["assessment","confidence","report_id","source_type","text"]:
		if latest.has(key): result[key] = latest[key]
	return result
func execute(id: int, action: String, reason: String = "", snapshot: Dictionary = {}) -> Dictionary:
	if not error.is_empty(): return {"ok":false,"error":"Operations configuration unavailable."}
	_token += 1
	if action == "intercept" and command.cyber != null and command.cyber.is_cyber_contact(id):
		var rejected := {"ok":false,"error":"Use the three contextual cyber countermeasures; no kinetic interception is authorized for this cyber profile."}
		session.record_cyber(id,rejected,"wrong-channel-%d" % _token)
		return rejected
	var remaining: Variant = session.window_remaining(id)
	var result: Dictionary = session.execute(id,action,"UI-%d" % _token,reason,snapshot)
	result.remaining_at_acceptance = remaining
	return result
func navigate(id: int) -> void:
	command.focus_center(command.registry.contacts[id].center_id,id)
func set_console(value: bool) -> void:
	ui.modal.visible = value
	ui.confirmation.hide()
	# Clear any held pointer when a modal covers the tactical view; no simulation pause.
	for id in command.tactical_centers:
		command.tactical_centers[id].set_tactical_visible(not value and id == command.focused_center and not command.scorecard_open)
