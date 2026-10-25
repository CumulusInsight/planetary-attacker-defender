extends "res://script/sliding_command_ui.gd"
## Stage 2 presentation only: every effect is delegated to accepted command owners.
const ViewModel=preload("res://script/visual_command_model.gd")
var visual_ready:=false
var section:="threat"
var left_mode:="contacts"
var visual_root: Control
var section_nodes:={}
var header_contact: Label
var header_deadline: Label
var header_receipt: Label
var back_button: Button
var cyber_metric: Dictionary
var physical_metric: Dictionary
var hypothesis_cards: Array=[]
var hypothesis_metrics: Array=[]
var hypothesis_labels: Array=[]
var recommendation_short: Label
var result_label: Label
var cyber_picker: OptionButton
var mapped_list: VBoxContainer
var mapped_scroll: ScrollContainer
var mapped_options: Array=[]
var mapped_statuses: Array=[]
var more_button: Button
var show_all_mappings:=false
var legacy_defense: Button
var operations_button: Button
var investigation_label: Label
var investigation_metric: Dictionary
var investigation_progress: ProgressBar
var investigation_command: Button
var monitor_label: Label
var monitor_metric: Dictionary
var physical_label: Label
var physical_review: Button
var overview_root: Control
var overview_cards:={}
var old_contacts: Array=[]
var contact_heading: Label
var drawer_heading: Label
var evidence_table: Tree
var evidence_items:={}
var evidence_records: Array=[]
var detail_scroll: ScrollContainer
var detail_text: Label
var detail_back: Button
var detail_open:=false
var history_contact: OptionButton
var history_center: OptionButton
var history_type: OptionButton
var history_recent: OptionButton
var displayed_timeline: Array=[]
var _evidence_signature:=""
var _right_signature:=""
var baseline_prose:=""
func _ready() -> void:
	super._ready()
	baseline_prose=threat_body.text
	build_visual()
	visual_ready=true
	refresh_views()
func metric(parent: Node, bounds: Rect2, title: String) -> Dictionary:
	var label:=make_label(parent,Rect2(bounds.position,Vector2(bounds.size.x,24)),16)
	label.text=title
	var value:=make_label(parent,Rect2(bounds.position+Vector2(0,24),Vector2(bounds.size.x,26)),18)
	var bar:=ProgressBar.new()
	bar.show_percentage=false
	bar.mouse_filter=Control.MOUSE_FILTER_IGNORE
	var fill:=StyleBoxFlat.new();fill.bg_color=Color("6aa8d2")
	var background:=StyleBoxFlat.new();background.bg_color=Color("344454")
	bar.add_theme_stylebox_override("fill",fill);bar.add_theme_stylebox_override("background",background)
	command.cyber.place(parent,bar,Rect2(bounds.position+Vector2(0,55),Vector2(bounds.size.x,10)))
	return {"label":label,"value":value,"bar":bar}
func set_metric(target: Dictionary, confidence: Variant, state: String="") -> void:
	target.bar.visible=confidence!=null
	if confidence!=null:target.bar.value=float(confidence)
	target.value.text="Unknown" if confidence==null and state=="Unknown" else (state+" / " if not state.is_empty() else "")+model.percent(confidence)
	target.value.add_theme_color_override("font_color",Color("d0dfeb") if confidence!=null else Color("9eacba"))
func evidence_label(text: String) -> String:
	# Compact labels quote the existing public evidence; the full source remains in the tooltip/evidence view.
	if text.contains("No capability-specific evidence"):return "Evidence unavailable"
	if text.contains("Initial public cyber hypothesis"):return "Initial hypothesis"
	if text.contains("ambiguous digital telemetry"):return "Ambiguous telemetry"
	return words(text,5)
func bind(button: Button, callback: Callable) -> void:
	for connection in button.get_signal_connection_list("pressed"):button.disconnect("pressed",connection.callable)
	button.pressed.connect(callback)
