extends "res://script/correct_only_learning_game.gd"
var detail_panel: Panel
var detail_button: Button
const AnswerControls=preload("res://script/learning_answer_controls.gd")
var fire_mode_control: OptionButton
var fire_status: Label
var target_picker: OptionButton
var player_target:=-1
var last_player_fire:=""
var war_room: Panel
var war_room_button: Button
var weapon_overlay: Node2D
var requested_fire_mode:=""
func create_learning_loader() -> RefCounted:return preload("res://script/rich_learning_loader.gd").new()
func _ready() -> void:
	super._ready()
	var clock: float=session.now;session=preload("res://script/player_fire_session.gd").new();session.configure(loader);session.advance(clock)
	detail_panel=preload("res://script/learning_detail_panel.gd").new();detail_panel.configure(self)
	submit_answers_button.add_theme_font_override("font",ThemeDB.fallback_font);submit_answers_button.add_theme_font_size_override("font_size",18)
	detail_button=button(windows.report,"QUESTION & LESSON",Rect2(590,10,260,32),open_selected_lesson)
	label(windows.report,Rect2(18,54,1524,20),14).text="Click an attack to read its scenario. Full explanations are in QUESTION & LESSON. Editorial candidate — not production approved."
	report_grid.position.y=86;report_grid.size.y=480;build_fire_controls();refresh()
func build_learning_presentation() -> void:
	super.build_learning_presentation();orbital_canvas.remove_child(orbital_display);orbital_display.queue_free()
	orbital_display=preload("res://script/pursuit_display.gd").new();orbital_canvas.add_child(orbital_display);orbital_display.configure(self)
func build_report() -> void:
	super.build_report()
	for i in range(4,8):report_headers[i].text=report_headers[i].text.replace("OPTION","ANSWER OPTION")
	for i in range(report_order.size()):
		var identity: String=report_order[i];var data: Array=session.round_history[review_index].questions if review_index>=0 else loader.questions
		var matches: Array=data.filter(func(q):return q.learning_id==identity)
		if matches.is_empty():continue
		var q: Dictionary=matches[0];var attack: Button=report_grid.get_child(9+i*9+2)
		attack.text=loader.rich_attacks[int(q.attack_id)].display_name;attack.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;attack.custom_minimum_size.y=80;attack.add_theme_font_override("font",ThemeDB.fallback_font);attack.add_theme_font_size_override("font_size",16)
		attack.tooltip_text="Read full scenario, definition and examples";attack.pressed.connect(func():open_lesson(q))
		result_cells[int(q.contact_id)].pressed.connect(func():open_lesson(q))
		for j in range(9):report_grid.get_child(9+i*9+j).custom_minimum_size.y=80
		for j in range(4):
			var id:=int(q.options[j]);var control: Button=option_buttons[int(q.contact_id)][j]
			# Short catalog labels remain on the board; complete names/text are never shortened in the teaching panel.
			control.tooltip_text=loader.rich_defenses[id].display_name
			AnswerControls.install(self,q,control,id)
func open_selected_lesson() -> void:
	var data: Array=session.round_history[review_index].questions if review_index>=0 else loader.questions
	if data.is_empty():return
	var matches: Array=data.filter(func(q):return int(q.contact_id)==session.focused)
	open_lesson(data[0] if matches.is_empty() else matches[0])
func open_lesson(q: Dictionary) -> void:
	if is_instance_valid(detail_panel):detail_panel.open_question(q,review_index>=0)
func select_answer(id: int,defense: int) -> void:
	super.select_answer(id,defense)
	if is_instance_valid(detail_panel) and detail_panel.visible:detail_panel.preview_defense=defense;detail_panel.render_content()
func open_answer_lesson(q: Dictionary,defense: int,review: bool=false) -> void:
	detail_panel.open_question(q,review_index>=0 and not review,review);detail_panel.preview_defense=defense;detail_panel.render_content();detail_panel.call_deferred("show_defense")
