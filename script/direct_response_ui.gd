extends "res://script/refined_command_ui.gd"
## Stage 4 exposes accepted commands; no new evaluator, clock or mission ledger.
var response_ready:=false
var response_home: Control
var assessment_short: Label
var attack_choices: Array=[]
var primary_response: Button
var response_actions:={}
var availability_label: Label
var investigation_short: Label
var home_receipt: Label
var reason_input: LineEdit
var command_armed:=false
var authorized_contact:=-1
var receipt_signature:=""
var return_section:="response"
func _ready() -> void:
	super._ready()
	build_response()
	response_ready=true
	show_section("threat");close_panel("threat",true)
func build_response() -> void:
	for child in panels.threat.get_children():
		if child is Label and child.position.y==12:child.text="THREAT RESPONSE"
	response_home=Control.new();response_home.mouse_filter=Control.MOUSE_FILTER_IGNORE
	command.cyber.place(visual_root,response_home,Rect2(0,102,604,506));section_nodes.response=response_home
	assessment_short=make_label(response_home,Rect2(0,0,604,45),18)
	make_label(response_home,Rect2(0,47,604,22),15).text="POSSIBLE CYBERATTACKS / select to review controls"
	for i in range(3):
		var index:=i
		attack_choices.append(make_button(response_home,"",Rect2(i*204,74,196,54),func():selected_hypothesis=index;show_section("cyber")))
	primary_response=make_button(response_home,"",Rect2(0,142,604,42),primary_review)
	availability_label=make_label(response_home,Rect2(0,187,604,27),15)
	var specs: Array=[["cyber","CYBER DEFENSE",func():show_section("cyber")],["physical","PHYSICAL RESPONSE",review_physical],["investigate","INVESTIGATE",review_investigation],["hold","HOLD FIRE",review_hold_direct]]
	for i in range(specs.size()):response_actions[specs[i][0]]=make_button(response_home,specs[i][1],Rect2((i%2)*310,220+(i/2 as int)*46,294,40),specs[i][2])
	response_actions.monitor=make_button(response_home,"CONTINUE MONITORING",Rect2(0,314,604,34),review_monitor_direct)
	investigation_short=make_label(response_home,Rect2(0,353,604,28),15)
	home_receipt=make_label(response_home,Rect2(0,386,604,160),15)
	home_receipt.add_theme_font_override("font",ThemeDB.fallback_font)
	reason_input=LineEdit.new();reason_input.max_length=300;reason_input.placeholder_text="Reason for escalation (required, 3–300 characters)"
	command.cyber.place(confirmation.get_child(0),reason_input,Rect2(28,348,944,40));reason_input.hide()
	reason_input.text_changed.connect(func(text):
		if command_armed and pending.get("type")=="direct_operation" and pending.get("action")=="escalate":confirmation.get_ok_button().disabled=text.strip_edges().length()<3)
	confirmation.text.size.y=304
	for child in confirmation.get_child(0).get_children():
		if child is Button and child.text.begins_with("Cancel"):child.pressed.connect(func():command_armed=false)
	top_buttons.alerts.size.x=76;top_buttons.alerts.add_theme_font_override("font",ThemeDB.fallback_font);top_buttons.alerts.add_theme_font_size_override("font_size",14)
	concern_filter.add_item("Urgent deadlines")
func is_original() -> bool:
	return selected==command.registry.contacts[selected].tactical.encounter.active_contact_id
func show_section(mode: String) -> void:
	super.show_section("response" if response_ready and mode=="threat" else mode)
func select_contact(id: int) -> void:
	super.select_contact(id)
	if response_ready:show_section("threat")
func open_page(index: int,id: int=-1) -> void:
	super.open_page(index,id)
	if response_ready and index==1:show_section("threat")