func build_visual() -> void:
	for child in panels.threat.get_children():child.hide()
	pin_buttons.threat.show();close_buttons.threat.show()
	for child in panels.threat.get_children():
		if child is Label and child.position.y==12:child.text="THREAT & RESPONSE";child.show()
	visual_root=Control.new();visual_root.mouse_filter=Control.MOUSE_FILTER_IGNORE
	command.cyber.place(panels.threat,visual_root,Rect2(18,52,604,662))
	back_button=make_button(visual_root,"< Threat",Rect2(0,0,120,30),func():show_section("threat"))
	header_contact=make_label(visual_root,Rect2(134,0,470,30),18)
	header_deadline=make_label(visual_root,Rect2(0,36,604,24),16)
	header_receipt=make_label(visual_root,Rect2(0,64,604,24),16)
	for mode in ["threat","cyber","investigate","monitor","physical"]:
		var node:=Control.new();node.mouse_filter=Control.MOUSE_FILTER_IGNORE
		command.cyber.place(visual_root,node,Rect2(0,102,604,506))
		section_nodes[mode]=node
	cyber_metric=metric(section_nodes.threat,Rect2(0,0,286,70),"CYBER / initial confidence")
	physical_metric=metric(section_nodes.threat,Rect2(310,0,294,70),"PHYSICAL / analyst confidence")
	make_label(section_nodes.threat,Rect2(0,70,604,22),16).text="HYPOTHESES / independent likelihoods"
	for i in range(3):
		var index:=i
		var card:=Panel.new();command.cyber.place(section_nodes.threat,card,Rect2(0,92+i*78,604,70))
		hypothesis_cards.append(make_button(card,"",Rect2(8,3,218,31),func():selected_hypothesis=index;show_section("cyber")))
		var meter:=metric(card,Rect2(244,-18,230,65),"")
		meter.label.hide();meter.value.position=Vector2(490,5);meter.value.size=Vector2(106,26)
		meter.bar.position=Vector2(244,15)
		hypothesis_metrics.append(meter)
		hypothesis_labels.append(make_label(card,Rect2(12,39,580,26),16))
	recommendation_short=make_label(section_nodes.threat,Rect2(0,342,604,60),18)
	make_button(section_nodes.threat,"Evidence / details",Rect2(0,424,290,38),func():show_drawer("intelligence"))
	make_button(section_nodes.threat,"Coordinated proposal",Rect2(310,424,294,38),func():decision(2))
	cyber_picker=OptionButton.new();command.cyber.place(section_nodes.cyber,cyber_picker,Rect2(0,0,604,36))
	cyber_picker.item_selected.connect(func(index):selected_hypothesis=index;show_all_mappings=false;_right_signature="";refresh_views())
	mapped_scroll=ScrollContainer.new();mapped_scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
	command.cyber.place(section_nodes.cyber,mapped_scroll,Rect2(0,48,604,386))
	mapped_list=VBoxContainer.new();mapped_list.size_flags_horizontal=Control.SIZE_EXPAND_FILL;mapped_list.add_theme_constant_override("separation",10);mapped_scroll.add_child(mapped_list)
	more_button=make_button(section_nodes.cyber,"More mapped controls",Rect2(0,448,290,36),func():show_all_mappings=not show_all_mappings;_right_signature="";refresh_views())
	legacy_defense=make_button(section_nodes.cyber,"Existing encounter defense (review)",Rect2(0,448,604,36),func():decision(1))
	operations_button=make_button(section_nodes.cyber,"Escalation / commands",Rect2(310,448,294,36),open_operations)
	original_hold.reparent(section_nodes.cyber);original_hold.position=Vector2(0,448)
	original_replay.reparent(section_nodes.cyber);original_replay.position=Vector2(310,448)
	investigation_label=make_label(section_nodes.investigate,Rect2(0,0,604,130),20)
	investigation_metric=metric(section_nodes.investigate,Rect2(0,142,604,70),"EVIDENCE CONFIDENCE / latest report")
	investigation_progress=ProgressBar.new();investigation_progress.show_percentage=true;investigation_progress.mouse_filter=Control.MOUSE_FILTER_IGNORE
	command.cyber.place(section_nodes.investigate,investigation_progress,Rect2(0,234,604,22))
	investigation_command=make_button(section_nodes.investigate,"Request investigation",Rect2(0,352,604,44),review_investigation)
	make_button(section_nodes.investigate,"Evidence / details",Rect2(0,418,604,38),func():show_drawer("intelligence"))
	monitor_metric=metric(section_nodes.monitor,Rect2(0,0,604,70),"PUBLIC ASSESSMENT / confidence")
	monitor_label=make_label(section_nodes.monitor,Rect2(0,108,604,210),18)
	make_button(section_nodes.monitor,"Continue monitoring",Rect2(0,352,604,44),func():close_panel("threat",true))
	make_button(section_nodes.monitor,"Tracking / command options",Rect2(0,418,604,38),open_operations)
	physical_label=make_label(section_nodes.physical,Rect2(0,0,604,270),19)
	physical_review=make_button(section_nodes.physical,"Review physical authorization",Rect2(0,352,604,44),review_physical)
	make_button(section_nodes.physical,"Evidence / details",Rect2(0,418,604,38),func():show_drawer("intelligence"))
	result_label=make_label(visual_root,Rect2(0,614,604,48),17)
	concern_filter.add_item("Attention / public criteria");concern_filter.add_item("Active investigations only")
	build_overview()
	build_evidence()
	bind(quick.Investigate,func():show_section("investigate"))
	bind(quick.Monitor,func():show_section("monitor"))
	bind(quick["Cyber Defense"],func():show_section("cyber"))
	bind(quick["Physical Defense"],func():show_section("physical"))
	quick.History.text="Commands";bind(quick.History,open_operations)
	# The original scorecard signal/calculations remain untouched; only its control layout changes.
	command.mission_ui.close_button.text="Close"
	command.mission_ui.close_button.position=Vector2(1040,16)
	command.mission_ui.close_button.size=Vector2(256,40)
	command.mission_ui.card_title.size.x=990
	command.mission_ui.card.theme=shell.theme
	command.operations.ui.close_button.text="Close"
