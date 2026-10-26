extends Node
## Optional P11 wrapper: P10 scene/controller/evaluators remain unchanged.
const Loader=preload("res://script/learning_question_loader.gd")
const Session=preload("res://script/learning_session.gd")
const Projectile=preload("res://script/learning_projectile.gd")
var command: Node
var loader=Loader.new()
var session=Session.new()
var error:=""
var canvas: CanvasLayer
var shell: Control
var nav:={}
var windows:={}
var closes:={}
var page:=""
var analysis_message: Label
var yes_button: Button
var no_button: Button
var report_grid: GridContainer
var option_buttons:={}
var report_status: Label
var restart_button: Button
var target_label: Label
var decide_message: Label
var result_message: Label
var fire_buttons:={}
var open_report: Button
var cancel_button: Button
var why_button: Button
var why_label: Label
var toast: Panel
var toast_label: Label
var toast_cancel: Button
var projectiles: Array=[]
var learning_context:=false
var saved_visuals:={}
var latest_result:={}
var old_layout:={}
var time_labels:={}
var hover_explanation: Label
var hovered_choice: Button
var score_label: Label
var previews:={}
var fire_question: Label
@export var session_seed: int=-1
@export_range(1,3) var participating_center_limit:=3
@export var legacy_test_fixture:=false
var orbital_canvas: CanvasLayer
var orbital_display: Node2D
var learning_deadline_table: Tree
var learning_deadline_items:={}
var learning_sort:=2
var learning_ascending:=true
var world_hidden:=false
var old_deadline_visible:=true
var result_cells:={}
var round_control: OptionButton
var review_index:=-1
var round_control_signature:=""
var reset_view_button: Button
var view_mode:="multi"
var explicit_center:=""
var queued_reset_center:=""
var report_sort:=-1
var report_ascending:=true
var report_order: Array=[]
var report_headers: Array=[]
func _ready() -> void:
	process_priority=80
	command=$CommandCenter
	error=loader.load_questions(command.decision_pages.model)
	if error.is_empty() and not legacy_test_fixture:
		for arg in OS.get_cmdline_user_args():
			if arg.begins_with("--odc-learning-seed=") and arg.get_slice("=",1).is_valid_int():session_seed=int(arg.get_slice("=",1))
			if arg.begins_with("--odc-learning-centers=") and arg.get_slice("=",1).is_valid_int():participating_center_limit=int(arg.get_slice("=",1))
		if session_seed<0:session_seed=Crypto.new().generate_random_bytes(4).decode_u32(0)
		error=loader.prepare_session(command.decision_pages.model,session_seed,participating_center_limit)
	if not error.is_empty():push_error(error)
	if error.is_empty():
		var record:=FileAccess.open("user://prototype11_learning_session.json",FileAccess.WRITE)
		if record!=null:record.store_string(JSON.stringify({"engine":Engine.get_version_info().string,"seed":session_seed,"center_limit":participating_center_limit,"bank_sha256":FileAccess.get_sha256("res://data/learning_question_bank.json"),"catalog_sha256":FileAccess.get_sha256("res://data/cyber_catalog.json"),"legacy_test_fixture":legacy_test_fixture,"rounds":loader.rounds.map(func(round):return round.map(func(q):return {"learning_id":q.learning_id,"question_id":q.question_id,"contact_id":q.contact_id,"center_id":q.center_id,"options":q.options})),"questions":loader.questions.map(func(q):return {"question_id":q.question_id,"contact_id":q.contact_id,"center_id":q.center_id,"options":q.options})},"  "))
		print("P11 learning seed: ",session_seed," | questions: ",loader.questions.size())
	session.configure(loader)
	build()
	refresh()
