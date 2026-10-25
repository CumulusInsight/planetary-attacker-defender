extends CanvasLayer
## Four public command pages. Presentation only; existing controllers own all effects and clocks.
const Presentation = preload("res://script/report_presentation.gd")
var command: Node
var model = preload("res://script/decision_assessment.gd").new()
var page := 0
var selected := 10
var selected_hypothesis := 0
var nav: Array = []
var body: ColorRect
var heading: Label
var context_line: Label
var physical: Label
var recommendation: Label
var hypotheses: Array = []
var hypothesis_texts: Array = []
var defenses: VBoxContainer
var analysis: Label
var analysis_filter: OptionButton
var history_text: Label
var history_filter: OptionButton
var sections: Array = []
var action_buttons: Array = []
var confirmation: ColorRect
var pending := {}
var notice: Label
var error := ""
var _signature := ""
var _recorded_reports := {}
var _recorded_recommendations := {}
func _ready() -> void:
	layer = 50
	error = model.load_data(command.registry.contacts)
	if not error.is_empty(): push_error(error)
	build()
	for tactical in command.tactical_centers.values():
		tactical.intelligence.clock_provider = func(): return command.operations.session.now
		tactical.intelligence.report_received.connect(receive_report)
		for contact in tactical.get_node("EnemyContainer").get_children():
			for report in tactical.intelligence.history(contact.attack_id): receive_report(report)
	for id in model.contacts: issue_recommendation(int(id))
	# Use the original sortable table; add only a concise, public attention column.
	command.queue.columns = 8
	for i in range(8):
		command.queue.set_column_expand(i,false)
		command.queue.set_column_custom_minimum_width(i,[95,90,340,130,165,145,230,180][i])
	command.queue.set_column_title(7,"Attention priority")
	for node in command.overview.get_children():
		if node is Label and node.text.begins_with("Severity ="): node.hide()
	command.cyber.history_button.pressed.connect(func(): command.cyber.history.hide(); open_page(3))
	open_page(0)
func receive_report(report: Dictionary) -> void:
	var id: int = report.contact_id
	var key := "%d/%s" % [id,str(report.get("report_event_id",report.report_id))]
	if _recorded_reports.has(key): return
	_recorded_reports[key] = true
	var entry: Dictionary = command.cyber.context(id)
	entry.assessment = report.assessment
	entry.report = report.duplicate(true)
	entry.merge({"contact_id":id,"kind":"Intelligence received","simulation_elapsed":report.get("simulation_elapsed",0.0),"local_datetime":report.get("local_datetime","Timestamp unavailable (historical record)"),"details":{"text":Presentation.full(report),"action":"Receive "+report.report_id}})
	command.cyber.append_event("intelligence/"+key,entry)
	issue_recommendation(id)
func issue_recommendation(id: int) -> void:
	if _recorded_recommendations.has(id) or not model.contacts.has(id): return
	_recorded_recommendations[id] = true
	var advice: Dictionary = command.cyber.context(id)
	advice.merge(preload("res://script/event_stamp.gd").capture())
	advice.contact_id=id
	advice.simulation_elapsed=command.operations.session.now
	advice.kind="Commander recommendation / advisory"
	advice.details={"text":model.contacts[id].recommendation.text+" "+model.contacts[id].recommendation.rationale,"action":"Review public recommendation"}
	command.cyber.append_event("recommendation/%d" % id,advice)