func build_overview() -> void:
	old_contacts=panels.contacts.get_children().duplicate()
	for node in old_contacts:
		if node is Label and node.position.y==12:contact_heading=node
	overview_root=Control.new();overview_root.mouse_filter=Control.MOUSE_FILTER_IGNORE
	command.cyber.place(panels.contacts,overview_root,Rect2(18,60,604,640))
	var specs: Array=[["contacts","Monitored contacts"],["attention","Require attention"],["investigations","Active investigations"],["escalated","Escalated contacts"],["centers","Centers with alerts"],["deadlines","Active deadlines"]]
	for i in range(specs.size()):
		var key: String=specs[i][0]
		overview_cards[key]=make_button(overview_root,specs[i][1],Rect2((i%2)*310,(i/2 as int)*156,294,136),func():overview_filter(key))
func build_evidence() -> void:
	for node in panels.drawer.get_children():
		if node is Label and node.position.y==12:drawer_heading=node
	drawer_scroll.hide()
	evidence_table=Tree.new();evidence_table.hide_root=true;evidence_table.column_titles_visible=true;evidence_table.select_mode=Tree.SELECT_ROW;evidence_table.allow_reselect=true
	evidence_table.add_theme_font_size_override("font_size",16);evidence_table.add_theme_constant_override("v_separation",10)
	command.cyber.place(panels.drawer,evidence_table,Rect2(18,104,1532,258))
	evidence_table.item_selected.connect(show_evidence_details)
	detail_scroll=ScrollContainer.new();detail_scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
	command.cyber.place(panels.drawer,detail_scroll,Rect2(18,104,1532,258))
	detail_text=Label.new();detail_text.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;detail_text.size_flags_horizontal=Control.SIZE_EXPAND_FILL;detail_text.add_theme_font_size_override("font_size",17);detail_scroll.add_child(detail_text);detail_scroll.hide()
	detail_back=make_button(panels.drawer,"< Back to list",Rect2(410,54,230,34),func():detail_open=false;refresh_evidence(true))
	detail_back.hide()
	history_contact=OptionButton.new();history_contact.add_item("Selected contact");history_contact.add_item("All contacts")
	for id in command.registry.contacts:history_contact.add_item("C-%03d" % id,id+100)
	history_center=OptionButton.new();history_center.add_item("All centers")
	for center in command.tactical_centers:history_center.add_item(center)
	history_type=OptionButton.new();history_type.add_item("All event types")
	history_recent=OptionButton.new()
	for title in ["All recorded time","Last 5 real minutes","Last real hour","Last real day"]:history_recent.add_item(title)
	for node in [history_contact,history_center,history_type,history_recent]:
		panels.drawer.add_child(node);node.add_theme_font_size_override("font_size",16);node.fit_to_longest_item=false
		node.item_selected.connect(func(_index):_evidence_signature="";refresh_evidence(true))
	bind(intel_tab,func():show_drawer("intelligence"));bind(history_tab,func():show_drawer("history"))
