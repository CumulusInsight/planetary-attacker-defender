extends Control
## Graphical workspace adapter. Existing session handlers remain authoritative.
const ORBIT_TRANSFORM=Transform2D(0,Vector2(0.85,0.85),0,Vector2(138,74))
var game: Node
var menu: MenuButton
var menus: Dictionary={}
var authority: Label
var group_caption: Label
var tile_links: Dictionary={}
var inspector_button: Button
var requested_layout: Array=[]
var last_size:=Vector2.ZERO
var left_buttons: Dictionary={}
var context_panel: Panel
var context_text: RichTextLabel
var context_title: Label
var encounter_picker: OptionButton
var context_mode:="overview"
var context_hidden:=false
var context_signature:=""
var status: Label
var metrics_status: Label
var bottom: Panel
var legacy_button: Button
var group_button: Button
var backdrop: CanvasLayer
var globe: ColorRect
var personnel_panel: Panel
var personnel_close: Button
var learning_history: Button
func place(node: Control,bounds: Rect2,parent: Node=null) -> void:
	if parent==null:parent=self
	parent.add_child(node);node.position=bounds.position;node.size=bounds.size
func label_at(value: String,bounds: Rect2,font_size: int=18,parent: Node=null) -> Label:
	var l:=Label.new();l.text=value;l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;l.add_theme_font_size_override("font_size",font_size);l.mouse_filter=Control.MOUSE_FILTER_IGNORE;place(l,bounds,parent);return l
func button_at(value: String,bounds: Rect2,callback: Callable,parent: Node=null) -> Button:
	var b:=Button.new();b.text=value;place(b,bounds,parent);b.pressed.connect(callback);return b
func panel_at(bounds: Rect2) -> Panel:
	var p:=Panel.new();place(p,bounds);return p