func build() -> void:
	var root := Control.new()
	root.size = Vector2(1600,900)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var theme := Theme.new()
	theme.default_font = load("res://fonts/routed-gothic-wide.ttf")
	root.theme = theme
	add_child(root)
	body = ColorRect.new()
	body.color = Color(0.025,0.04,0.06,1)
	command.cyber.place(root,body,Rect2(0,56,1600,782))
	heading = command.cyber.label(body,Rect2(48,14,1500,38),25)
	context_line = command.cyber.label(body,Rect2(48,56,1500,30),17)
	for i in range(3):
		var section := Control.new()
		section.mouse_filter = Control.MOUSE_FILTER_IGNORE
		command.cyber.place(body,section,Rect2(0,94,1600,688))
		sections.append(section)
	physical = command.cyber.label(sections[0],Rect2(48,0,680,140),17)
	recommendation = command.cyber.label(sections[0],Rect2(790,0,760,140),17)
	for i in range(3):
		var index := i
		hypotheses.append(command.cyber.button(sections[0],"",Rect2(48,155+i*134,680,38),func(): selected_hypothesis=index; _signature=""; render()))
		hypothesis_texts.append(command.cyber.label(sections[0],Rect2(58,198+i*134,660,86),16))
	var defense_heading: Label = command.cyber.label(sections[0],Rect2(790,155,760,40),18)
	defense_heading.text = "DATABASE DEFENSES / select to inspect before confirmation"
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	command.cyber.place(sections[0],scroll,Rect2(790,200,760,350))
	defenses = VBoxContainer.new()
	defenses.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	defenses.add_theme_constant_override("separation",14)
	scroll.add_child(defenses)
	var labels := ["Address physical suspicion","Address cyber threat","Coordinate both (proposal)","Monitor / request intelligence"]
	for i in range(4):
		var index := i
		action_buttons.append(command.cyber.button(sections[0],labels[i],Rect2(48+i*380,568,364,44),func(): decision(index)))
	command.cyber.button(sections[0],"Orbital tactical view",Rect2(48,628,330,38),func(): open_page(-1))
	command.cyber.button(sections[0],"Operational commands / escalate",Rect2(400,628,360,38),open_operations)
	notice = command.cyber.label(sections[0],Rect2(790,628,760,52),16)
	analysis_filter = OptionButton.new()
	for name in ["All sources (grouped)","SIGINT","Platform Profile","Trajectory Assessment","Follow-up Analysis"]: analysis_filter.add_item(name)
	command.cyber.place(sections[1],analysis_filter,Rect2(48,0,470,38))
	analysis_filter.item_selected.connect(func(_i): _signature=""; render())
	analysis = scroll_label(sections[1],Rect2(48,54,1500,590))
	history_filter = OptionButton.new()
	for name in ["Selected contact","Entire network"]: history_filter.add_item(name)
	command.cyber.place(sections[2],history_filter,Rect2(48,0,470,38))
	history_filter.item_selected.connect(func(_i): _signature=""; render())
	history_text = scroll_label(sections[2],Rect2(48,54,1500,590))
	for i in range(4):
		var index := i
		nav.append(command.cyber.button(root,["1 Command Overview","2 Assessment & Response","3 Intelligence Analysis","4 After-Action & History"][i],Rect2(16+i*396,850,384,40),func(): open_page(index)))
	confirmation = preload("res://script/command_confirmation.gd").new()
	root.add_child(confirmation)
	confirmation.confirmed.connect(confirm_action)
func scroll_label(parent: Node, bounds: Rect2) -> Label:
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	command.cyber.place(parent,scroll,bounds)
	var text := Label.new()
	text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text.add_theme_font_size_override("font_size",18)
	scroll.add_child(text)
	return text
func open_page(index: int, id: int = -1) -> void:
	if id >= 0 and command.registry.contacts.has(id): selected=id; selected_hypothesis=0
	elif not command.focused_center.is_empty(): selected=command.tactical_centers[command.focused_center].selected_attack_id
	page=index
	command.cyber.modal.hide(); command.cyber.history.hide()
	command.operations.set_console(false)
	if index == 0: command.show_overview()
	else:
		command.focus_center(command.registry.contacts[selected].center_id,selected)
		if index != -1:
			for tactical in command.tactical_centers.values(): tactical.set_tactical_visible(false)
	body.visible=index>0
	for i in range(4): nav[i].text=(["1 Command Overview","2 Assessment & Response","3 Intelligence Analysis","4 After-Action & History"][i])+ (" <" if i==index else "")
	_signature=""
	render()
func _process(_delta: float) -> void:
	# Old detailed pages remain available as operational subviews, not duplicate permanent panels.
	command.cyber.history_button.hide()
	if page>0 and (command.scorecard_open or command.overview.visible or command.cyber.modal.visible or command.operations.ui.modal.visible):
		body.hide()
	elif page>0:
		body.show()
		for tactical in command.tactical_centers.values():
			if tactical.visible: tactical.set_tactical_visible(false)
	if page>0 and command.overview.visible and not command.scorecard_open: open_page(0)
	for row in command.strategic_table_rows():
		if command.queue_rows.has(row.contact_id): command.queue_rows[row.contact_id].set_text(7,attention(row))
	if page>0: render()