func show_section(mode: String) -> void:
	section=mode;_right_signature="";open_panel("threat");refresh_views()
func command_icon(key: String) -> void:
	if not visual_ready:super.command_icon(key);return
	match key:
		"overview","contacts":
			if opened.contacts and left_mode==key:close_panel("contacts",true)
			else:left_mode=key;open_panel("contacts")
			command.command_level="operations";role_select.select(1)
		"threat":
			if opened.threat and section=="threat":close_panel("threat",true)
			else:show_section("threat")
		_ :super.command_icon(key)
	refresh_visual_left()
func open_page(index: int,id: int=-1) -> void:
	if not visual_ready:super.open_page(index,id);return
	if id>=0:select_contact(id)
	match index:
		0:left_mode="overview";open_panel("contacts")
		1:show_section("threat")
		2:show_drawer("intelligence")
		3:show_drawer("history")
		_:super.open_page(index,id)
func select_contact(id: int) -> void:
	super.select_contact(id)
	if visual_ready:section="threat";detail_open=false;_right_signature="";_evidence_signature=""
func show_drawer(mode: String) -> void:
	super.show_drawer(mode)
	if visual_ready:detail_open=false;_evidence_signature="";refresh_evidence(true)
func layout_panels() -> void:
	super.layout_panels()
	if visual_ready:layout_evidence()
func _process(delta: float) -> void:
	super._process(delta)
	if not visual_ready:return
	refresh_visual_left()
	command.mission_ui.card_title.text=command.mission_ui.card_title.text.get_slice(" - ",0)
	top_buttons.overview.set_pressed_no_signal(active_panel=="contacts" and left_mode=="overview")
	top_buttons.contacts.set_pressed_no_signal(active_panel=="contacts" and left_mode=="contacts")
	refresh_evidence()