func show_explanation(control: Button,defense: int) -> void:
	hovered_choice=control
	# Hover is informative but never reveals answer keys or changes the selection.
	control.tooltip_text=loader.rich_defenses[defense].display_name+"\n"+loader.rich_defenses[defense].definition
func show_attack_explanation(control: Button,attack_id: int) -> void:
	hovered_choice=control;control.tooltip_text=loader.rich_attacks[attack_id].display_name+"\n"+loader.rich_attacks[attack_id].definition
func show_result_details(id: int) -> void:
	if result_cells.has(id):result_cells[id].tooltip_text="Click to read this question's full lesson and available result reasoning."
func feedback(result: Dictionary) -> String:
	if result.is_empty():return ""
	var name: String=loader.rich_defenses[int(result.correct_id)].display_name
	if not result.get("answer_correct",false):return "Incorrect Answer — Missile Not Launched\nCorrect countermeasure: "+name
	return "Correct Answer — "+name+"\nProjectile: "+result.get("projectile_outcome","PENDING")
func refresh() -> void:
	super.refresh()
	if is_instance_valid(definition_box):definition_box.hide()
	if is_instance_valid(detail_button):detail_button.disabled=not session.analyzed
	if is_instance_valid(detail_panel) and detail_panel.visible:detail_panel.render_content()
	for row in session.public_rows(review_index):
		if not option_buttons.has(row.contact_id):continue
		for index in range(4):
			var control: Button=option_buttons[row.contact_id][index]
			AnswerControls.update(control,control.button_pressed,control.disabled,row.answered,int(row.choices[index].id)==int(row.result.get("correct_id",-1)))
			var line: ColorRect=control.get_node("SelectedUnderline")
			var font: Font=control.get_theme_font("font");var text_size: Vector2=font.get_multiline_string_size(control.text,HORIZONTAL_ALIGNMENT_CENTER,control.size.x-12,control.get_theme_font_size("font_size"))
			var width: float=minf(control.size.x-16,text_size.x)
			line.position=Vector2((control.size.x-width)/2,minf(control.size.y-4,control.size.y/2+text_size.y/2+2));line.size=Vector2(width,2)
			if row.answered:line.color=Color("9de3ac") if row.result.get("answer_correct",row.result.hit) else Color("ff9898")
			if row.answered and control.button_pressed:
				var box:=StyleBoxFlat.new();box.bg_color=Color("234438") if row.result.get("answer_correct",row.result.hit) else Color("482d34");control.add_theme_stylebox_override("disabled",box)
	if is_instance_valid(fire_mode_control):refresh_fire_controls()
func launch(shot: Dictionary) -> void:
	if not session.claim_launch(shot):return
	if is_instance_valid(detail_panel):detail_panel.dismiss()
	learning_context=true
	if not page.is_empty():close_page()
	update_learning_presentation()
	var id:=int(shot.contact_id);var center: String=learning_contacts[id].center_id
	shot.visual_scale=orbital_display.ratios[center];shot.visual_bounds=orbital_display.tiles[center].grow(-12)
	orbital_display.start_pursuit(id,shot)
	var p=preload("res://script/pursuit_projectile.gd").new();p.setup(orbital_display.markers[id],orbital_display.origins[center],session.now,shot);orbital_display.add_child(p);projectiles.append(p);p.impacted.connect(impact);martian.add_shot(p)
func leave_learning() -> void:
	if is_instance_valid(detail_panel):detail_panel.dismiss()
	super.leave_learning()
func show_page(key: String) -> void:
	if is_instance_valid(detail_panel):detail_panel.dismiss()
	super.show_page(key)
func close_page() -> void:
	var was_report: bool=page=="report"
	super.close_page()
	if was_report:learning_context=true;update_learning_presentation()
