extends "res://script/correct_only_learning_game.gd"
var detail_panel: Panel
var detail_button: Button
func create_learning_loader() -> RefCounted:return preload("res://script/rich_learning_loader.gd").new()
func _ready() -> void:
	super._ready()
	var clock: float=session.now;session=preload("res://script/rich_learning_session.gd").new();session.configure(loader);session.advance(clock)
	detail_panel=preload("res://script/learning_detail_panel.gd").new();detail_panel.configure(self)
	submit_answers_button.add_theme_font_override("font",ThemeDB.fallback_font);submit_answers_button.add_theme_font_size_override("font_size",18)
	detail_button=button(windows.report,"QUESTION & LESSON",Rect2(590,10,260,32),open_selected_lesson)
	label(windows.report,Rect2(18,54,1524,20),14).text="Click an attack to read its scenario. Full explanations are in QUESTION & LESSON. Editorial candidate — not production approved."
	report_grid.position.y=86;report_grid.size.y=480;refresh()
func build_learning_presentation() -> void:
	super.build_learning_presentation();orbital_canvas.remove_child(orbital_display);orbital_display.queue_free()
	orbital_display=preload("res://script/pursuit_display.gd").new();orbital_canvas.add_child(orbital_display);orbital_display.configure(self)
func build_report() -> void:
	super.build_report()
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
func open_selected_lesson() -> void:
	var data: Array=session.round_history[review_index].questions if review_index>=0 else loader.questions
	if data.is_empty():return
	var matches: Array=data.filter(func(q):return int(q.contact_id)==session.focused)
	open_lesson(data[0] if matches.is_empty() else matches[0])
func open_lesson(q: Dictionary) -> void:
	if is_instance_valid(detail_panel):detail_panel.open_question(q,review_index>=0)
func select_answer(id: int,defense: int) -> void:
	super.select_answer(id,defense)
	if session.answers.get(id)==defense and is_instance_valid(detail_panel):
		if not detail_panel.visible:open_lesson(session.question(id))
		else:detail_panel.render_content()
		detail_panel.call_deferred("show_defense")
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
		for control in option_buttons[row.contact_id]:
			var line: ColorRect=control.get_node("SelectedUnderline")
			var font: Font=control.get_theme_font("font");var text_size: Vector2=font.get_multiline_string_size(control.text,HORIZONTAL_ALIGNMENT_CENTER,control.size.x-12,control.get_theme_font_size("font_size"))
			var width: float=minf(control.size.x-16,text_size.x)
			line.position=Vector2((control.size.x-width)/2,minf(control.size.y-4,control.size.y/2+text_size.y/2+2));line.size=Vector2(width,2)
			if row.answered:line.color=Color("9de3ac") if row.result.get("answer_correct",row.result.hit) else Color("ff9898")
			if row.answered and control.button_pressed:
				var box:=StyleBoxFlat.new();box.bg_color=Color("234438") if row.result.get("answer_correct",row.result.hit) else Color("482d34");control.add_theme_stylebox_override("disabled",box)
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