func label(parent: Node,rect: Rect2,size: int=18) -> Label:return command.decision_pages.make_label(parent,rect,size)
func button(parent: Node,text: String,rect: Rect2,action: Callable) -> Button:return command.decision_pages.make_button(parent,text,rect,action)
func place(parent: Node,node: Control,rect: Rect2) -> void:command.cyber.place(parent,node,rect)
func build() -> void:
	var ui=command.decision_pages
	var bar: Node=ui.top_buttons.overview.get_parent()
	for control in [ui.center_control,ui.mode_select,ui.pause_button,ui.role_select]:old_layout[control]={"position":control.position,"size":control.size}
	# Separate P11 Analyze, Report and Decide; keep all P10 controls in place.
	ui.center_control.position.x=582;ui.center_control.size.x=140
	ui.mode_select.position.x=734;ui.mode_select.size.x=208
	ui.pause_button.position.x=954;ui.pause_button.size.x=220
	ui.role_select.position.x=1186;ui.role_select.size.x=260
	var specs: Array=[["analyze","A","Analyze"],["report","R","Report"],["decide","D","Decide / learning shot"]]
	for i in range(specs.size()):
		var key: String=specs[i][0]
		nav[key]=button(bar,specs[i][1],Rect2(412+i*54,4,48,34),func():show_page(key))
		nav[key].tooltip_text=specs[i][2];nav[key].toggle_mode=true
	ui.center_control.item_selected.connect(on_learning_center_selected)
	for control in ui.top_buttons.values():control.pressed.connect(leave_learning)
	for control in ui.quick.values():control.pressed.connect(leave_learning)
	canvas=CanvasLayer.new();canvas.layer=85;add_child(canvas)
	shell=Control.new();shell.size=Vector2(1600,900);shell.mouse_filter=Control.MOUSE_FILTER_IGNORE;shell.theme=ui.shell.theme;canvas.add_child(shell)
	build_learning_presentation()
	for spec in [["analyze","ANALYZE",Rect2(24,190,570,260)],["report","REPORT / CHOOSE ONE CONTROL PER CONTACT",Rect2(20,170,1560,462)],["decide","DECIDE / LEARNING TARGET",Rect2(24,190,620,490)]]:
		var key: String=spec[0];var panel:=Panel.new();place(shell,panel,spec[2]);windows[key]=panel
		label(panel,Rect2(18,12,spec[2].size.x-140,30),20).text=spec[1]
		closes[key]=button(panel,"Close",Rect2(spec[2].size.x-108,10,90,32),func():close_page())
		var line:=HSeparator.new();place(panel,line,Rect2(18,50,spec[2].size.x-36,4));panel.hide()
	var a=windows.analyze
	label(a,Rect2(18,72,534,60),22).text="Analyze the existing threats on all data centers?"
	yes_button=button(a,"YES",Rect2(18,148,250,42),analyze)
	no_button=button(a,"NO",Rect2(284,148,268,42),close_page)
	analysis_message=label(a,Rect2(18,202,534,44),17)
	var r=windows.report
	round_control=OptionButton.new();place(r,round_control,Rect2(1060,10,360,32));round_control.item_selected.connect(select_report_round)
	report_grid=GridContainer.new();report_grid.columns=9;report_grid.add_theme_constant_override("h_separation",8);report_grid.add_theme_constant_override("v_separation",8)
	place(r,report_grid,Rect2(18,72,1524,320))
	report_status=label(r,Rect2(18,388,1160,56),17)
	hover_explanation=label(r,Rect2(18,388,1160,64),17);hover_explanation.hide()
	score_label=label(shell,Rect2(20,54,560,56),16);score_label.hide()
	restart_button=button(r,"Restart learning session",Rect2(1190,402,352,40),restart_learning)
	var d=windows.decide
	target_label=label(d,Rect2(18,66,584,54),21)
	fire_question=label(d,Rect2(18,122,584,36),23);fire_question.text="Fire on target?"
	for i in range(4):
		var delay: int=[0,60,300,600][i]
		fire_buttons[delay]=button(d,["FIRE NOW","WAIT 1 MINUTE","WAIT 5 MINUTES","WAIT 10 MINUTES"][i],Rect2(18+(i%2)*298,170+(i/2 as int)*48,286,40),func():request_fire(delay))
	decide_message=label(d,Rect2(18,270,584,50),18)
	open_report=button(d,"Open Report",Rect2(18,330,286,36),func():show_page("report" if session.analyzed else "analyze"))
	cancel_button=button(d,"Cancel pending shot",Rect2(316,330,286,36),cancel_shot)
	result_message=label(d,Rect2(18,375,584,62),18)
	why_button=button(d,"Why?",Rect2(18,443,86,30),func():why_label.visible=not why_label.visible)
	why_label=label(d,Rect2(114,441,488,44),15);why_label.hide()
	toast=Panel.new();place(shell,toast,Rect2(1232,650,352,182))
	toast_label=label(toast,Rect2(12,12,328,108),17)
	toast_cancel=button(toast,"Cancel pending shot",Rect2(12,136,328,34),cancel_shot);toast.hide()