func configure(owner_game: Node) -> void:
	game=owner_game;process_priority=150;name="TacticalGroupPresentation";mouse_filter=Control.MOUSE_FILTER_IGNORE;z_index=-1
	theme=Theme.new();theme.default_font=ThemeDB.fallback_font;theme.default_font_size=18
	for state in ["normal","hover","pressed","hover_pressed","focus","disabled"]:
		var s:=StyleBoxFlat.new();s.bg_color=Color("103244") if state in ["hover","pressed","hover_pressed"] else Color("081c2b");s.border_color=Color("63d1ed") if state in ["focus","pressed","hover_pressed"] else Color("315668");s.set_border_width_all(1);s.set_corner_radius_all(6);s.set_content_margin_all(8);theme.set_stylebox(state,"Button",s)
		if state=="normal":theme.set_stylebox("panel","Panel",s)
	for state in ["font_color","font_hover_color","font_pressed_color"]:theme.set_color(state,"Button",Color("d2eaf4"))
	build_backdrop()
	var ui=game.command.decision_pages
	ui.layer=90;game.command.operations.ui.layer=100;game.command.mission_ui.layer=100
	game.navigation.hide();ui.top_buttons.overview.get_parent().hide();ui.feedback.get_parent().hide()
	panel_at(Rect2(12,8,1576,60));panel_at(Rect2(12,76,1576,48))
	var names=["COMMAND","OPERATIONS","PERSONNEL","TRAINING","REPORTS"]
	for i in range(names.size()):
		var m:=MenuButton.new();m.text=names[i];m.switch_on_hover=true;place(m,Rect2(22+i*182,14,174,46));menus[names[i]]=m
	menu=menus.COMMAND
	menu.get_popup().add_item("TACTICAL GROUP COMMAND / six orbital data centers",100);menu.get_popup().set_item_disabled(0,true)
	menu.get_popup().add_item("Tactical Group Overview",0)
	for i in range(6):menu.get_popup().add_item("    DC-%02d / subordinate center" % [i+1],i+1)
	menu.get_popup().add_separator();menu.get_popup().add_item("Command Desk",7);menu.get_popup().add_item("New Mission - confirmation required",8)
	menu.get_popup().id_pressed.connect(command_destination)
	add_menu("OPERATIONS",["Analyze group threats","Review group Report / partial submissions","Decide / authorize / WAIT","Inspect selected center incidents","Legacy tactical tools - selected center","Operations Commander / legacy Contacts","Martian War Room"],operations_destination)
	add_menu("PERSONNEL",["First Watch crew / training assignments","Enterprise roster - future capability"],personnel_destination)
	menus.PERSONNEL.get_popup().set_item_disabled(1,true)
	add_menu("TRAINING",["The First Watch - separate training / safety gate"],func(_id):game.request_host("training"))
	add_menu("REPORTS",["Group learning Report / current and historical rounds","Original operational Evidence","Original Decision Timeline","Official Mission Scorecard (not learning score)","Internal arrival records - selected center","First Watch report - separate TRAINING / safety gate"],reports_destination)
	game.war_room_button.reparent(self);game.war_room_button.position=Vector2(1110,16);game.war_room_button.size=Vector2(250,42);game.war_room_button.text="MARTIAN WAR ROOM"
	ui.pause_button.reparent(self);ui.pause_button.position=Vector2(1370,16);ui.pause_button.size=Vector2(200,42)
	status=label_at("",Rect2(30,81,1530,22),16)
	metrics_status=label_at("",Rect2(30,103,1530,20),15)
	authority=label_at("TACTICAL GROUP COMMAND",Rect2(154,137,510,32),27);authority.modulate=Color("93e3f2")
	group_caption=label_at("DC-01  /  DC-02  /  DC-03  /  DC-04  /  DC-05  /  DC-06",Rect2(154,173,740,25),16)
	ui.mode_select.reparent(self);ui.mode_select.position=Vector2(906,138);ui.mode_select.size=Vector2(270,32)
	game.fire_mode_control.reparent(self);game.fire_mode_control.position=Vector2(154,792);game.fire_mode_control.size=Vector2(210,32)
	game.reset_view_button.reparent(self);game.reset_view_button.position=Vector2(824,792);game.reset_view_button.size=Vector2(352,32)
	game.target_picker.position=Vector2(374,792);game.target_picker.size=Vector2(440,32);game.target_picker.add_theme_font_size_override("font_size",14)
	game.fire_status.hide();game.score_label.hide()
	panel_at(Rect2(16,206,114,518))
	for i in range(4):
		var key: String=["overview","assessment","evidence","history"][i]
		var b=preload("res://script/command_nav_icon.gd").new();b.kind=key;b.text="\n\n"+["Overview","Assessment","Evidence","History"][i];b.add_theme_font_size_override("font_size",15);b.toggle_mode=true
		place(b,Rect2(22,214+i*123,102,112));left_buttons[key]=b;b.pressed.connect(func():select_page(key))
	context_panel=panel_at(Rect2(1232,184,352,648))
	context_title=label_at("SELECTED CENTER",Rect2(16,18,280,38),23,context_panel)
	button_at("Hide",Rect2(274,16,64,30),func():context_hidden=true;context_panel.hide(),context_panel)
	button_at("Inspector",Rect2(1454,138,130,32),func():context_hidden=not context_hidden;refresh_context())
	encounter_picker=OptionButton.new();encounter_picker.fit_to_longest_item=false;encounter_picker.clip_text=true;place(encounter_picker,Rect2(16,72,232,38),context_panel)
	button_at("Lesson",Rect2(256,72,80,38),open_lesson,context_panel)
	encounter_picker.item_selected.connect(func(index):game.focus_contact(int(encounter_picker.get_item_metadata(index)),false);context_signature="";refresh_context())
	context_text=RichTextLabel.new();context_text.bbcode_enabled=false;context_text.add_theme_font_size_override("normal_font_size",18);place(context_text,Rect2(16,124,320,360),context_panel)
	button_at("Review defense decision",Rect2(16,500,320,44),func():open_learning("report"),context_panel)
	button_at("Full incident inspector",Rect2(16,552,320,38),func():game.open_tactical(game.navigation_context.selected_center),context_panel)
	button_at("Attack lesson / explanation",Rect2(16,598,320,36),open_lesson,context_panel)
	bottom=panel_at(Rect2(154,838,1430,54))
	var captions=["ANALYZE","REVIEW REPORT","DECIDE / AUTHORIZE"]
	for i in range(3):
		var b: Button=game.nav[["analyze","report","decide"][i]];b.reparent(bottom);b.text=captions[i];b.position=Vector2(8+i*218,7);b.size=Vector2(210,40);b.add_theme_font_override("font",ThemeDB.fallback_font);b.add_theme_font_size_override("font_size",18)
	inspector_button=button_at("INSPECT INCIDENT",Rect2(664,7,218,40),func():game.open_tactical(game.navigation_context.selected_center),bottom)
	legacy_button=button_at("LEGACY TACTICAL TOOLS",Rect2(890,7,286,40),game.open_legacy_tactical,bottom)
	group_button=button_at("GROUP VIEW",Rect2(1184,7,236,40),game.open_orbital_view,bottom)
	var index:=0
	for b in ui.quick.values():b.reparent(bottom);b.position=Vector2(8+index*234,7);b.size=Vector2(226,40);index+=1
	for center in game.navigation_context.CENTERS:
		var b:=Button.new();b.add_theme_font_size_override("font_size",16);b.clip_text=true
		for state in ["normal","hover","pressed","hover_pressed","focus"]:
			var style:=StyleBoxFlat.new();style.bg_color=Color("103244") if state in ["hover","pressed","hover_pressed"] else Color("081c2b");style.border_color=Color("315668");style.set_border_width_all(1);style.set_content_margin_all(6);style.content_margin_top=1;style.content_margin_bottom=1;b.add_theme_stylebox_override(state,style)
		add_child(b);tile_links[center]=b;b.pressed.connect(func():game.select_group_center(center);context_mode="assessment";refresh_context())
	game.navigation_notice.position=Vector2(154,132);game.navigation_notice.size=Vector2(730,66);game.navigation_notice.add_theme_font_size_override("font_size",16)
	label_at("GROUP SUBMISSION RESULTS",Rect2(12,5,328,21),15,game.toast)
	var receipt_scroll:=ScrollContainer.new();receipt_scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;place(receipt_scroll,Rect2(12,30,328,94),game.toast)
	game.toast_label.reparent(receipt_scroll);game.toast_label.position=Vector2.ZERO;game.toast_label.custom_minimum_size=Vector2.ZERO;game.toast_label.size_flags_horizontal=Control.SIZE_EXPAND_FILL
	build_personnel();apply_fit()
