extends "res://script/decision_pages.gd"
## Presentation adapter only. Inherits accepted assessment/report projection and command confirmation.
const SORT_COLUMNS = [0,1,4,3,5,2,6]
var ready_ui := false
var shell: Control
var panels := {}
var opened := {}
var tweens := {}
var pinned := ""
var active_panel := ""
var top_buttons := {}
var pin_buttons := {}
var close_buttons := {}
var contact_table: Tree
var center_filter: OptionButton
var concern_filter: OptionButton
var contact_summary: Label
var drawer_text: Label
var drawer_scroll: ScrollContainer
var drawer_filter: OptionButton
var intel_tab: Button
var history_tab: Button
var drawer_mode := "intelligence"
var threat_title: Label
var threat_body: Label
var response_scroll: ScrollContainer
var response_select: OptionButton
var summary_toggle: Button
var response_toggle: Button
var response_mode := false
var status_strip: Label
var feedback: Label
var center_control: OptionButton
var role_select: OptionButton
var original_hold: Button
var original_replay: Button
var mode_select: OptionButton
var pause_button: CheckButton
var quick := {}
var table_sort := 0
var table_ascending := true
var table_rows := {}
var _table_signature := ""
var _view_signature := ""
var _table_building := false
var _last_message := ""
func _ready() -> void:
	super._ready()
	layer=60
	process_priority=50 # Hide legacy presentation after its controllers refresh; simulation priorities unchanged.
	get_child(0).hide() # Keep legacy presentation objects as adapters, not visible duplicate pages.
	build_sliding()
	confirmation.reparent(shell)
	command.operations.ui.layer=70
	ready_ui=true
	selected=1
	command.focus_center("DC-01",selected)
	refresh_views()
	clean_legacy()
func make_label(parent: Node, bounds: Rect2, font_size: int=17) -> Label:
	return command.cyber.label(parent,bounds,font_size)
func make_button(parent: Node, title: String, bounds: Rect2, callback: Callable) -> Button:
	return command.cyber.button(parent,title,bounds,callback)