func show_page(key: String) -> void:
	page=key;learning_context=true;clear_explanation()
	if key=="report" and session.analyzed:build_report()
	for name in windows:windows[name].visible=name==key
	why_label.hide();refresh()
func close_page() -> void:
	page="";clear_explanation()
	for panel in windows.values():panel.hide()
	refresh()
func leave_learning() -> void:
	close_page();learning_context=false;apply_learning_visuals();update_learning_presentation();toast.hide()
	command.decision_pages.center_control.select(command.tactical_centers.keys().find(command.focused_center))
func analyze() -> void:
	if not error.is_empty():analysis_message.text="Learning data unavailable: "+error;return
	session.advance(command.operations.session.now)
	if session.round_complete() and session.has_next_round():
		if animations_active():analysis_message.text="Finishing impact animations...";return
		var times:={}
		for q in loader.questions:times[int(q.contact_id)]=deadline_text(int(q.contact_id))
		restore_learning_visuals()
		if not session.advance_round(command.registry.public_rows(),times):return
		latest_result.clear();orbital_display.configure(self);view_mode="multi";queued_reset_center=""
	if session.analyze(command.registry.public_rows()):
		review_index=-1;analysis_message.text="Analysis complete";build_report();show_page("report")
	else:analysis_message.text="Contact association unavailable. See Godot output."
	refresh()
func build_report() -> void:
	for child in report_grid.get_children():report_grid.remove_child(child);child.queue_free()
	option_buttons.clear();time_labels.clear();result_cells.clear();report_headers.clear();clear_explanation()
	var widths: Array=[108,88,158,82,224,224,224,224,120]
	for i in range(9):
		var title:=Button.new();title.flat=true;title.clip_text=true;title.text=["DATA CENTER","CONTACT","SUSPECTED ATTACK","TIME","OPTION 1","OPTION 2","OPTION 3","OPTION 4","RESULT"][i]+((" ^" if report_ascending else " v") if report_sort==i else "");title.custom_minimum_size=Vector2(widths[i],26);title.add_theme_font_override("font",ThemeDB.fallback_font);title.add_theme_font_size_override("font_size",14);report_grid.add_child(title)
		for style in ["normal","hover","pressed","focus"]:title.add_theme_stylebox_override(style,StyleBoxEmpty.new())
		title.tooltip_text=title.text+" - click to sort; countdown row order stays fixed until sorting or reopening."
		title.pressed.connect(func():sort_report(i));report_headers.append(title)
	var rows: Array=session.public_rows(review_index)
	if report_sort>=0:
		rows.sort_custom(func(a,b):
			var av: Variant=report_sort_value(a);var bv: Variant=report_sort_value(b)
			if (av==null)!=(bv==null):return av!=null
			if av==bv:return a.learning_id<b.learning_id
			return av<bv if report_ascending else av>bv)
	report_order=rows.map(func(r):return r.learning_id)
	for row in rows:
		var id: int=row.contact_id
		for value in [row.center_id,"C-%03d" % id,row.attack]:
			var text:=Label.new();text.text=value;text.custom_minimum_size.y=48;text.add_theme_font_size_override("font_size",18);report_grid.add_child(text)
		var clock:=Label.new();clock.custom_minimum_size=Vector2(82,48);clock.add_theme_font_override("font",ThemeDB.fallback_font);clock.add_theme_font_size_override("font_size",15);report_grid.add_child(clock);time_labels[id]=clock
		var options: Array=[]
		for choice in row.choices:
			var defense: int=choice.id
			var control:=Button.new();control.text=choice.name;control.toggle_mode=true;control.custom_minimum_size=Vector2(224,48);control.add_theme_font_override("font",ThemeDB.fallback_font);control.add_theme_font_size_override("font_size",18)
			var pressed:=StyleBoxFlat.new();pressed.bg_color=Color("285a77");pressed.border_color=Color("97def5");pressed.set_border_width_all(2);control.add_theme_stylebox_override("pressed",pressed)
			control.mouse_entered.connect(func():show_explanation(control,defense))
			control.mouse_exited.connect(func():clear_explanation(control))
			var underline:=ColorRect.new();underline.name="SelectedUnderline";underline.mouse_filter=Control.MOUSE_FILTER_IGNORE
			var length: float=minf(208,ThemeDB.fallback_font.get_string_size(choice.name,HORIZONTAL_ALIGNMENT_LEFT,-1,18).x)
			place(control,underline,Rect2((224-length)/2,34,length,2));underline.hide()
			control.pressed.connect(func():select_answer(id,defense));report_grid.add_child(control);options.append(control)
		option_buttons[id]=options
		var cell:=Button.new();cell.flat=true;cell.custom_minimum_size=Vector2(120,48);cell.add_theme_font_override("font",ThemeDB.fallback_font);cell.add_theme_font_size_override("font_size",15);report_grid.add_child(cell);result_cells[id]=cell
		cell.mouse_entered.connect(func():show_result_details(id));cell.mouse_exited.connect(func():clear_explanation());cell.pressed.connect(func():show_result_details(id))