func add_menu(key: String,titles: Array,callback: Callable) -> void:
	for t in titles:menus[key].get_popup().add_item(t)
	menus[key].get_popup().id_pressed.connect(callback)
func build_backdrop() -> void:
	backdrop=CanvasLayer.new();backdrop.layer=45;game.add_child(backdrop)
	var bg:=TextureRect.new();bg.texture=preload("res://images/space.jpg");bg.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;bg.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_COVERED;bg.size=Vector2(1600,900);bg.mouse_filter=Control.MOUSE_FILTER_IGNORE;backdrop.add_child(bg)
	var shade:=ColorRect.new();shade.color=Color(0.005,0.02,0.04,0.78);shade.size=Vector2(1600,900);shade.mouse_filter=Control.MOUSE_FILTER_IGNORE;backdrop.add_child(shade)
	globe=ColorRect.new();globe.size=Vector2(1600,900);globe.mouse_filter=Control.MOUSE_FILTER_IGNORE;var mat:=ShaderMaterial.new();mat.shader=preload("res://script/command_workspace_globe.gdshader");globe.material=mat;backdrop.add_child(globe)
func build_personnel() -> void:
	personnel_panel=Panel.new();game.place(game.shell,personnel_panel,Rect2(380,220,840,490));personnel_panel.z_index=120;personnel_panel.theme=theme
	label_at("FIRST WATCH CREW / TRAINING ASSIGNMENTS",Rect2(24,24,780,40),25,personnel_panel)
	var crew: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/p14/first_watch.json"))
	var names: Array=[]
	for person in crew.crew:names.append(person.rank+" "+person.name+" ? "+person.role)
	label_at("\n\n".join(names)+"\n\nExisting First Watch training crew.\nEnterprise staff roster: not implemented.",Rect2(24,88,780,300),23,personnel_panel)
	personnel_close=button_at("RETURN TO COMMAND",Rect2(24,414,790,46),func():personnel_panel.hide(),personnel_panel);personnel_panel.hide()