func build_sliding() -> void:
	shell=Control.new()
	shell.size=Vector2(1600,900)
	shell.mouse_filter=Control.MOUSE_FILTER_IGNORE
	var theme:=Theme.new()
	theme.default_font=load("res://fonts/routed-gothic-wide.ttf")
	theme.default_font_size=17
	var style:=StyleBoxFlat.new()
	style.bg_color=Color("172330")
	style.border_color=Color("41566c")
	style.set_border_width_all(1)
	style.corner_radius_top_left=6
	style.corner_radius_top_right=6
	style.corner_radius_bottom_left=6
	style.corner_radius_bottom_right=6
	theme.set_stylebox("panel","Panel",style)
	var button_style: StyleBoxFlat=style.duplicate()
	button_style.bg_color=Color("233548")
	theme.set_stylebox("normal","Button",button_style)
	shell.theme=theme
	add_child(shell)
	var bar:=Panel.new()
	command.cyber.place(shell,bar,Rect2(12,6,1576,42))
	var commands: Array=[["overview","O","Command Overview"],["contacts","C","Contacts / sorting and display filters"],["threat","T","Threat Assessment / selected contact"],["intelligence","I","Intelligence reports and source history"],["history","H","Decision History / after-action records"],["mission","M","Mission Status / accepted scorecard"],["alerts","!","Alerts / applicable deadlines only"]]
	for i in range(commands.size()):
		var key: String=commands[i][0]
		top_buttons[key]=make_button(bar,commands[i][1],Rect2(8+i*54,4,48,34),func(): command_icon(key))
		top_buttons[key].tooltip_text=commands[i][2]
		top_buttons[key].toggle_mode=true
	center_control=OptionButton.new()
	for id in command.tactical_centers: center_control.add_item(id)
	command.cyber.place(bar,center_control,Rect2(408,4,160,34))
	center_control.tooltip_text="Tactical data center; preserves all contact clocks"
	center_control.item_selected.connect(func(index):
		var center: String=center_control.get_item_text(index)
		var id: int=command.tactical_centers[center].selected_attack_id
		select_contact(id if id>=0 else command.tactical_centers[center].encounter.active_contact_id))
	mode_select=OptionButton.new()
	mode_select.add_item("Learning Mode"); mode_select.add_item("Active Challenge")
	command.cyber.place(bar,mode_select,Rect2(586,4,240,34))
	mode_select.item_selected.connect(func(index):command.set_learning_mode(index==0))
	pause_button=CheckButton.new()
	pause_button.text="Strategic pause"
	pause_button.add_theme_font_size_override("font_size",16)
	command.cyber.place(bar,pause_button,Rect2(848,4,245,34))
	pause_button.toggled.connect(command.set_strategic_pause)
	role_select=OptionButton.new()
	role_select.add_item("Tactical Officer");role_select.add_item("Operations Commander")
	command.cyber.place(bar,role_select,Rect2(1120,4,310,34))
	role_select.tooltip_text="Command responsibility; never changes encounter rules"
	role_select.item_selected.connect(func(index):
		command.command_level="tactical" if index==0 else "operations"
		if index==1:open_panel("contacts")
		else:open_panel("threat"))
	var brand:=make_label(bar,Rect2(1460,7,100,30),18)
	brand.text="ODC"
	status_strip=make_label(shell,Rect2(1260,52,324,60),16)
	status_strip.add_theme_color_override("font_color",Color("b8cee1"))
	for key in ["contacts","threat","drawer"]:
		var panel:=Panel.new()
		command.cyber.place(shell,panel,Rect2(0,112,640,724) if key!="drawer" else Rect2(16,456,1568,380))
		panels[key]=panel
		opened[key]=false
		make_label(panel,Rect2(18,12,380,30),20).text={"contacts":"CONTACTS / NETWORK","threat":"THREAT ASSESSMENT","drawer":"INTELLIGENCE / HISTORY"}[key]
		pin_buttons[key]=make_button(panel,"Pin",Rect2(434,10,90,32),func(): toggle_pin(key))
		pin_buttons[key].tooltip_text="Keep this panel open. One pinned panel at a time."
		close_buttons[key]=make_button(panel,"Close",Rect2(532,10,90,32),func(): close_panel(key,true))
		panel.hide()
	center_filter=OptionButton.new()
	center_filter.add_item("All centers")
	for id in command.tactical_centers: center_filter.add_item(id)
	command.cyber.place(panels.contacts,center_filter,Rect2(18,58,275,36))
	center_filter.item_selected.connect(func(_index):_table_signature=""; refresh_contacts())
	concern_filter=OptionButton.new()
	for title in ["All monitored contacts","Active deadlines","Operational concerns","Watchlist / investigating"]: concern_filter.add_item(title)
	command.cyber.place(panels.contacts,concern_filter,Rect2(310,58,312,36))
	concern_filter.item_selected.connect(func(_index):_table_signature=""; refresh_contacts())
	var hint:=make_label(panels.contacts,Rect2(18,104,604,44),16)
	hint.text="Click headers to sort; scroll sideways for assessment/state. Display filters only; no assessment values change."
	contact_table=Tree.new()
	contact_table.columns=7
	contact_table.hide_root=true
	contact_table.column_titles_visible=true
	contact_table.select_mode=Tree.SELECT_ROW
	contact_table.allow_reselect=true
	contact_table.add_theme_font_size_override("font_size",16)
	contact_table.add_theme_constant_override("v_separation",10)
	for i in range(7):
		contact_table.set_column_title(i,["Contact","Center","Severity","Confidence","Deadline","Assessment","State"][i])
		contact_table.set_column_expand(i,false)
		contact_table.set_column_custom_minimum_width(i,[85,80,145,115,130,290,210][i])
	command.cyber.place(panels.contacts,contact_table,Rect2(18,158,604,380))
	contact_table.column_title_clicked.connect(func(column,_mouse=1):
		if column==table_sort:table_ascending=not table_ascending
		else:table_sort=column;table_ascending=true
		_table_signature="";refresh_contacts())
	contact_table.item_selected.connect(func():
		if not _table_building and contact_table.get_selected()!=null: select_contact(int(contact_table.get_selected().get_metadata(0))))
	contact_summary=make_label(panels.contacts,Rect2(18,554,604,102),17)
	make_button(panels.contacts,"Open selected Threat Assessment",Rect2(18,670,604,40),func():open_panel("threat"))
	threat_title=make_label(panels.threat,Rect2(18,56,604,36),18)
	summary_toggle=make_button(panels.threat,"Assessment",Rect2(18,100,285,34),func():response_mode=false;_view_signature="";refresh_views())
	response_toggle=make_button(panels.threat,"Countermeasures",Rect2(320,100,302,34),open_responses)
	threat_body=make_label(panels.threat,Rect2(18,144,604,398),16)
	response_select=OptionButton.new()
	command.cyber.place(panels.threat,response_select,Rect2(18,148,604,36))
	response_select.item_selected.connect(func(index):selected_hypothesis=index;_view_signature="";refresh_views())
	response_scroll=ScrollContainer.new()
	response_scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
	command.cyber.place(panels.threat,response_scroll,Rect2(18,198,604,338))
	defenses.reparent(response_scroll)
	var actions: Array=[["Investigate",func():decision(3)],["Cyber Defense",open_responses],["Physical review",func():decision(0)],["Monitor",monitor_review],["Coordinated proposal",func():decision(2)],["Operational commands",open_operations]]
	for i in range(actions.size()):make_button(panels.threat,actions[i][0],Rect2(18+(i%2)*302,550+(i/2 as int)*46,294,40),actions[i][1])
	original_hold=make_button(panels.threat,"Hold fire (review)",Rect2(18,648,294,32),review_hold)
	original_replay=make_button(panels.threat,"Replay / practice (review)",Rect2(320,648,302,32),review_replay)
	make_button(panels.threat,"Extended evidence / Intelligence",Rect2(18,688,604,28),func():show_drawer("intelligence"))
	intel_tab=make_button(panels.drawer,"Intelligence",Rect2(18,54,190,34),func():show_drawer("intelligence"))
	history_tab=make_button(panels.drawer,"History",Rect2(218,54,170,34),func():show_drawer("history"))
	drawer_filter=OptionButton.new()
	command.cyber.place(panels.drawer,drawer_filter,Rect2(410,54,370,34))
	drawer_filter.item_selected.connect(func(index):
		if drawer_mode=="intelligence":analysis_filter.select(index)
		else:history_filter.select(index)
		_view_signature="";refresh_views())
	drawer_scroll=ScrollContainer.new()
	drawer_scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
	command.cyber.place(panels.drawer,drawer_scroll,Rect2(18,102,1532,260))
	drawer_text=Label.new()
	drawer_text.add_theme_font_size_override("font_size",17)
	drawer_text.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	drawer_text.size_flags_horizontal=Control.SIZE_EXPAND_FILL
	drawer_scroll.add_child(drawer_text)
	var quick_bar:=Panel.new()
	command.cyber.place(shell,quick_bar,Rect2(12,850,1576,44))
	var quick_actions: Array=[["Investigate",func():decision(3)],["Monitor",monitor_review],["Cyber Defense",func():open_panel("threat");open_responses()],["Physical Defense",func():open_panel("threat");decision(0)],["History",func():show_drawer("history")]]
	for i in range(quick_actions.size()):quick[quick_actions[i][0]]=make_button(quick_bar,quick_actions[i][0],Rect2(8+i*194,5,184,34),quick_actions[i][1])
	feedback=make_label(quick_bar,Rect2(992,7,570,30),16)