func refresh_views() -> void:
	super.refresh_views()
	if not response_ready:return
	var t=command.registry.contacts[selected].tactical
	var op: Dictionary=command.operations.session.view(selected)
	var row: Dictionary=command.strategic_table_rows().filter(func(r):return r.contact_id==selected)[0]
	assessment_short.text="ASSESSMENT / %s / %s" % [concise_assessment(row.assessment),model.percent(row.confidence)]
	assessment_short.tooltip_text=row.assessment
	var profile: Dictionary=model.view(selected)
	for i in range(3):attack_choices[i].text="%s\n%s" % [model.attacks[int(profile.cyber[i].attack_id)].attack_name,model.percent(profile.cyber[i].likelihood)]
	if is_original():
		primary_response.text="DEPLOY EXISTING SIGNAL DEFENSE"
		primary_response.disabled=t.encounter.resolved
		availability_label.text="Deadline expired / timely commands unavailable" if t.encounter.public_view(selected).status=="Deadline expired" else "Decision recorded / no further deployment" if t.encounter.resolved else "Signal defense available / physical response unavailable"
	else:
		primary_response.text="ESCALATE / AUTHORIZE RESPONSE" if op.get("state")!="ESCALATED" else "SELECT CYBER DEFENSE" if command.cyber.is_cyber_contact(selected) else "AUTHORIZE ABSTRACT INTERCEPTOR"
		primary_response.disabled=not (command.operations.session.can(selected,"escalate") or command.operations.session.can(selected,"intercept"))
		availability_label.text="Escalation reason + confirmation required" if command.operations.session.can(selected,"escalate") else "Cyber controls ready / physical unavailable" if op.get("state")=="ESCALATED" and command.cyber.is_cyber_contact(selected) else "Abstract interceptor available / effect unverified" if op.get("state")=="ESCALATED" else "Resolved / review outcome below" if op.get("state")=="RESOLVED" else "Monitoring only / no assigned response"
		if op.get("state")=="RESOLVED":primary_response.text="RESPONSE RECORDED"
	response_actions.physical.disabled=not (not command.cyber.is_cyber_contact(selected) and command.operations.session.can(selected,"intercept"))
	response_actions.physical.text="PHYSICAL / INTERCEPT" if not response_actions.physical.disabled else "PHYSICAL / UNAVAILABLE"
	response_actions.physical.tooltip_text="Abstract authorization; observed outcome unverified" if not response_actions.physical.disabled else "Requires escalation" if not op.is_empty() and op.state in ["MONITORED","WATCHLIST","INVESTIGATING"] and not command.cyber.is_cyber_contact(selected) else "Unavailable: no executable physical response for this contact"
	response_actions.investigate.disabled=not (command.operations.session.can(selected,"investigate") or is_original() and not t.encounter.resolved and not t.encounter.investigated)
	response_actions.hold.disabled=t.encounter.resolved if is_original() else not command.operations.session.can(selected,"hold_fire")
	response_actions.hold.tooltip_text="Deliberate final no-intervention decision" if not response_actions.hold.disabled else "Requires escalation or an unresolved original encounter"
	investigation_short.text="Investigation: "+("Follow-up received" if t.encounter.investigated else "Available" if not t.encounter.resolved else "Closed") if is_original() else "Investigation: "+ViewModel.investigation(command.operations.session,selected).state
	refresh_receipt()
	back_button.visible=section!="response"
	if section=="response":result_label.hide()
	else:
		result_label.show()
		var e: Dictionary=receipt_entry()
		if not e.is_empty():result_label.text="%s / %s
%s" % [e.command_status if e.command_status!="RECORDED" else "COMMAND ACCEPTED",e.selected_response,e.get("local_datetime","Time unavailable")]
func arm() -> void:
	command_armed=true;authorized_contact=selected;reason_input.hide()
func decision(index: int) -> void:
	super.decision(index)
	if response_ready:arm()
func review_hold() -> void:
	super.review_hold()
	if response_ready:arm()
func review_replay() -> void:
	super.review_replay()
	if response_ready:arm()
func inspect_defense(option: Dictionary) -> void:
	super.inspect_defense(option)
	if response_ready:arm()
func primary_review() -> void:
	if is_original():decision(1)
	elif command.operations.session.can(selected,"escalate"):review_operation("escalate")
	elif command.cyber.is_cyber_contact(selected):show_section("cyber")
	else:review_physical()
func review_hold_direct() -> void:
	if is_original():review_hold()
	else:review_operation("hold_fire")
func review_monitor_direct() -> void:
	if command.operations.session.can(selected,"continue"):review_operation("continue")
	else:show_section("monitor")
func review_operation(action: String) -> void:
	return_section=section
	pending={"type":"direct_operation","action":action,"evidence":command.operations.evidence(selected)}
	arm()
	confirmation.dialog_text="C-%03d / %s\nAssessment: %s\nConfidence: %s\n%s\n%s" % [selected,action.to_upper(),pending.evidence.get("assessment","Unknown"),model.percent(pending.evidence.get("confidence")),words(pending.evidence.get("text","No attributed report"),22),"Escalation is not proof of hostility. Responses: cyber controls where validated, abstract interception where supported, tracking, hold fire or stand down. Enter your reason." if action=="escalate" else "Confirm the existing operational command. No confirmed destruction is modeled."]
	confirmation.get_ok_button().disabled=not command.operations.session.can(selected,action) or action=="escalate"
	if action=="escalate":reason_input.text="";reason_input.show()
	confirmation.popup_centered()
	if action=="escalate":reason_input.grab_focus()