static func attention(row: Dictionary) -> String:
	if row.remaining!=null and row.remaining<=60: return "Review deadline"
	if row.severity>=3: return "Review concern"
	return "Routine monitoring"
func render() -> void:
	if page<=0: return
	for i in range(3): sections[i].visible=(page==i+1)
	heading.text=["","THREAT ASSESSMENT & RESPONSE","INTELLIGENCE ANALYSIS","AFTER-ACTION & DECISION HISTORY"][page]
	var tactical = command.registry.contacts[selected].tactical
	var remaining: Variant = tactical.deadline.remaining(tactical.active_contact) if selected==tactical.encounter.active_contact_id and not tactical.encounter.resolved else null
	context_line.text="C-%03d / %s / %s | %s | %s" % [selected,command.registry.contacts[selected].center_id,tactical.contact_context(selected).path_id,"No applicable decision deadline" if remaining==null else "Time remaining: "+preload("res://script/command_status.gd").format_time(ceil(remaining)),"LEARNING STRATEGIC PAUSE" if command.strategic_paused else "Simulation active"]
	if not error.is_empty() and page==1:
		physical.text="ASSESSMENT DATA UNAVAILABLE: "+error
		for button in action_buttons+hypotheses: button.disabled=true
		return
	var profile: Dictionary = model.view(selected)
	var reports: Array = tactical.intelligence.history(selected)
	var signature := "%d/%d/%d/%d/%d/%d/%d" % [page,selected,selected_hypothesis,tactical.intelligence.revision,command.operations.session.revision,analysis_filter.selected,command.cyber.journal.size()+history_filter.selected*100000]
	if signature==_signature: return
	_signature=signature
	if page==1:
		physical.text="PHYSICAL WEAPON ASSESSMENT\n%s | Confidence: %s\n%s\nAssessment only; not verified weapon possession." % [profile.physical.state,model.percent(profile.physical.confidence),profile.physical.evidence]
		recommendation.text="COMMANDER RECOMMENDATION / ADVISORY\n%s | Confidence: %s\n%s" % [profile.recommendation.text,model.percent(profile.recommendation.confidence),profile.recommendation.rationale]
		for i in range(3):
			var hypothesis: Dictionary = profile.cyber[i]
			var attack: Dictionary = model.attacks[int(hypothesis.attack_id)]
			hypotheses[i].text="%s%s / likelihood %s / Review defenses" % ["> " if selected_hypothesis==i else "",attack.attack_name,model.percent(hypothesis.likelihood)]
			hypothesis_texts[i].text="%s\nSeverity if present: %s | Asset: %s\n%s" % [attack.definition,attack.severity,hypothesis.asset_at_risk,hypothesis.evidence]
		populate_defenses(int(profile.cyber[selected_hypothesis].attack_id))
		notice.text="Independent, nonexclusive estimates; not confirmed payloads. Detailed evidence: Intelligence Analysis."
	elif page==2: render_analysis(reports)
	elif page==3:
		var texts := []
		for entry in command.cyber.journal:
			if history_filter.selected==0 and entry.contact_id!=selected: continue
			var observed: String = entry.observed_outcome
			if entry.kind=="Intelligence received" and entry.has("report"):
				var newer := ""
				for later in command.registry.contacts[int(entry.contact_id)].tactical.intelligence.history(int(entry.contact_id)):
					if later.get("supersedes","")==entry.report.report_id: newer=later.report_id+" / "+later.get("local_datetime","Timestamp unavailable")
				observed=Presentation.full(entry.report,newer)
			texts.append("#%d / %s / simulation %.3fs\nC-%03d / %s / %s\n%s / %s / %s\n%s" % [entry.sequence,entry.get("local_datetime","Timestamp unavailable"),entry.simulation_elapsed,entry.contact_id,entry.get("center_id",""),entry.get("path_id",""),entry.kind,entry.command_status,entry.selected_response,observed])
		history_text.text="No recorded events for this filter." if texts.is_empty() else "\n\n".join(texts)