func refresh_views() -> void:
	if not visual_ready:super.refresh_views();return
	if not model.contacts.has(selected):return
	var profile: Dictionary=model.view(selected)
	var tactical=command.registry.contacts[selected].tactical
	var reports: Array=tactical.intelligence.history(selected)
	var latest: Dictionary=reports.back() if not reports.is_empty() else {}
	var operation: Dictionary=command.operations.session.view(selected)
	var original: bool=selected==tactical.encounter.active_contact_id
	header_contact.text="C-%03d / %s / %s" % [selected,profile.center_id,operation.get("state",tactical.encounter.public_view(selected).status)]
	var seconds: Variant=tactical.deadline.remaining(tactical.active_contact) if original and not tactical.encounter.resolved else operation.get("remaining")
	header_deadline.text="Deadline: "+(command.registry.time_text(seconds) if seconds!=null else "No confirmed deadline")
	header_receipt.text="Updated: "+latest.get("local_datetime","Time unavailable")
	back_button.visible=section!="threat"
	for mode in section_nodes:section_nodes[mode].visible=mode==section
	var public_cyber: Dictionary=command.cyber.session.public_view(selected)
	set_metric(cyber_metric,public_cyber.get("confidence"),"Uncertain" if not public_cyber.is_empty() else "Unknown")
	cyber_metric.value.tooltip_text="Confidence in the original authored cyber assessment, not combined cyber risk. "+public_cyber.get("assessment","")
	set_metric(physical_metric,profile.physical.confidence,physical_state(profile.physical.state))
	for i in range(3):
		var h: Dictionary=profile.cyber[i];var attack: Dictionary=model.attacks[int(h.attack_id)]
		hypothesis_cards[i].text=attack.attack_name
		set_metric(hypothesis_metrics[i],h.likelihood)
		hypothesis_labels[i].text=attack.severity+"  /  "+evidence_label(h.evidence)
		hypothesis_labels[i].tooltip_text=h.evidence
	recommendation_short.text="ADVISORY  /  "+words(profile.recommendation.text,8)+"  /  "+model.percent(profile.recommendation.confidence)
	var result: Dictionary=public_cyber.get("result",{})
	result_label.text="" if result.is_empty() else result.outcome.to_upper()+"  /  Spacecraft remains in orbit\n"+words(result.observation,12)
	if result.is_empty() and original and not tactical.after_actions.is_empty():
		var receipt: Dictionary=tactical.after_actions.back()
		if receipt.contact_id==selected and receipt.attempt==tactical._action_attempt:result_label.text=receipt.acceptance+" / "+receipt.disposition+"\n"+words(receipt.observation,12)
	var signature: String="%d/%d/%d/%s/%s" % [selected,selected_hypothesis,command.operations.session.revision,str(show_all_mappings),str(public_cyber.get("result",{}))+str(command.cyber.journal.size())]
	if section=="cyber" and signature!=_right_signature:
		_right_signature=signature;render_mapped(profile,public_cyber,operation,original)
	if section=="investigate":render_investigation(tactical,latest)
	if section=="monitor":
		set_metric(monitor_metric,latest.get("confidence"),latest.get("assessment","Unknown"))
		monitor_label.text="State: %s\nReceipt: %s\nReal age: %s\n%s\nNo automatic intelligence changes" % [operation.get("state",tactical.encounter.public_view(selected).status),latest.get("local_datetime","Time unavailable"),ViewModel.age(latest),ViewModel.trend(reports)]
	if section=="physical":
		var supported: bool=not command.cyber.is_cyber_contact(selected) and command.operations.session.can(selected,"intercept")
		var reason: String="Abstract authorization available; result unverified" if supported else "Requires escalation" if not command.cyber.is_cyber_contact(selected) and operation.get("state") in ["MONITORED","WATCHLIST","INVESTIGATING"] else "Unavailable / no matching physical evaluator"
		physical_label.text="WEAPON SUSPECTED  /  %s\nConfidence: %s\n\nTARGET  /  %s DATA\n\n%s" % [physical_state(profile.physical.state),model.percent(profile.physical.confidence),profile.center_id,reason]
		physical_review.text="Review abstract authorization" if supported else "Review unavailable proposal"
static func physical_state(state: String) -> String:
	return {"Suspected physical weapon":"Yes / suspected","No physical weapon currently suspected":"No current indication","Unknown / insufficient evidence":"Unknown"}.get(state,"Unknown")
static func words(text: String,count: int) -> String:
	var parts:=text.split(" ",false)
	return " ".join(parts.slice(0,count))+("..." if parts.size()>count else "")
func render_mapped(profile: Dictionary, public_cyber: Dictionary, operation: Dictionary, original: bool) -> void:
	cyber_picker.clear()
	for h in profile.cyber:cyber_picker.add_item("%s / attack ID %d" % [model.attacks[int(h.attack_id)].attack_name,h.attack_id])
	cyber_picker.select(selected_hypothesis)
	var choices: Array=public_cyber.get("choices",[])
	mapped_options=model.options(int(profile.cyber[selected_hypothesis].attack_id),choices.map(func(c):return c.defense_id))
	mapped_statuses.clear()
	for child in mapped_list.get_children():mapped_list.remove_child(child);child.queue_free()
	var visible_options: Array=mapped_options if show_all_mappings else mapped_options.slice(0,3)
	if visible_options.is_empty():
		var missing:=Label.new();missing.text="No reliable catalog mapping available.";mapped_list.add_child(missing)
	for option in visible_options:
		var selected_option: Dictionary=option.duplicate(true)
		var status: String=ViewModel.availability(option,choices,operation);mapped_statuses.append(status)
		var card:=Panel.new();card.custom_minimum_size=Vector2(0,116);mapped_list.add_child(card)
		make_label(card,Rect2(10,6,570,28),18).text=option.name+" / defense ID %d" % option.defense_id
		make_label(card,Rect2(10,36,570,44),16).text=words(option.purpose,15)
		make_label(card,Rect2(10,84,365,27),16).text=status
		make_button(card,"Review",Rect2(440,80,134,30),func():inspect_defense(selected_option))
	more_button.visible=mapped_options.size()>3
	legacy_defense.visible=original
	legacy_defense.size.x=294
	legacy_defense.position.y=400 if original else 448
	operations_button.visible=not original
	original_hold.visible=original;original_replay.visible=original
	if original:
		var tactical=command.registry.contacts[selected].tactical
		original_hold.disabled=tactical.encounter.resolved
		original_replay.disabled=not (tactical.encounter.resolved or tactical.encounter.investigated)
	mapped_scroll.size.y=336 if original else 386
	more_button.text="First three" if show_all_mappings else "More mapped controls"