func confirm_action() -> void:
	if not response_ready:super.confirm_action();return
	if not command_armed:return
	if confirmation.get_ok_button().disabled:return
	command_armed=false
	if selected!=authorized_contact:
		_last_message="Selection changed. Review the response again.";return
	if pending.get("type")=="direct_operation":
		command.operations.execute(selected,pending.action,reason_input.text,pending.evidence)
	else:super.confirm_action()
	reason_input.hide();_right_signature="";receipt_signature=""
	show_section("cyber" if pending.get("action")=="escalate" and return_section=="cyber" else "threat")
func render_mapped(profile: Dictionary,cyber: Dictionary,op: Dictionary,original: bool) -> void:
	super.render_mapped(profile,cyber,op,original)
	if not response_ready:return
	for card in mapped_list.get_children():
		for child in card.get_children():
			if child is Button:
				var index: int=card.get_index()
				if index<mapped_statuses.size():
					var status: String=mapped_statuses[index]
					child.text="Deploy" if status=="Executable / review required" else "Escalate" if status=="Requires escalation" else "Review"
					if status=="Requires escalation":bind(child,func():review_operation("escalate"))
	operations_button.text="Escalate" if command.operations.session.can(selected,"escalate") else "Response home"
	bind(operations_button,func():
		if command.operations.session.can(selected,"escalate"):review_operation("escalate")
		else:show_section("threat"))
func receipt_entry() -> Dictionary:
	var relevant: Array=command.cyber.journal.filter(func(e):return e.contact_id==selected and e.kind in ["original encounter decision","command_issued","cyber_response","escalated","investigation_requested","tracking","rejected"])
	if is_original():
		var attempt: int=command.registry.contacts[selected].tactical._action_attempt
		relevant=relevant.filter(func(e):return e.get("attempt")==attempt)
	return relevant.back() if not relevant.is_empty() else {}
func refresh_receipt() -> void:
	var e: Dictionary=receipt_entry()
	if e.is_empty():home_receipt.text="Select a response above. Nothing executes until confirmation.";return
	var status: String=e.command_status if e.command_status!="RECORDED" else "COMMAND ACCEPTED"
	var observation: String=e.observed_outcome
	var op: Dictionary=command.operations.session.view(selected)
	if e.kind=="command_issued" and not op.get("consequence",{}).is_empty():observation=op.consequence.observation
	if e.kind=="rejected":observation=e.get("details",{}).get("reason",observation)
	var state: String=op.get("state",command.registry.contacts[selected].tactical.encounter.public_view(selected).status)
	var next: String="Review evidence / monitor" if state in ["RESOLVED","Decision recorded","Deadline expired"] else "Choose another available response"
	var outcome: String=e.get("disposition","Recorded")
	if e.kind=="cyber_response":outcome=e.details.outcome.to_upper()
	elif e.kind=="command_issued" and e.selected_response=="intercept":outcome="UNVERIFIED / abstract deployment"
	elif e.kind in ["escalated","investigation_requested","tracking"]:outcome="Recorded / no defense effect asserted"
	elif e.kind=="rejected":outcome="REJECTED"
	var remaining: Variant=e.get("remaining_at_acceptance")
	home_receipt.text="C-%03d / %s | %s\n%s / %s\n%s\nAt %s\nState: %s | Next: %s" % [selected,e.center_id,status,e.selected_response,outcome,words(observation,8),e.get("local_datetime","Time unavailable"),state,next]
	if remaining!=null:home_receipt.text+="\nTime remaining at command: %.2fs" % float(remaining)
	home_receipt.tooltip_text=JSON.stringify(e,"\t")
func urgent_rows() -> Array:
	return command.strategic_table_rows().filter(func(r):return r.remaining!=null and r.remaining<=60 or r.status=="Deadline expired")
func refresh_status() -> void:
	super.refresh_status()
	if response_ready:top_buttons.alerts.text="%d Urgent" % urgent_rows().size();top_buttons.alerts.tooltip_text="Urgent applicable deadlines / expired opportunities"
func command_icon(key: String) -> void:
	if response_ready and key=="threat":
		if opened.threat and section=="response":close_panel("threat",true)
		else:show_section("threat")
		return
	if response_ready and key=="alerts":
		left_mode="contacts";center_filter.select(0);concern_filter.select(6);open_panel("contacts");refresh_contacts();return
	super.command_icon(key)
func public_rows() -> Array:
	var rows: Array=super.public_rows()
	if response_ready and concern_filter.selected==6:rows=rows.filter(func(r):return r.remaining!=null and r.remaining<=60 or r.status=="Deadline expired")
	return rows

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode==KEY_ESCAPE and confirmation.visible:command_armed=false
	super._unhandled_key_input(event)