func command_destination(id: int) -> void:
	if id==0:game.open_orbital_view()
	elif id>=1 and id<=6:game.select_group_center("DC-%02d" % id)
	elif id==7:game.request_host("desk")
	elif id==8:
		var host=game.get_parent()
		if host.has_method("request_new_mission"):host.request_new_mission()
		else:game.navigation_message("New Mission is available through the permanent launcher and Command Desk.")
func operations_destination(id: int) -> void:
	match id:
		0:open_learning("analyze")
		1:open_learning("report")
		2:open_learning("decide")
		3:game.open_tactical(game.navigation_context.selected_center)
		4:game.open_legacy_tactical()
		5:game.open_fleet_view()
		6:game.war_room.open_room()
func personnel_destination(_id: int) -> void:personnel_panel.show();personnel_close.grab_focus()
func reports_destination(id: int) -> void:
	match id:
		0:open_learning("report")
		1:open_legacy_view("intelligence")
		2:open_legacy_view("history")
		3:game.command.show_scorecard(true)
		4:game.open_tactical(game.navigation_context.selected_center)
		5:
			game.request_host("training")
			var host=game.get_parent()
			if "watch" in host and is_instance_valid(host.watch) and host.watch.visible:host.watch.open_panel("debrief")
func open_legacy_view(kind: String) -> void:
	var center: String=game.navigation_context.selected_center
	if not game.command.tactical_centers.has(center):game.navigation_message(center+": original operational evidence/history is not implemented. The right panel contains this center's learning records.");return
	game.open_legacy_tactical();game.command.decision_pages.show_drawer(kind)
func select_page(key: String) -> void:
	context_hidden=false;context_mode=key
	if key=="overview":game.open_orbital_view()
	else:game.close_legacy_panels();game.learning_context=true
	refresh_context()
func open_learning(key: String) -> void:
	personnel_panel.hide();game.security_console.hide();game.close_legacy_panels();game.learning_context=true;game.show_page(key)
func open_lesson() -> void:
	var q: Dictionary=current_question()
	if game.session.analyzed and not q.is_empty():game.open_lesson(q)
	else:game.navigation_message("Analyze the group first. No answer or analysis is performed by opening an explanation.")
func current_question() -> Dictionary:
	if not game.session.analyzed:return {}
	var center: String=game.navigation_context.selected_center
	var choices: Array=game.loader.questions.filter(func(q):return q.center_id==center)
	for q in choices:
		if int(q.contact_id)==game.learning_selected:return q
	return {} if choices.is_empty() else choices[0]