func sort_report(column: int) -> void:
	if report_sort==column:report_ascending=not report_ascending
	else:report_sort=column;report_ascending=true
	build_report();refresh()
func report_sort_value(row: Dictionary) -> Variant:
	match report_sort:
		0:return row.center_id
		1:return int(row.contact_id)
		2:return row.attack.to_lower()
		3:
			if review_index<0:return deadline_view(int(row.contact_id)).remaining
			if row.recorded_time=="EXPIRED":return 0.0
			var parts: PackedStringArray=row.recorded_time.split(":")
			if parts.size()==2 and parts[0].is_valid_int() and parts[1].is_valid_int():return float(parts[0])*60+float(parts[1])
			return null
		4,5,6,7:return row.choices[report_sort-4].name.to_lower()
		8:return (2 if row.result.hit else 3) if row.answered else 1 if row.selected!=null else 0
	return null
func focus_contact(id: int,explicit: bool=true) -> void:
	if explicit and learning_context:
		explicit_center=command.registry.contacts[id].center_id
		if view_mode=="single":reset_view()
	if not session.question(id).is_empty():session.focused=id
	command.decision_pages.select_contact(id)
	# Do not require or leave the detailed response window open for the simple learning flow.
	command.decision_pages.close_panel("threat",true)
func select_answer(id: int,defense: int) -> void:
	if review_index<0 and session.select_answer(id,defense):focus_contact(id)
	refresh()
func request_fire(delay: int) -> void:
	if review_index>=0 or animations_active():return
	session.advance(command.operations.session.now)
	var result: Dictionary=session.request_fire(session.focused,delay)
	if not result.ok:decide_message.text=result.error
	refresh()
func cancel_shot() -> void:session.cancel();refresh()
func restart_learning() -> void:
	for p in projectiles:
		if is_instance_valid(p):p.queue_free()
	restore_learning_visuals();projectiles.clear();session.reset();latest_result.clear();review_index=-1;orbital_display.configure(self);view_mode="multi";queued_reset_center="";apply_learning_visuals();why_label.hide();build_report();refresh()
func _process(_delta: float) -> void:
	if not is_instance_valid(command):return
	session.advance(command.operations.session.now)
	var shots: Array=session.begin_volley()
	if not shots.is_empty():
		learning_context=true
		# Restore the participating plots for this volley before computing any shot coordinates.
		var centers: Array=[]
		for shot in shots:
			var c: String=command.registry.contacts[int(shot.contact_id)].center_id
			if c not in centers:centers.append(c)
		centers.sort();orbital_display.layout_centers(centers);view_mode="multi" if centers.size()>1 else "single"
		focus_contact(int(shots[0].contact_id),false)
		for i in range(shots.size()):
			if shots.size()>1:shots[i].visual_lane=(i-2)*42.0;shots[i].volley=true
			launch(shots[i])
	update_learning_presentation()
	for p in projectiles:
		if is_instance_valid(p):p.step(session.now)
	projectiles=projectiles.filter(func(p):return is_instance_valid(p) and not p.is_queued_for_deletion())
	if projectiles.is_empty() and not queued_reset_center.is_empty() and learning_context:
		apply_single_view(queued_reset_center)
	apply_learning_visuals();refresh()
func actor_for(id: int) -> Node2D:
	var t=command.registry.contacts[id].tactical
	for actor in t.get_node("EnemyContainer").get_children():
		if actor.attack_id==id:return actor
	return null