func command_icon(key: String) -> void:
	match key:
		"overview","contacts":
			if key=="overview":center_filter.select(0);concern_filter.select(0);_table_signature=""
			command.command_level="operations";role_select.select(1);toggle_panel("contacts")
		"threat":
			command.command_level="tactical";role_select.select(0);toggle_panel("threat")
		"intelligence","history":
			if opened.drawer and drawer_mode==key:close_panel("drawer")
			else:show_drawer(key)
		"alerts":show_drawer("alerts")
		"mission":command.show_scorecard(true)
func open_page(index: int, id: int=-1) -> void:
	if not ready_ui:super.open_page(index,id);return
	if id>=0:select_contact(id)
	match index:
		0:open_panel("contacts")
		1:open_panel("threat")
		2:show_drawer("intelligence")
		3:show_drawer("history")
		-1:
			for key in panels:close_panel(key,true)
func select_contact(id: int) -> void:
	if not command.registry.contacts.has(id):return
	selected=id
	_last_message=""
	selected_hypothesis=0
	response_mode=false
	command.focus_center(command.registry.contacts[id].center_id,id)
	role_select.select(0)
	center_control.select(command.tactical_centers.keys().find(command.registry.contacts[id].center_id))
	_view_signature=""
	refresh_views()
func toggle_panel(key: String) -> void:
	if opened[key]:close_panel(key,true)
	else:open_panel(key)