func refresh_context() -> void:
	context_panel.visible=game.learning_context and not context_hidden and not game.martian.visible
	var center: String=game.navigation_context.selected_center;context_title.text=center+" / "+context_mode.capitalize()
	var choices: Array=game.loader.questions.filter(func(q):return q.center_id==center) if game.session.analyzed else []
	var ids: Array=choices.map(func(q):return int(q.contact_id));var old: Array=[]
	for i in range(encounter_picker.item_count):old.append(int(encounter_picker.get_item_metadata(i)))
	if old!=ids:
		encounter_picker.clear()
		for q in choices:
			encounter_picker.add_item("C-%03d / %s" % [q.contact_id,game.loader.rich_attacks[int(q.attack_id)].display_name]);encounter_picker.set_item_metadata(encounter_picker.item_count-1,int(q.contact_id))
	encounter_picker.disabled=ids.is_empty()
	var q: Dictionary=current_question();var rows: Array=game.incident_rows(center)
	if context_mode=="history":
		var lines: Array=[center+" / learning engagement records"]
		for r in game.session.all_results.values():
			if r.center_id==center:lines.append(str(r.get("learning_id",""))+"\n"+result_attack_name(r)+"\nAnswer: "+("CORRECT" if r.answer_correct else "INCORRECT")+" / "+str(r.get("projectile_outcome","NO LAUNCH")))
		context_text.text="\n\n".join(lines)+"\n\nFull round history remains in REVIEW REPORT. Official command history is separate under REPORTS.";return
	if context_mode=="evidence":
		var lines: Array=[center+" / recorded arrival evidence","No SIEM telemetry or confirmed compromise is inferred."]
		for r in rows:lines.append(r.display_name+"\n"+r.physical_id+"\n"+r.cause_text+" / "+r.source_outcome)
		context_text.text="\n\n".join(lines)+"\n\nOriginal operational intelligence remains separately available through REPORTS for DC-01?DC-03.";return
	if q.is_empty():context_text.text="Subordinate asset of Tactical Group Command.\n\n%d internal arrival(s).\n\n%s\n\nArrival does not confirm compromise." % [rows.size(),"Use ANALYZE to prepare current encounters across all six centers." if not game.session.analyzed else "No learning encounter assigned here this round. Other rounds may use this center."];return
	var id:=int(q.contact_id);encounter_picker.select(ids.find(id));var attack: Dictionary=game.loader.rich_attacks[int(q.attack_id)]
	var selection: Variant=game.session.answers.get(id);var result: Dictionary=game.session.results.get(id,{})
	context_text.text="SUSPECTED ATTACK\n"+attack.display_name+"\n\nC-%03d / %s\nTime: %s\n\n%s\n\nDecision: %s\n%s" % [id,center,game.deadline_text(id),str(attack.get("question",attack.get("definition",""))),"Not selected" if selection==null else game.loader.rich_defenses[int(selection)].display_name,game.session.live_status(id)]
	if not result.is_empty():context_text.text+="\n\nAnswer: "+("CORRECT" if result.answer_correct else "INCORRECT")+"\nPhysical outcome: "+str(result.get("projectile_outcome","NO LAUNCH"))
func request_layout(centers: Array) -> void:
	requested_layout=centers.duplicate()
	if game.animations_active():game.navigation_message("Center selected. Orbital layout changes after active flights and effects finish; target geometry is preserved.")
	apply_layout_if_safe()
func apply_layout_if_safe() -> void:
	if requested_layout.is_empty() or game.animations_active():return
	game.orbital_display.layout_centers(requested_layout);game.view_mode="single" if requested_layout.size()==1 else "multi";requested_layout.clear();game.queued_reset_center="";game.update_learning_presentation();game.navigation_message("")
func apply_fit() -> void:
	last_size=get_viewport_rect().size;var f: float=minf(last_size.x/1600,last_size.y/900);var offset: Vector2=(last_size-Vector2(1600,900)*f)/2
	var fit:=Transform2D(0,Vector2(f,f),0,offset)
	for layer in game.find_children("*","CanvasLayer",true,false):layer.transform=fit
	game.orbital_canvas.transform=fit*ORBIT_TRANSFORM