func launch(shot: Dictionary) -> void:
	learning_context=true
	# Clear the small decision window during the shot so a moving target/impact cannot hide behind it.
	if page=="decide":close_page()
	update_learning_presentation()
	var id: int=shot.contact_id;var c: String=command.registry.contacts[id].center_id
	var actor=orbital_display.markers[id]
	shot.visual_scale=orbital_display.ratios[c];shot.visual_lane=shot.get("visual_lane",0.0)*orbital_display.ratios[c];shot.visual_bounds=orbital_display.tiles[c].grow(-18)
	var projectile=Projectile.new();projectile.setup(actor,orbital_display.origins[c],session.now,shot);orbital_display.add_child(projectile);projectiles.append(projectile)
	projectile.impacted.connect(impact)
func impact(id: int,generation: int) -> void:
	var result: Dictionary=session.finish_shot(id,generation)
	if not result.is_empty():latest_result=result
	apply_learning_visuals();refresh()
func apply_learning_visuals() -> void:
	for q in loader.questions:
		var id: int=q.contact_id;var actor=actor_for(id)
		if actor==null:continue
		var hidden: bool=learning_context and session.results.get(id,{}).get("hit",false)
		if hidden:
			if not saved_visuals.has(id):saved_visuals[id]=actor.visible
			actor.visible=false;actor.get_node("Area2D").input_pickable=false
			if actor.is_hovered:actor._on_area_2d_mouse_exited()
		elif saved_visuals.has(id):
			actor.visible=saved_visuals[id];actor.get_node("Area2D").input_pickable=command.registry.contacts[id].tactical.visible;saved_visuals.erase(id)
func feedback(result: Dictionary) -> String:
	if result.is_empty():return ""
	return "Correct countermeasure: "+result.correct_name+"\nLearning hit — "+result.attack_name+" exercise complete." if result.hit else "Incorrect countermeasure\nCorrect countermeasure: "+result.correct_name