func open_panel(key: String) -> void:
	for other in panels:
		if other!=key and other!=pinned and opened[other]:opened[other]=false
	opened[key]=true
	active_panel=key
	layout_panels()
	_view_signature="";refresh_views()
func close_panel(key: String, explicit: bool=false) -> void:
	if not explicit and pinned==key:return
	if pinned==key:pinned=""
	opened[key]=false
	if active_panel==key:active_panel=""
	layout_panels()
func toggle_pin(key: String) -> void:
	pinned="" if pinned==key else key
	for other in panels:
		if other!=key and other!=active_panel and opened[other]:opened[other]=false
	layout_panels()
func target_rect(key: String) -> Rect2:
	if key=="contacts":return Rect2(16,112,640,724)
	if key=="threat":return Rect2(944,112,640,724)
	if opened.contacts:return Rect2(672,456,912,380)
	if opened.threat:return Rect2(16,456,912,380)
	return Rect2(16,456,1568,380)
func layout_panels() -> void:
	for key in panels:
		var panel: Panel=panels[key]
		var rect:=target_rect(key)
		panel.size=rect.size
		pin_buttons[key].position.x=rect.size.x-206
		close_buttons[key].position.x=rect.size.x-108
		pin_buttons[key].text="Unpin" if pinned==key else "Pin"
		if key=="drawer":
			drawer_scroll.size.x=rect.size.x-36
			drawer_filter.size.x=minf(370,rect.size.x-430)
		var off: Vector2=Vector2(-660,rect.position.y) if key=="contacts" else Vector2(1620,rect.position.y) if key=="threat" else Vector2(rect.position.x,920)
		if tweens.has(key) and tweens[key].is_valid():tweens[key].kill()
		if opened[key] and not panel.visible:panel.position=off;panel.show()
		var tween:=create_tween()
		tweens[key]=tween
		tween.tween_property(panel,"position",rect.position if opened[key] else off,0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if not opened[key]:tween.tween_callback(panel.hide)
func show_drawer(mode: String) -> void:
	drawer_mode=mode
	drawer_filter.clear()
	for title in (["All sources","SIGINT","Platform Profile","Trajectory Assessment","Follow-up Analysis"] if mode=="intelligence" else ["Selected contact","Entire network"]):drawer_filter.add_item(title)
	drawer_filter.select(analysis_filter.selected if mode=="intelligence" else history_filter.selected)
	open_panel("drawer")
func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode==KEY_ESCAPE:
		if confirmation.visible:confirmation.hide()
		elif not active_panel.is_empty() and active_panel!=pinned:close_panel(active_panel)
		get_viewport().set_input_as_handled()
func clean_legacy() -> void:
	command.overview.hide()
	command.back_button.hide();command.mode_control.hide();command.pause_control.hide()
	command.mission_ui.network_label.hide();command.mission_ui.local_panel.hide()
	command.mission_ui.level_control.hide();command.mission_ui.scorecard_button.hide()
	command.operations.ui.opener.hide();command.operations.ui.local_panel.hide()
	command.cyber.canvas.hide()
	for tactical in command.tactical_centers.values():
		tactical.get_node("HUD").hide()
		tactical.action_feedback.hide()
func _process(_delta: float) -> void:
	if not ready_ui:return
	clean_legacy()
	shell.visible=not command.scorecard_open and not command.operations.ui.modal.visible
	if not command.focused_center.is_empty():
		var id: int=command.tactical_centers[command.focused_center].selected_attack_id
		if id>=0 and id!=selected:select_contact(id)
	pause_button.disabled=not command.learning_mode
	pause_button.set_pressed_no_signal(command.strategic_paused)
	mode_select.select(0 if command.learning_mode else 1)
	feedback.text=brief(_last_message,55) if not _last_message.is_empty() else "C-%03d / %s / %s" % [selected,command.registry.contacts[selected].center_id,"PAUSED" if command.strategic_paused else "LIVE"]
	refresh_status()
	refresh_contacts()
	refresh_views()
func public_rows() -> Array:
	var rows: Array=command.strategic_table_rows()
	if center_filter.selected>0:rows=rows.filter(func(row):return row.center_id==center_filter.get_item_text(center_filter.selected))
	match concern_filter.selected:
		1:rows=rows.filter(func(row):return row.remaining!=null)
		2:rows=rows.filter(func(row):return row.operational_status=="ESCALATED")
		3:rows=rows.filter(func(row):return row.operational_status in ["WATCHLIST","INVESTIGATING"])
	return preload("res://script/contact_table_sort.gd").sorted_rows(rows,SORT_COLUMNS[table_sort],table_ascending)
func refresh_contacts() -> void:
	if not ready_ui:return
	var rows:=public_rows()
	var signature:=str(rows.map(func(row):return row.contact_id))
	_table_building=true
	if signature!=_table_signature:
		var same_population: bool=rows.size()==table_rows.size() and rows.all(func(row):return table_rows.has(row.contact_id))
		if same_population:
			var previous: TreeItem=null
			for row in rows:
				var current: TreeItem=table_rows[row.contact_id]
				if previous==null:
					var first:=contact_table.get_root().get_first_child()
					if first!=current:current.move_before(first)
				else:current.move_after(previous)
				previous=current
		else:
			contact_table.clear()
			table_rows.clear()
			var root:=contact_table.create_item()
			for row in rows:
				var child:=contact_table.create_item(root)
				child.set_metadata(0,row.contact_id)
				table_rows[row.contact_id]=child
				if row.contact_id==selected:child.select(0)
		_table_signature=signature
	var item:=contact_table.get_root().get_first_child() if contact_table.get_root()!=null else null
	for row in rows:
		var texts: Array=["C-%03d" % row.contact_id,row.center_id,command.registry.SEVERITY[row.severity],"Unknown" if row.confidence==null else str(row.confidence)+"%",command.registry.time_text(row.remaining),row.assessment,row.operational_status]
		for i in range(7):item.set_text(i,texts[i])
		item=item.get_next()
	for i in range(7):contact_table.set_column_title(i,["Contact","Center","Severity","Confidence","Deadline","Assessment","State"][i]+(" ^" if table_ascending else " v") if i==table_sort else ["Contact","Center","Severity","Confidence","Deadline","Assessment","State"][i])
	_table_building=false
	contact_summary.text="Selected C-%03d / %s\n%d displayed / 18 monitored | %s\nOpening a panel never changes evidence or decision time." % [selected,command.registry.contacts[selected].center_id,rows.size(),"Learning pause" if command.strategic_paused else "Simulation active"]
func refresh_status() -> void:
	var clocks:=[]
	var urgent:=0
	for row in command.registry.public_rows():
		if row.remaining!=null:
			clocks.append("%s C-%03d %s" % [row.center_id,row.contact_id,command.registry.time_text(row.remaining)])
			if row.remaining<=60:urgent+=1
		elif row.status=="Deadline expired":
			urgent+=1
			clocks.append("%s C-%03d EXPIRED" % [row.center_id,row.contact_id])
	status_strip.text="\n".join(clocks) if not clocks.is_empty() else "No active decision deadlines"
	status_strip.tooltip_text="Applicable network decision deadlines; background contacts have none.\n"+("Learning strategic pause holds active clocks." if command.strategic_paused else "Active clocks continue.")
	top_buttons.alerts.text="!"+str(urgent) if urgent>0 else "!"
	top_buttons.alerts.modulate=Color("ffcc77") if urgent>0 else Color.WHITE
	for key in top_buttons:
		var target: String="contacts" if key in ["contacts","overview"] else "drawer" if key in ["intelligence","history","alerts"] else key
		var is_active: bool=target==active_panel and (target!="drawer" or key==drawer_mode)
		top_buttons[key].set_pressed_no_signal(is_active)
		top_buttons[key].add_theme_color_override("font_color",Color("a8dcff") if is_active else Color("d4dee8"))
func refresh_views() -> void:
	if not ready_ui:return
	var tactical=command.registry.contacts[selected].tactical
	var signature: String="%d/%d/%d/%d/%s/%s/%d/%d" % [selected,tactical.intelligence.revision,command.operations.session.revision,command.cyber.journal.size(),drawer_mode,str(response_mode),selected_hypothesis,drawer_filter.selected]
	if signature==_view_signature:return
	_view_signature=signature
	var profile: Dictionary=model.view(selected)
	if profile.is_empty():threat_body.text="Public assessment unavailable: "+error;return
	var state: String=command.operations.session.view(selected).get("state",tactical.encounter.public_view(selected).status)
	threat_title.text="C-%03d / %s / %s" % [selected,profile.center_id,state]
	threat_title.tooltip_text=tactical.contact_context(selected).path_id
	var is_original: bool=selected==tactical.encounter.active_contact_id
	original_hold.visible=is_original
	original_replay.visible=is_original
	original_hold.disabled=tactical.encounter.resolved
	original_replay.disabled=not (tactical.encounter.resolved or tactical.encounter.investigated)
	var physical_state: String={"Suspected physical weapon":"Suspected weapon","No physical weapon currently suspected":"No weapon currently suspected","Unknown / insufficient evidence":"Unknown"}[profile.physical.state]
	var text: String="PHYSICAL / %s | %s\n%s\n\nCYBER / independent likelihoods, not confirmed payloads\n" % [physical_state,model.percent(profile.physical.confidence),brief(profile.physical.evidence,66)]
	for hypothesis in profile.cyber:
		var attack: Dictionary=model.attacks[int(hypothesis.attack_id)]
		text+="%s | %s | Severity if present: %s\n%s\n" % [attack.attack_name,model.percent(hypothesis.likelihood),attack.severity,brief(hypothesis.evidence,66)]
	text+="\nRECOMMENDATION / %s\n%s\nConfidence: %s" % [profile.recommendation.text,brief(profile.recommendation.rationale,78),model.percent(profile.recommendation.confidence)]
	threat_body.text=text
	threat_body.visible=not response_mode
	response_scroll.visible=response_mode;response_select.visible=response_mode
	if response_mode:
		response_select.clear()
		for hypothesis in profile.cyber:response_select.add_item(model.attacks[int(hypothesis.attack_id)].attack_name+" / likelihood "+model.percent(hypothesis.likelihood))
		response_select.select(selected_hypothesis)
		populate_defenses(int(profile.cyber[selected_hypothesis].attack_id))
	if drawer_mode=="intelligence":
		page=2;_signature="";super.render()
		var extended: String="PUBLIC MULTI-THREAT BRIEF / estimates, not verified capabilities\nPhysical: %s / %s\n%s\n" % [profile.physical.state,model.percent(profile.physical.confidence),profile.physical.evidence]
		for hypothesis in profile.cyber:
			var attack: Dictionary=model.attacks[int(hypothesis.attack_id)]
			extended+="\n%s / %s / severity if present: %s\n%s\nEvidence: %s\nAsset: %s\nEstimate source: %s\n" % [attack.attack_name,model.percent(hypothesis.likelihood),attack.severity,attack.definition,hypothesis.evidence,hypothesis.asset_at_risk,hypothesis.estimate_source]
		extended+="\nRecommendation: %s / %s\n%s\n\n" % [profile.recommendation.text,model.percent(profile.recommendation.confidence),profile.recommendation.rationale]
		var reports: Array=tactical.intelligence.history(selected)
		if analysis_filter.selected>0:reports=reports.filter(func(record):return record.source_type==analysis_filter.get_item_text(analysis_filter.selected))
		var receipt_summary: String="No timestamped source report matches this filter. Historical issue time is unavailable."
		if not reports.is_empty():receipt_summary="Latest receipt / "+reports.back().report_id+" / "+reports.back().source_type+"\n"+Presentation.times(reports.back())
		drawer_text.text="C-%03d / %s / %s\n%s\n\n%s\n\n%s" % [selected,profile.center_id,tactical.contact_context(selected).path_id.get_slice("/",1),receipt_summary,analysis.text,extended]
	elif drawer_mode=="history":
		page=3;_signature="";super.render()
		drawer_text.text=history_text.text
	else:
		var alerts:=[]
		for row in command.registry.public_rows():
			if row.remaining!=null or row.status=="Deadline expired":alerts.append("%s / C-%03d / %s / %s" % [row.center_id,row.contact_id,command.registry.time_text(row.remaining),row.status])
		drawer_text.text="APPLICABLE DEADLINES / public status only\n\n"+"\n".join(alerts)
	feedback.text=brief(_last_message,55) if not _last_message.is_empty() else "C-%03d / %s / %s" % [selected,command.registry.contacts[selected].center_id,"PAUSED" if command.strategic_paused else "LIVE"]
	feedback.tooltip_text=_last_message
func open_responses() -> void:
	var tactical=command.registry.contacts[selected].tactical
	if selected==tactical.encounter.active_contact_id:decision(1);return
	response_mode=true;_view_signature="";refresh_views()
func monitor_review() -> void:
	pending={"type":"monitor_review"}
	confirmation.dialog_text="C-%03d / Continue monitoring.\nOpening or closing panels does not issue a defensive command. Existing Hold fire, de-escalation and release options are available through Operational commands; the original encounter retains its tactical Hold fire control. No outcome is resolved by this review." % selected
	confirmation.get_ok_button().disabled=true
	confirmation.popup_centered()
func open_operations() -> void:
	if command.operations.session.has_contact(selected):command.operations.ui.open_console(selected)
	else:
		confirmation.dialog_text="C-%03d / No separate operational escalation is assigned. Use the existing Investigate, Cyber Defense and Hold fire controls if this is an original active encounter." % selected
		confirmation.get_ok_button().disabled=true
		confirmation.popup_centered()
func review_hold() -> void:
	pending={"type":"original_hold"}
	confirmation.dialog_text="C-%03d / Deliberate HOLD FIRE.\nThis resolves the original encounter using its existing authored no-intervention branch. The authoritative deadline is checked at confirmation. It is distinct from accidental expiration; no outcome or identity is guaranteed." % selected
	confirmation.get_ok_button().disabled=command.registry.contacts[selected].tactical.encounter.resolved
	confirmation.popup_centered()
func review_replay() -> void:
	pending={"type":"original_replay"}
	confirmation.dialog_text="C-%03d / Reset this original encounter for practice.\nThis explicitly restores its accepted movement and deadline state. Other contacts are not reset. The first official score remains unchanged; practice cannot farm points." % selected
	confirmation.get_ok_button().disabled=false
	confirmation.popup_centered()
static func brief(text: String, maximum: int) -> String:
	return text if text.length()<=maximum else text.left(maximum-3)+"..."
func confirm_action() -> void:
	if pending.type in ["original_hold","original_replay"]:
		var tactical=command.registry.contacts[selected].tactical
		if pending.type=="original_hold":tactical._on_command_requested("hold_fire")
		else:tactical._on_replay_requested()
		_last_message="C-%03d / %s" % [selected,tactical.encounter.public_view(selected).status]
	else:
		super.confirm_action()
		_last_message=notice.text
	feedback.text=_last_message
	_view_signature="";refresh_views()