func submit_report() -> void:
	if review_index>=0 or session.review_locked or animations_active():return
	session.advance(command.operations.session.now)
	var response: Dictionary=session.submit_answers(0)
	if not response.ok:submission_notice=response.error;refresh();return
	submission_notice="";detail_panel.dismiss();close_page();learning_context=true
	orbital_display.layout_centers(["DC-01","DC-02","DC-03","DC-04","DC-05","DC-06"]);view_mode="multi";update_learning_presentation();refresh()
func round_status() -> String:
	return super.round_status().replace("Choose all answers, then SUBMIT ANSWERS (now), or D for WAIT.","Choose one or more answers, then SUBMIT ANSWERS; D offers WAIT.")
func restart_learning() -> void:
	if is_instance_valid(detail_panel):detail_panel.dismiss()
	super.restart_learning()
func enter_review() -> void:
	if animations_active() or not session.pending.is_empty():return
	var model=session.start_review()
	if model==null:return
	review_model=model;completion_prompt.hide();close_page();martian.hide()
	review_panel=preload("res://script/rich_review_panel.gd").new();review_panel.configure(self,review_model)

func report_submission_disabled() -> bool:
	var busy: bool=not session.pending.is_empty() or session.in_flight() or animations_active()
	submit_answers_button.tooltip_text="Wait for the current launch queue, flights and effects to finish." if busy else "Submit only new selected answers. Unanswered questions remain available."
	return not session.analyzed or session.review_locked or session.round_complete() or busy

func build_fire_controls() -> void:
	fire_mode_control=OptionButton.new();place(shell,fire_mode_control,Rect2(20,105,270,28));fire_mode_control.add_item("AUTO-FIRE");fire_mode_control.add_item("PLAYER FIRE");fire_mode_control.item_selected.connect(change_fire_mode)
	war_room_button=button(shell,"MARTIAN WAR ROOM",Rect2(306,105,258,28),func():war_room.open_room())
	fire_status=label(shell,Rect2(580,105,570,28),15)
	target_picker=OptionButton.new();place(shell,target_picker,Rect2(380,138,770,32));target_picker.item_selected.connect(func(index):player_target=int(target_picker.get_item_metadata(index)))
	war_room=preload("res://script/martian_war_room.gd").new();war_room.configure(self)
	weapon_overlay=preload("res://script/learning_weapon_overlay.gd").new();orbital_display.add_child(weapon_overlay);weapon_overlay.configure(self)
	arrange_toolbar()
func arrange_toolbar() -> void:
	var ui=command.decision_pages
	var bar=ui.top_buttons.overview.get_parent()
	for control in ui.top_buttons.values()+nav.values()+[ui.center_control,ui.mode_select,ui.role_select,ui.pause_button,war_room_button]:control.custom_minimum_size.x=0
	var keys=["overview","contacts","threat","intelligence","history","mission"]
	for i in range(keys.size()):ui.top_buttons[keys[i]].position.x=8+i*48;ui.top_buttons[keys[i]].size.x=44
	ui.top_buttons.alerts.position.x=296;ui.top_buttons.alerts.size.x=78
	for i in range(3):nav[["analyze","report","decide"][i]].position.x=380+i*44;nav[["analyze","report","decide"][i]].size.x=40
	ui.center_control.position.x=520;ui.center_control.size.x=112
	ui.mode_select.position.x=640;ui.mode_select.size.x=184
	ui.role_select.position.x=832;ui.role_select.size.x=228
	war_room_button.reparent(bar);war_room_button.position=Vector2(1068,4);war_room_button.size=Vector2(252,34)
	war_room_button.add_theme_font_size_override("font_size",16)
	for control in [ui.mode_select,ui.role_select]:
		control.fit_to_longest_item=false;control.add_theme_font_size_override("font_size",17);control.add_theme_font_override("font",ThemeDB.fallback_font)
		control.get_popup().add_theme_font_size_override("font_size",17);control.get_popup().add_theme_font_override("font",ThemeDB.fallback_font)
	ui.mode_select.size.x=184;ui.role_select.size.x=228
	ui.pause_button.text="PAUSE";ui.pause_button.position.x=1404;ui.pause_button.size.x=164
	for child in bar.get_children():
		if child is Label and child.text=="ODC":child.position.x=1330;child.size.x=60