func refresh() -> void:
	if windows.is_empty():return
	for key in nav:nav[key].set_pressed_no_signal(page==key)
	yes_button.disabled=not error.is_empty() or (session.round_complete() and session.has_next_round() and animations_active())
	report_status.text="Use A to analyze threats, then YES to prepare the Report." if not session.analyzed else "Select a defense, then D. Practice possibilities, not confirmed payloads; real defense is contextual."
	if session.analyzed:report_status.text=round_status()
	refresh_round_control()
	if session.analyzed and option_buttons.is_empty():build_report()
	for row in session.public_rows(review_index):
		var result: Dictionary=row.result
		var selected: Variant=result.get("answer",row.selected)
		for i in range(4):
			var b: Button=option_buttons[row.contact_id][i]
			var chosen: bool=selected==row.choices[i].id
			b.set_pressed_no_signal(chosen)
			b.disabled=review_index>=0 or row.answered or session.flights.has(row.contact_id)
			var underline: ColorRect=b.get_node("SelectedUnderline");underline.visible=chosen
			underline.color=Color("9de3ac") if row.answered and result.hit else Color("ff9898") if row.answered else Color("97def5")
			b.add_theme_color_override("font_disabled_color",Color.WHITE if chosen else Color("a3acb4"))
			if chosen and row.answered:
				var box:=StyleBoxFlat.new();box.bg_color=Color("234438") if result.hit else Color("482d34");b.add_theme_stylebox_override("disabled",box)
			else:b.remove_theme_stylebox_override("disabled")
		time_labels[row.contact_id].text=row.recorded_time if review_index>=0 else deadline_text(row.contact_id)
		time_labels[row.contact_id].tooltip_text="Recorded when this completed round was archived." if review_index>=0 else deadline_view(row.contact_id).source
		var cell: Button=result_cells[row.contact_id]
		cell.text="CORRECT" if row.answered and result.hit else "INCORRECT" if row.answered else "SELECTED" if selected!=null else "NOT ANSWERED"
		cell.add_theme_color_override("font_color",Color("9de3ac") if row.answered and result.hit else Color("ff9898") if row.answered else Color.WHITE)
		cell.add_theme_color_override("font_hover_color",Color("9de3ac") if row.answered and result.hit else Color("ff9898") if row.answered else Color.WHITE)
		cell.tooltip_text="Correct countermeasure: "+result.correct_name if row.answered else cell.text

	var q: Dictionary=session.question(session.focused)
	target_label.text="Choose a contact in Report" if q.is_empty() else "%s / C-%03d\n%s" % [q.center_id,q.contact_id,loader.attacks[int(q.attack_id)].attack_name]
	var has_answer: bool=not session.eligible().is_empty()
	var busy: bool=not session.pending.is_empty() or session.in_flight()
	for delay in fire_buttons:fire_buttons[delay].disabled=not has_answer or busy or animations_active() or review_index>=0
	var target_count: int=session.pending.get("shots",[]).size() if not session.pending.is_empty() else session.flights.size() if session.in_flight() else session.eligible().size()
	if target_count>1:target_label.text="%d selected contacts / associated data centers" % target_count
	fire_question.text="Fire on %d selected targets?" % target_count if target_count>1 else "Fire on target?"
	if session.in_flight():decide_message.text="%d shots in flight..." % session.flights.size()
	elif not session.pending.is_empty():
		decide_message.text=("Scheduled C-%03d: %s" % [session.pending.contact_id,preload("res://script/command_status.gd").format_time(ceil(session.countdown()))] if session.pending.shots.size()==1 else "Scheduled %d targets: %s" % [session.pending.shots.size(),preload("res://script/command_status.gd").format_time(ceil(session.countdown()))])
	else:decide_message.text="View current round in Report to fire." if review_index>=0 else "Select a countermeasure in Report first." if not has_answer else "Learning visual only - no operational defense."
	cancel_button.visible=not session.pending.is_empty()
	var result: Dictionary=session.results.get(session.focused,{})
	result_message.text=feedback(result)
	why_button.visible=not result.is_empty()
	if result.is_empty():why_label.hide()
	if not result.is_empty():why_label.text=command.decision_pages.words(loader.defenses[result.correct_id].definition,14)
	toast.visible=learning_context and page!="report" and (busy or not latest_result.is_empty())
	var lines: Array=[]
	for id in session.results:
		var r: Dictionary=session.results[id]
		lines.append("%s / C-%03d%s\n%s: %s" % [session.question(id).center_id,id," (late practice)" if r.get("late_practice",false) else "","Correct" if r.hit else "Incorrect; correct",r.correct_name])
	var height: float=maxf(182,lines.size()*54+30+(54 if busy else 0))
	toast.position.y=832-height;toast.size.y=height
	toast_label.size.y=height-20-(44 if not session.pending.is_empty() else 0)
	toast_label.add_theme_font_size_override("font_size",16 if lines.size()>1 else 17)
	toast_cancel.position.y=height-46
	toast_label.text=(decide_message.text+"\n" if busy else "")+"\n".join(lines)+("\n"+completion_status() if session.round_complete() else "")
	if session.round_complete():toast.size.y=height+54;toast.position.y=832-toast.size.y;toast_label.size.y+=54
	var m: Dictionary=session.metrics()
	score_label.visible=learning_context and session.analyzed
	score_label.text="Correct Answers: %d   Incorrect Answers: %d\nPercentage Correct: %.0f%%   Elapsed Time: %s" % [m.correct,m.incorrect,m.percentage,preload("res://script/command_status.gd").format_time(floor(m.elapsed))]
	update_learning_presentation()
	toast_cancel.visible=not session.pending.is_empty()
func show_explanation(control: Button,defense: int) -> void:
	hovered_choice=control
	var d: Dictionary=loader.defenses[defense]
	var description: String=d.get("definition","").strip_edges()
	hover_explanation.text=d.defense_name+": "+(command.decision_pages.words(description,23) if not description.is_empty() else "Description unavailable.")
	hover_explanation.show();report_status.hide()
func clear_explanation(control: Button=null) -> void:
	if control!=null and hovered_choice!=control:return
	hovered_choice=null
	if is_instance_valid(hover_explanation):hover_explanation.text="";hover_explanation.hide()
	if is_instance_valid(report_status):report_status.show()
static func format_deadline(seconds: Variant,expired: bool=false) -> String:
	if expired or (seconds!=null and seconds<=0):return "EXPIRED"
	if seconds==null:return "NO DEADLINE"
	var n:=int(ceil(float(seconds)))
	return "%02d:%02d" % [n/60,n%60]