func render_investigation(tactical: Node,latest: Dictionary) -> void:
	var data: Dictionary=ViewModel.investigation(command.operations.session,selected)
	var original: bool=selected==tactical.encounter.active_contact_id
	var state_text: String=data.state.capitalize()
	if data.state=="queued":state_text="Queued / position %d" % data.position
	elif data.state=="active":state_text="Investigation active"
	elif original:state_text="Follow-up received" if tactical.encounter.investigated else "Immediate authored follow-up available"
	investigation_label.text="%s\n%d / %d slots active\nNext report: %s\nCompleteness: not measured" % [state_text,data.active,data.capacity,command.registry.time_text(data.eta) if data.eta!=null else "Not scheduled"]
	set_metric(investigation_metric,latest.get("confidence"))
	investigation_progress.visible=data.progress!=null
	if data.progress!=null:investigation_progress.value=data.progress
	investigation_command.disabled=not (command.operations.session.can(selected,"investigate") or (original and not tactical.encounter.investigated and not tactical.encounter.resolved))
	investigation_command.text="Request investigation / queue if occupied" if data.active>=data.capacity and not original else "Request investigation"
func review_investigation() -> void:
	decision(3)
	confirmation.dialog_text="C-%03d / Request the existing authored follow-up.\nEvidence may be incomplete or incorrect.\nTwo active slots; further requests queue FIFO.\nConfirming requests intelligence, not a defense." % selected
func review_physical() -> void:
	decision(0)
	confirmation.dialog_text="C-%03d / Physical authorization review\n%s\nTarget: %s\n%s\nNo verified interception or destruction is modeled." % [selected,model.view(selected).physical.state,command.registry.contacts[selected].center_id,"Existing abstract authorization only." if not confirmation.get_ok_button().disabled else "Unavailable: no executable action in the current state."]
func inspect_defense(option: Dictionary) -> void:
	super.inspect_defense(option)
	var status: String=ViewModel.availability(option,command.cyber.session.public_view(selected).get("choices",[]),command.operations.session.view(selected))
	confirmation.dialog_text="C-%03d / %s / defense ID %d\nAddresses suspected %s\n%s\n%s\n%s\nScenario-specific effectiveness; no success guarantee." % [selected,option.name,option.defense_id,option.attack,option.purpose,status,"Confirm executes the accepted response." if not confirmation.get_ok_button().disabled else "Execution disabled. Review does not deploy this control."]
func open_operations() -> void:
	var tactical=command.registry.contacts[selected].tactical
	if selected==tactical.encounter.active_contact_id:show_section("cyber")
	else:super.open_operations()
func open_responses() -> void:show_section("cyber")
func monitor_review() -> void:show_section("monitor")
func refresh_visual_left() -> void:
	for node in old_contacts:
		if node not in [pin_buttons.contacts,close_buttons.contacts,contact_heading]:node.visible=left_mode=="contacts"
	contact_heading.text="COMMAND OVERVIEW" if left_mode=="overview" else "CONTACTS"
	overview_root.visible=left_mode=="overview"
	var rows: Array=command.registry.public_rows();var operations=command.operations.session
	var attention_ids: Array=rows.filter(func(row):return (row.remaining!=null and row.remaining<=60) or row.status=="Deadline expired" or operations.view(row.contact_id).get("state")=="ESCALATED")
	var centers:={}
	for row in attention_ids:centers[row.center_id]=true
	var values: Dictionary={"contacts":rows.size(),"attention":attention_ids.size(),"investigations":operations.statistics().active,"escalated":operations.statistics().unresolved_escalations,"centers":centers.size(),"deadlines":rows.filter(func(row):return row.remaining!=null).size()}
	var names: Dictionary={"contacts":"Monitored contacts","attention":"Require attention","investigations":"Active investigations","escalated":"Escalated contacts","centers":"Centers with alerts","deadlines":"Active deadlines"}
	for key in overview_cards:overview_cards[key].text="%d\n%s" % [values[key],names[key]]