func orbital_coordinates(point: Vector2) -> Vector2:return game.orbital_canvas.transform.affine_inverse()*point
func _process(_delta: float) -> void:
	apply_layout_if_safe()
	if last_size!=get_viewport_rect().size:apply_fit()
	game.navigation.hide();game.command.decision_pages.center_control.hide();game.learning_center_select.hide();game.overview_button.hide();game.command.decision_pages.status_strip.hide()
	game.command.decision_pages.feedback.get_parent().hide()
	game.score_label.hide();game.fire_status.hide();game.learning_deadline_table.hide()
	var learning: bool=game.learning_context
	backdrop.visible=learning
	globe.material.set_shader_parameter("drift",game.session.now/1800.0)
	for key in game.nav:game.nav[key].visible=learning
	inspector_button.visible=learning;legacy_button.visible=learning
	legacy_button.disabled=not game.command.tactical_centers.has(game.navigation_context.selected_center)
	legacy_button.tooltip_text="Original tactical actors, response and confirmation paths." if not legacy_button.disabled else "Legacy actors are not implemented for this center. Analyze / Report / Decide remain available."
	for b in game.command.decision_pages.quick.values():b.visible=not learning
	var arrivals:=0
	for c in game.navigation_context.CENTERS:arrivals+=game.session.internal_for_center(c).size()
	var metrics: Dictionary=game.session.metrics()
	status.text="6 ORBITAL DATA CENTERS    |    ROUND %d / %d    |    %d ARRIVALS    |    %d AIRBORNE    |    SIM %.1fs  %s" % [game.session.round_index+1,game.loader.rounds.size(),arrivals,game.session.flights.size(),game.session.now,"PAUSED" if game.command.strategic_paused else "RUNNING"]
	metrics_status.text="LEARNING RESULTS   |   %d correct / %d incorrect   |   %.0f%% accuracy   |   Elapsed Time: %s" % [metrics.correct,metrics.incorrect,metrics.percentage,preload("res://script/command_status.gd").format_time(floor(metrics.elapsed))]
	for key in left_buttons:left_buttons[key].set_pressed_no_signal(key==context_mode)
	var show_links: bool=learning and not game.mode_modal_open()
	for center in tile_links:
		var b: Button=tile_links[center];b.visible=show_links and game.orbital_display.tiles.has(center)
		if not b.visible:continue
		var tile: Rect2=game.orbital_display.tiles[center];b.position=ORBIT_TRANSFORM*tile.position;b.size=Vector2(tile.size.x*0.85,24)
		var pending:=0
		for q in game.loader.questions:
			if q.center_id==center and not game.session.results.has(int(q.contact_id)):pending+=1
		b.text="%s  |  %d arrivals  |  %s" % [center,game.session.internal_for_center(center).size(),str(pending)+" pending" if game.session.analyzed else "Analyze"]
		b.tooltip_text="Subordinate center of your Tactical Command Group. Select for its activity and decision context."
	if game.martian.incoming().is_empty() and not game.session.pending.is_empty():game.martian.hide() # A new pending decision supersedes an old resolved receipt.
	status.text+="    |    "+game.session.firing_mode
	if not game.requested_fire_mode.is_empty():status.text+=" ? "+game.requested_fire_mode+" (after window closes)"
	# One right-side destination at a time: warning panel, or context with its result receipt.
	if game.martian.visible:game.toast.hide()
	for child in context_panel.get_children():
		if child is Button and child.position.y>=500:child.visible=not game.toast.visible
	context_text.size.y=322 if game.toast.visible else 360
	refresh_context()
	var notice_visible: bool=not game.navigation_notice.text.is_empty() and not game.mode_modal_open()
	game.navigation_notice.visible=notice_visible;authority.visible=not notice_visible;group_caption.visible=not notice_visible
	# CanvasItem z does not order GUI input. Genuine dialogs must also be last siblings.
	var modals: Array=game.windows.values()+[game.security_console,game.completion_prompt,game.war_room,game.detail_panel,personnel_panel]
	if is_instance_valid(game.review_panel):modals.append(game.review_panel)
	for modal in modals:
		if is_instance_valid(modal) and modal.visible:modal.move_to_front()

func _input(event: InputEvent) -> void:
	if game.externally_covered:return
	if personnel_panel.visible and event.is_action_pressed("ui_cancel"):
		personnel_panel.hide();get_viewport().set_input_as_handled()

func result_attack_name(result: Dictionary) -> String:
	for round_questions in game.loader.rounds:
		for question in round_questions:
			if question.learning_id==result.get("learning_id",""):return game.loader.rich_attacks[int(question.attack_id)].display_name
	return str(result.get("attack_name","Attack name unavailable"))