func operational_deadline(id: int) -> Dictionary:
	var t=command.registry.contacts[id].tactical
	if id==t.encounter.active_contact_id and t.encounter_error.is_empty():
		return {"applies":true,"remaining":t.closed_remaining if t.encounter.resolved else t.deadline.remaining(t.active_contact),"expired":t.encounter.public_view(id).status=="Deadline expired","source":"P10 orbital"}
	var v: Dictionary=command.operations.session.view(id)
	if not v.is_empty():
		var expired: bool=command.operations.session.events().any(func(e):return e.contact_id==id and e.kind=="resolved" and e.get("details",{}).get("action")=="expire")
		if v.remaining!=null or expired:return {"applies":true,"remaining":v.remaining,"expired":expired,"source":"P10 operational"}
	return {"applies":false}
func deadline_view(id: int) -> Dictionary:
	if session.results.get(id,{}).get("learning_state","")=="NEUTRALIZED":return {"applies":true,"remaining":0.0,"expired":false,"neutralized":true,"source":"P11 neutralized learning question; original deadline unchanged"}
	var value:=operational_deadline(id)
	if value.applies:return value
	return {"applies":session.learning_remaining(id)!=null,"remaining":session.learning_remaining(id),"expired":session.learning_remaining(id)!=null and session.learning_remaining(id)<=0,"source":"P11 learning"}
func deadline_text(id: int) -> String:
	var value:=deadline_view(id)
	return "00:00" if value.get("neutralized",false) else format_deadline(value.remaining,value.expired)
func build_learning_presentation() -> void:
	orbital_canvas=CanvasLayer.new();orbital_canvas.layer=50;add_child(orbital_canvas)
	orbital_display=preload("res://script/learning_orbital_display.gd").new();orbital_canvas.add_child(orbital_display);orbital_display.configure(self);orbital_canvas.hide()
	reset_view_button=button(shell,"RESET TO ONE",Rect2(38,788,154,32),reset_view);reset_view_button.hide()
	learning_deadline_table=Tree.new();learning_deadline_table.columns=3;learning_deadline_table.hide_root=true;learning_deadline_table.column_titles_visible=true;learning_deadline_table.select_mode=Tree.SELECT_ROW;learning_deadline_table.allow_reselect=true
	learning_deadline_table.add_theme_font_override("font",ThemeDB.fallback_font);learning_deadline_table.add_theme_font_override("title_button_font",ThemeDB.fallback_font);learning_deadline_table.add_theme_font_size_override("font_size",15);learning_deadline_table.add_theme_font_size_override("title_button_font_size",14)
	place(shell,learning_deadline_table,Rect2(1168,52,416,124));learning_deadline_table.hide()
	learning_deadline_table.column_title_clicked.connect(func(column,_button=1):
		if learning_sort==column:learning_ascending=not learning_ascending
		else:learning_sort=column;learning_ascending=true
		refresh_learning_deadlines())
	learning_deadline_table.item_selected.connect(func():
		if learning_deadline_table.get_selected()!=null:focus_contact(int(learning_deadline_table.get_selected().get_metadata(0))))
	for i in range(3):learning_deadline_table.set_column_expand(i,false);learning_deadline_table.set_column_custom_minimum_width(i,[110,160,118][i])
func refresh_learning_deadlines() -> void:
	var ids: Array=loader.questions.map(func(q):return int(q.contact_id))
	ids.sort_custom(func(a,b):
		var av: Variant=command.registry.contacts[a].center_id if learning_sort==0 else a if learning_sort==1 else deadline_view(a).remaining
		var bv: Variant=command.registry.contacts[b].center_id if learning_sort==0 else b if learning_sort==1 else deadline_view(b).remaining
		if (av==null)!=(bv==null):return av!=null
		if av==bv:return a<b
		return av<bv if learning_ascending else av>bv)
	if learning_deadline_table.get_meta("ids",[])!=ids:
		learning_deadline_table.clear();learning_deadline_items.clear();var root=learning_deadline_table.create_item()
		for id in ids:
			var item=learning_deadline_table.create_item(root);item.set_metadata(0,id);learning_deadline_items[id]=item
		learning_deadline_table.set_meta("ids",ids)
	for id in ids:
		var item=learning_deadline_items[id];var value:=deadline_view(id)
		item.set_text(0,command.registry.contacts[id].center_id);item.set_text(1,"C-%03d" % id);item.set_text(2,deadline_text(id));item.set_tooltip_text(2,value.source+" deadline. Expired learning opportunities remain available for late practice; P10 outcomes are unchanged.")
	for i in range(3):learning_deadline_table.set_column_title(i,["Data Center","Learning Contact","Time"][i]+(" ^" if learning_ascending else " v") if learning_sort==i else ["Data Center","Learning Contact","Time"][i])