func public_rows() -> Array:
	var rows: Array=super.public_rows()
	if concern_filter.selected==4:rows=rows.filter(func(row):return (row.remaining!=null and row.remaining<=60) or row.status=="Deadline expired" or command.operations.session.view(row.contact_id).get("state")=="ESCALATED")
	elif concern_filter.selected==5:rows=rows.filter(func(row):return command.operations.session.view(row.contact_id).get("investigation")=="active")
	return rows
func overview_filter(key: String) -> void:
	left_mode="contacts";center_filter.select(0);concern_filter.select(1 if key=="deadlines" else 2 if key=="escalated" else 5 if key=="investigations" else 4 if key in ["attention","centers"] else 0)
	_table_signature="";refresh_contacts();refresh_visual_left()
func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode==KEY_ESCAPE and command.scorecard_open:
		command.show_scorecard(false);get_viewport().set_input_as_handled();return
	super._unhandled_key_input(event)
func layout_evidence() -> void:
	var width: float=panels.drawer.size.x-36
	evidence_table.size.x=width;detail_scroll.size.x=width
	var history: bool=drawer_mode=="history"
	evidence_table.position.y=148 if history else 104;evidence_table.size.y=214 if history else 258
	detail_scroll.position.y=104;detail_scroll.size.y=258
	history_contact.position=Vector2(410,54);history_contact.size=Vector2(220,34)
	history_center.position=Vector2(642,54);history_center.size=Vector2(minf(230,width-646),34)
	history_type.position=Vector2(18,100);history_type.size=Vector2(370,34)
	history_recent.position=Vector2(410,100);history_recent.size=Vector2(370,34)
func refresh_evidence(force: bool=false) -> void:
	if not visual_ready:return
	layout_evidence()
	drawer_scroll.hide()
	drawer_heading.text="DECISION TIMELINE" if drawer_mode=="history" else "EVIDENCE"
	for filter_control in [history_contact,history_center,history_type,history_recent]:filter_control.visible=drawer_mode=="history" and not detail_open
	drawer_filter.visible=drawer_mode=="intelligence" and not detail_open
	detail_back.visible=detail_open;detail_scroll.visible=detail_open;evidence_table.visible=not detail_open
	if detail_open:return
	var signature: String="%d/%d/%d/%s/%d/%d/%d/%d/%d/%d" % [selected,command.cyber.journal.size(),command.registry.contacts[selected].tactical.intelligence.revision,drawer_mode,drawer_filter.selected,history_contact.selected,history_center.selected,history_type.selected,history_recent.selected,int(Time.get_unix_time_from_system())]
	if signature==_evidence_signature and not force:return
	_evidence_signature=signature
	if drawer_mode=="history":render_timeline()
	elif drawer_mode=="intelligence":render_report_list()
	else:
		evidence_table.hide();drawer_text.show();drawer_scroll.show()
func configure_evidence(headings: Array,widths: Array,keys: Array) -> void:
	var signature: String=str(headings)+str(keys)
	if evidence_table.get_meta("population","")!=signature:
		evidence_table.clear();evidence_items.clear();evidence_table.columns=headings.size();var root:=evidence_table.create_item()
		for i in range(headings.size()):
			evidence_table.set_column_title(i,headings[i]);evidence_table.set_column_expand(i,false);evidence_table.set_column_custom_minimum_width(i,widths[i])
		for key in keys:
			var item:=evidence_table.create_item(root);item.set_metadata(0,key);evidence_items[key]=item
		evidence_table.set_meta("population",signature)