func mode_modal_open() -> bool:
	return not command.decision_pages.active_panel.is_empty() or not page.is_empty() or detail_panel.visible or war_room.visible or completion_prompt.visible or (is_instance_valid(review_panel) and review_panel.visible)
func change_fire_mode(index: int) -> void:
	requested_fire_mode="AUTO-FIRE" if index==0 else "PLAYER FIRE"
	refresh_fire_controls()
func refresh_fire_controls() -> void:
	if not requested_fire_mode.is_empty() and not mode_modal_open():
		session.set_firing_mode(requested_fire_mode);requested_fire_mode="";last_player_fire=""
	var shown: String=session.firing_mode if requested_fire_mode.is_empty() else requested_fire_mode
	fire_mode_control.select(0 if shown=="AUTO-FIRE" else 1)
	fire_question.text="Authorize correct answers for PLAYER FIRE?" if session.firing_mode=="PLAYER FIRE" else "Launch correct answers only?"
	fire_buttons[0].text="AUTHORIZE NOW" if session.firing_mode=="PLAYER FIRE" else "FIRE NOW"
	fire_mode_control.disabled=false
	fire_mode_control.tooltip_text="Switch any time; pending missiles retain targets, readiness and 15-second launch spacing. Requests made in a window apply when it closes."
	var auth: Array=session.authorized_targets();var ids: Array=auth.map(func(s):return int(s.contact_id))
	var old: Array=[]
	for i in range(target_picker.item_count):old.append(int(target_picker.get_item_metadata(i)))
	if ids!=old:
		target_picker.clear()
		for id in ids:target_picker.add_item("");target_picker.set_item_metadata(target_picker.item_count-1,id)
	if player_target not in ids:player_target=ids[0] if not ids.is_empty() else -1
	for i in range(ids.size()):
		var id: int=ids[i];var remaining: float=maxf(0,float(session.ready_at(id))-session.now)
		target_picker.set_item_text(i,"%s / C-%03d / %s" % [learning_contacts[id].center_id,id,"READY - left click its orbital tile" if remaining<=0 else "Ready in %.1fs" % remaining])
		if id==player_target:target_picker.select(i)
	target_picker.visible=session.firing_mode=="PLAYER FIRE" and not auth.is_empty() and learning_context
	fire_status.text="AUTO-FIRE / correct answers launch automatically" if session.firing_mode=="AUTO-FIRE" else "PLAYER FIRE / %d authorized / %s" % [auth.size(),last_player_fire if not last_player_fire.is_empty() else "select target, aim and click its tile"]
	if not requested_fire_mode.is_empty():fire_status.text="Mode requested: "+requested_fire_mode+" / applies when window closes"
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index==MOUSE_BUTTON_LEFT:
		if player_fire_at(event.position):get_viewport().set_input_as_handled()
func player_fire_at(point: Vector2) -> bool:
	if session.firing_mode!="PLAYER FIRE" or not learning_context or not page.is_empty() or detail_panel.visible or war_room.visible or completion_prompt.visible or (is_instance_valid(review_panel) and review_panel.visible):return false
	if player_target<0 or not learning_contacts.has(player_target):return false
	var center: String=learning_contacts[player_target].center_id
	if not orbital_display.tiles.has(center) or not orbital_display.tiles[center].has_point(point):return false
	var hovered: Control=get_viewport().gui_get_hovered_control()
	if hovered!=null and hovered.mouse_filter!=Control.MOUSE_FILTER_IGNORE:return false
	var shots: Array=session.fire_authorized(player_target)
	for shot in shots:launch(shot);last_player_fire="FIRED C-%03d" % int(shot.contact_id)
	refresh_fire_controls();return not shots.is_empty()