func update_learning_presentation() -> void:
	if not is_instance_valid(orbital_display):return
	var enabled: bool=learning_context and session.analyzed
	reset_view_button.visible=enabled and orbital_display.centers.size()>1
	if enabled and not world_hidden:old_deadline_visible=command.decision_pages.deadline_table.visible
	orbital_canvas.visible=enabled;orbital_display.sync(enabled)
	learning_deadline_table.visible=enabled
	if enabled:
		for t in command.tactical_centers.values():t.visible=false
		command.decision_pages.deadline_table.hide();refresh_learning_deadlines();world_hidden=true
	elif world_hidden:
		for c in command.tactical_centers:command.tactical_centers[c].visible=c==command.focused_center and not command.scorecard_open
		command.decision_pages.deadline_table.visible=old_deadline_visible;world_hidden=false
func refresh_round_control() -> void:
	if not is_instance_valid(round_control):return
	var signature: String="%d/%d/%d" % [session.round_index,session.round_history.size(),review_index]
	if signature==round_control_signature:return
	round_control_signature=signature;round_control.clear();round_control.add_item("Current round %d" % [session.round_index+1]);round_control.set_item_metadata(0,-1)
	for i in range(session.round_history.size()):round_control.add_item("Round %d - completed results" % [i+1]);round_control.set_item_metadata(i+1,i)
	round_control.select(review_index+1 if review_index>=0 else 0)
func select_report_round(index: int) -> void:
	review_index=int(round_control.get_item_metadata(index));build_report();refresh()
func show_result_details(id: int) -> void:
	for row in session.public_rows(review_index):
		if row.contact_id==id and row.answered:
			hover_explanation.text="C-%03d / Correct countermeasure: %s" % [id,row.result.correct_name];hover_explanation.show();report_status.hide();return
func completion_status() -> String:
	if not session.round_complete():return ""
	if session.has_next_round():return "Next round available - A / YES"
	var m: Dictionary=session.metrics()
	return "Session complete: %d correct / %d incorrect / %.0f%%" % [m.correct,m.incorrect,m.percentage]
func round_status() -> String:
	if review_index>=0:return "Completed round %d / read-only. Cumulative score is shown above." % [review_index+1]
	return "Round %d of %d / %s" % [session.round_index+1,loader.rounds.size(),completion_status() if session.round_complete() else "Scheduled %d targets: %s" % [session.pending.shots.size(),preload("res://script/command_status.gd").format_time(ceil(session.countdown()))] if not session.pending.is_empty() else "Choose countermeasures, then D. Seed %d" % session_seed]
func animations_active() -> bool:
	return projectiles.any(func(p):return is_instance_valid(p) and not p.is_queued_for_deletion())
func reset_center() -> String:
	return explicit_center if not explicit_center.is_empty() else "DC-01"
func reset_view() -> void:
	if animations_active():queued_reset_center=reset_center();reset_view_button.tooltip_text="Reset queued until the current impact animations finish.";return
	apply_single_view(reset_center())
func apply_single_view(center: String) -> void:
	view_mode="single";orbital_display.layout_centers([center]);queued_reset_center="";reset_view_button.tooltip_text="Return to one large data center without resetting learning progress."
	var ui=command.decision_pages;ui.center_control.select(command.tactical_centers.keys().find(center));update_learning_presentation()
func on_learning_center_selected(index: int) -> void:
	if not learning_context:return
	explicit_center=command.decision_pages.center_control.get_item_text(index);command.decision_pages.close_panel("threat",true)
	if view_mode=="single":reset_view()
func restore_learning_visuals() -> void:
	for id in saved_visuals:
		var actor=actor_for(int(id));actor.visible=saved_visuals[id];actor.get_node("Area2D").input_pickable=command.registry.contacts[id].center_id==command.focused_center and not command.scorecard_open
	saved_visuals.clear()
func _exit_tree() -> void:
	if is_instance_valid(command):
		learning_context=false;apply_learning_visuals();update_learning_presentation()
		for control in old_layout:
			if is_instance_valid(control):control.position=old_layout[control].position;control.size=old_layout[control].size