func render_analysis(reports: Array) -> void:
	var texts := []
	var tactical = command.registry.contacts[selected].tactical
	# Preserve original authored encounter reports too; no invented historic issue date.
	var original: Dictionary = tactical.encounter.public_view(selected)
	if selected==tactical.encounter.active_contact_id and analysis_filter.selected==0:
		texts.append("ORIGINAL ENCOUNTER BRIEF / historical timestamp unavailable\n"+original.intelligence+"\nSIGINT\n"+original.sigint+"\n"+original.capabilities)
		if not original.follow_up.is_empty():
			var followup_time := "Timestamp unavailable"
			for receipt in tactical.after_actions:
				if receipt.command=="Investigate further" and receipt.attempt==tactical._action_attempt: followup_time=receipt.local_datetime+" / simulation %.3fs" % receipt.simulation_elapsed
			texts.append("ORIGINAL FOLLOW-UP / C-%03d / receipt %s\n%s" % [selected,followup_time,original.follow_up])
	if command.cyber.session.has_contact(selected) and analysis_filter.selected==0:
		var cyber_view: Dictionary = command.cyber.session.public_view(selected)
		var brief: String = "AUTHORED CYBER BRIEF / historical issue timestamp unavailable\n"+cyber_view.assessment+"\nConfidence: "+str(cyber_view.confidence)+"%\n"
		for source in cyber_view.sources: brief += source.source+": "+source.text+"\n"
		texts.append(brief)
	var superseded := {}
	for record in reports:
		if not record.get("supersedes","").is_empty(): superseded[record.supersedes]=record.report_id+" / "+record.get("local_datetime","Timestamp unavailable")
	for kind in ["SIGINT","Platform Profile","Trajectory Assessment","Follow-up Analysis"]:
		if analysis_filter.selected>0 and analysis_filter.get_item_text(analysis_filter.selected)!=kind: continue
		var group := []
		for record in reports:
			if record.source_type==kind: group.append(Presentation.full(record,superseded.get(record.report_id,"")))
		if not group.is_empty(): texts.append(kind.to_upper()+" / receipt chronology\n\n"+"\n\n".join(group))
	var op: Dictionary = command.operations.session.view(selected)
	if not op.is_empty(): texts.append("INVESTIGATION\n%s / ETA %s\nEscalation assessment snapshot: %s" % [op.investigation,preload("res://script/operations_ui.gd").time_text(op.eta),JSON.stringify(op.escalation_evidence)])
	analysis.text="No attributed detailed reports available." if texts.is_empty() else "\n\n".join(texts)
func populate_defenses(attack_id: int) -> void:
	for child in defenses.get_children(): defenses.remove_child(child); child.queue_free()
	var executable := []
	if command.cyber.session.has_contact(selected):
		for choice in command.cyber.session.public_view(selected).choices: executable.append(choice.defense_id)
	for option in model.options(attack_id,executable):
		var selected_option: Dictionary = option.duplicate(true)
		var control := Button.new()
		var state := "INFORMATIONAL ONLY"
		if option.executable:
			state="VALIDATED / requires escalation"
			if command.operations.session.view(selected).state=="ESCALATED": state="AVAILABLE / inspect and confirm"
			for choice in command.cyber.session.public_view(selected).choices:
				if choice.defense_id==option.defense_id and choice.used: state="ALREADY ISSUED / unavailable"
		control.text=option.name+" / "+state
		control.custom_minimum_size.y=38
		control.add_theme_font_size_override("font_size",17)
		defenses.add_child(control)
		control.pressed.connect(func(): inspect_defense(selected_option))
		var text := Label.new()
		text.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
		text.add_theme_font_size_override("font_size",17)
		text.text="Addresses suspected %s: %s\n%s" % [option.attack,option.purpose,option.limitations]
		defenses.add_child(text)
func inspect_defense(option: Dictionary) -> void:
	pending={"type":"cyber","defense_id":option.defense_id}
	var view: Dictionary = command.cyber.session.public_view(selected)
	var available: bool = option.executable and not view.is_empty() and command.operations.session.view(selected).state=="ESCALATED"
	if available:
		for choice in view.choices:
			if choice.defense_id==option.defense_id and choice.used: available=false
	confirmation.dialog_text="C-%03d / %s\nAddresses suspected %s, not a confirmed capability.\n%s\n%s\nPossible result: containment, partial, ineffective, disruption or unverified. Spacecraft movement is unchanged.\n%s" % [selected,option.name,option.attack,option.purpose,option.limitations,"Explicit confirmation executes the existing validated response." if available else "NOT CURRENTLY EXECUTABLE. Informational or requires escalation / unused validated response."]
	confirmation.get_ok_button().disabled=not available
	confirmation.popup_centered()