func render_report_list() -> void:
	var tactical=command.registry.contacts[selected].tactical
	var reports: Array=tactical.intelligence.history(selected)
	var superseded:={}
	for r in reports:
		if not r.get("supersedes","").is_empty():superseded[r.supersedes]=r.report_id+" / "+r.get("local_datetime","Time unavailable")
	if analysis_filter.selected>0:reports=reports.filter(func(r):return r.source_type==analysis_filter.get_item_text(analysis_filter.selected))
	evidence_records=[]
	for r in reports:evidence_records.append({"key":r.report_id,"cells":[r.source_type,"C-%03d / %s" % [selected,command.registry.contacts[selected].center_id],r.get("local_datetime","Time unavailable"),"%.2fs" % r.simulation_elapsed if r.has("simulation_elapsed") else "Unavailable","Superseded" if superseded.has(r.report_id) else "Current",words(r.text,12)],"details":Presentation.full(r,superseded.get(r.report_id,""))})
	page=2;_signature="";render()
	var profile: Dictionary=model.view(selected)
	var full: String=analysis.text+"\n\nPUBLIC HYPOTHESIS DETAIL\n"+JSON.stringify(profile,"\t")
	evidence_records.append({"key":"briefs","cells":["Briefs / full context","C-%03d / %s" % [selected,profile.center_id],"Historical time unavailable","Not recorded","Context","Original reports and supporting/conflicting evidence"],"details":full})
	configure_evidence(["Source","Contact / center","Authentic receipt","Simulation","Status","Evidence"],[190,175,285,120,140,570],evidence_records.map(func(r):return r.key))
	for record in evidence_records:
		for i in range(record.cells.size()):evidence_items[record.key].set_text(i,record.cells[i])
func filtered_timeline() -> Array:
	var result: Array=command.cyber.journal.duplicate(true)
	if history_contact.selected==0:result=result.filter(func(e):return e.contact_id==selected)
	elif history_contact.selected>1:
		var contact: int=history_contact.get_selected_id()-100
		result=result.filter(func(e):return e.contact_id==contact)
	if history_center.selected>0:result=result.filter(func(e):return e.get("center_id")==history_center.get_item_text(history_center.selected))
	if history_type.selected>0:result=result.filter(func(e):return e.kind==history_type.get_item_text(history_type.selected))
	if history_recent.selected>0:
		var seconds: int=[0,300,3600,86400][history_recent.selected]
		result=result.filter(func(e):return ViewModel.epoch(e)!=null and Time.get_unix_time_from_system()-ViewModel.epoch(e)>=0 and Time.get_unix_time_from_system()-ViewModel.epoch(e)<=seconds)
	result.sort_custom(func(a,b):
		var at: Variant=ViewModel.epoch(a);var bt: Variant=ViewModel.epoch(b)
		if (at==null)!=(bt==null):return at!=null
		if at!=null and at!=bt:return at<bt
		return a.sequence<b.sequence)
	return result
func render_timeline() -> void:
	var kinds: Array=[]
	for e in command.cyber.journal:
		if not kinds.has(e.kind):kinds.append(e.kind)
	var current: String=history_type.get_item_text(history_type.selected)
	if history_type.item_count!=kinds.size()+1:
		history_type.clear();history_type.add_item("All event types")
		for kind in kinds:history_type.add_item(kind)
		for i in range(history_type.item_count):
			if history_type.get_item_text(i)==current:history_type.select(i)
	displayed_timeline=filtered_timeline();evidence_records=[]
	for e in displayed_timeline:evidence_records.append({"key":str(e.sequence),"cells":[e.get("local_datetime","Time unavailable"),ViewModel.age(e),"%.2fs" % e.simulation_elapsed if e.has("simulation_elapsed") else "Unavailable","C-%03d / %s" % [e.contact_id,e.get("center_id","")],e.kind,ViewModel.outcome(e)],"details":"RECORDED EVENT / full public details\nReal age: "+ViewModel.age(e)+"\n"+JSON.stringify(e,"\t")})
	configure_evidence(["Real recorded time / offset","Real age","Simulation","Contact / center","Event","Outcome / status"],[340,160,105,175,225,470],evidence_records.map(func(r):return r.key))
	for record in evidence_records:
		for i in range(record.cells.size()):evidence_items[record.key].set_text(i,record.cells[i])
func show_evidence_details() -> void:
	var item:=evidence_table.get_selected()
	if item==null:return
	for record in evidence_records:
		if record.key==item.get_metadata(0):detail_text.text=record.details;break
	detail_open=true;refresh_evidence(true)