func open_operations() -> void:
	if command.operations.session.has_contact(selected):
		command.operations.ui.open_console(selected)
		body.hide()
	else:
		open_page(-1)
func decision(index: int) -> void:
	if index==1:
		var tactical = command.registry.contacts[selected].tactical
		if selected==tactical.encounter.active_contact_id:
			pending={"type":"original_defense"}
			confirmation.dialog_text="C-%03d / Existing abstract signal-interference defense.\nThis uses the accepted original encounter's deterministic rules, not a new catalog countermeasure or physical interception. Outcome and intent are not guaranteed. The authoritative deadline is checked at confirmation. No spacecraft destruction is modeled." % selected
			confirmation.get_ok_button().disabled=tactical.encounter.resolved
			confirmation.popup_centered()
		else:
			populate_defenses(int(model.view(selected).cyber[selected_hypothesis].attack_id))
			notice.text="Review a database defense; confirm only validated, available responses. Use Operational commands to escalate."
		return
	if index==3:
		pending={"type":"investigate"}
		var tactical = command.registry.contacts[selected].tactical
		var supported: bool = command.operations.session.can(selected,"investigate") or (selected==tactical.encounter.active_contact_id and not tactical.encounter.resolved and not tactical.encounter.investigated)
		confirmation.dialog_text="C-%03d / Request authored follow-up intelligence.\nThe report may be incorrect. No hidden capability is disclosed. Network investigations use the existing capacity and delay; original encounters use the accepted immediate follow-up.\nContinue monitoring is also available by canceling this proposal; no defensive action is issued." % selected
		confirmation.get_ok_button().disabled=not supported
	else:
		pending={"type":"physical"}
		var supported: bool = index==0 and not command.cyber.is_cyber_contact(selected) and command.operations.session.can(selected,"intercept")
		confirmation.dialog_text="C-%03d / %s\nPhysical assessment: %s\nThis is an authorization/abstract deployment, NOT verified interception or destruction.\n%s" % [selected,"Review physical interception" if index==0 else "Coordinated physical + cyber defense proposal",model.view(selected).physical.state,"Existing abstract interception is available. Confirming records its existing unverified result." if supported else "UNAVAILABLE: no matching physical/coordinated evaluator is implemented for this contact. No new action or effect will execute."]
		confirmation.get_ok_button().disabled=not supported
	confirmation.popup_centered()
func confirm_action() -> void:
	var result := {}
	if pending.type=="cyber":
		command.cyber.selected=selected
		var choices: Array = command.cyber.session.public_view(selected).choices
		for i in range(choices.size()):
			if choices[i].defense_id==pending.defense_id: result=command.cyber.respond(i); break
	elif pending.type=="physical": result=command.operations.execute(selected,"intercept")
	elif pending.type=="original_defense":
		var tactical = command.registry.contacts[selected].tactical
		tactical._on_attacker_selected(selected)
		tactical._on_command_requested("deploy")
		result={"ok":not tactical.after_actions.is_empty() and tactical.after_actions.back().acceptance=="COMMAND ACCEPTED","error":"See authoritative original receipt."}
	elif pending.type=="investigate":
		if command.operations.session.has_contact(selected): result=command.operations.execute(selected,"investigate")
		else:
			var tactical = command.registry.contacts[selected].tactical
			tactical._on_attacker_selected(selected)
			tactical._on_command_requested("investigate")
			result={"ok":not tactical.after_actions.is_empty() and tactical.after_actions.back().acceptance=="COMMAND ACCEPTED","error":"Original follow-up unavailable."}
	_signature=""
	render()
	notice.text="C-%03d / %s / %s. Details: After-Action & History." % [selected,"COMMAND ACCEPTED" if result.get("ok",false) else "COMMAND REJECTED",result.get("outcome","Recorded; consult authoritative receipt")]
