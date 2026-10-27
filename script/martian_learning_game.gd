extends "res://script/learning_game.gd"
## Prototype 12: isolated presentation/defense extension; accepted P11 remains runnable.
const MartianSession=preload("res://script/martian_learning_session.gd")
const MartianProjectile=preload("res://script/martian_projectile.gd")
const MartianDisplay=preload("res://script/martian_orbital_display.gd")
const DefensePanel=preload("res://script/martian_defense_panel.gd")
var definition_box: Panel
var next_round_button: Button
var martian: Panel
func _ready() -> void:
	session=MartianSession.new()
	super._ready()
func build_learning_presentation() -> void:
	super.build_learning_presentation()
	orbital_canvas.remove_child(orbital_display);orbital_display.queue_free()
	orbital_display=MartianDisplay.new();orbital_canvas.add_child(orbital_display);orbital_display.configure(self)
	reset_view_button.text="RESET TO 1 DATA CENTER";reset_view_button.size.x=300
func build() -> void:
	super.build()
	windows.report.size.y=660
	for panel in windows.values():panel.z_index=10
	definition_box=Panel.new();place(windows.report,definition_box,Rect2(18,388,1524,200))
	var border:=StyleBoxFlat.new();border.bg_color=Color("111a25");border.border_color=Color("ff4848");border.set_border_width_all(3);definition_box.add_theme_stylebox_override("panel",border)
	hover_explanation.reparent(definition_box);hover_explanation.position=Vector2(14,10);hover_explanation.size=Vector2(1496,180);hover_explanation.add_theme_font_size_override("font_size",34);hover_explanation.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	definition_box.hide()
	report_status.position=Vector2(18,592);report_status.size=Vector2(930,54)
	restart_button.position=Vector2(1190,600)
	next_round_button=button(windows.report,"NEXT ROUND",Rect2(980,600,190,40),next_round);next_round_button.hide()
	martian=DefensePanel.new();martian.configure(self)
func leave_learning() -> void:
	super.leave_learning()
	if is_instance_valid(martian):martian.hide();martian.alarm.stream_paused=true
func analyze() -> void:
	if session.round_complete():
		review_index=-1;build_report();show_page("report")
		return
	super.analyze()
func next_round() -> void:
	if not session.round_complete() or not session.has_next_round() or animations_active() or not session.pending.is_empty():return
	var times: Dictionary={}
	for q in loader.questions:times[int(q.contact_id)]=deadline_text(int(q.contact_id))
	restore_learning_visuals()
	if not session.advance_round(command.registry.public_rows(),times):return
	latest_result.clear();martian.reset_panel();orbital_display.configure(self);view_mode="multi";queued_reset_center=""
	super.analyze()
func restart_learning() -> void:
	if is_instance_valid(martian):martian.reset_panel()
	super.restart_learning()
func launch(shot: Dictionary) -> void:
	learning_context=true
	if not page.is_empty():close_page()
	update_learning_presentation()
	var id: int=shot.contact_id;var c: String=command.registry.contacts[id].center_id
	var actor=orbital_display.markers[id]
	shot.visual_scale=orbital_display.ratios[c];shot.visual_bounds=orbital_display.tiles[c]
	var projectile=MartianProjectile.new();projectile.setup(actor,orbital_display.origins[c],session.now,shot);orbital_display.add_child(projectile);projectiles.append(projectile)
	projectile.impacted.connect(impact);martian.add_shot(projectile)
func apply_learning_visuals() -> void:
	for q in loader.questions:
		var id: int=q.contact_id;var actor=actor_for(id)
		if learning_context and not orbital_display.physical_alive(id):
			if not saved_visuals.has(id):saved_visuals[id]=actor.visible
			actor.visible=false;actor.get_node("Area2D").input_pickable=false
		elif saved_visuals.has(id):
			actor.visible=saved_visuals[id];actor.get_node("Area2D").input_pickable=command.registry.contacts[id].tactical.visible;saved_visuals.erase(id)
func feedback(result: Dictionary) -> String:
	if result.is_empty():return ""
	var answer: String="Correct countermeasure: "+result.correct_name if result.hit else "Incorrect countermeasure\nCorrect countermeasure: "+result.correct_name
	return answer+"\nProjectile: "+result.get("projectile_outcome","PENDING")
func refresh() -> void:
	super.refresh()
	if is_instance_valid(definition_box):definition_box.visible=hover_explanation.visible
	if is_instance_valid(next_round_button):next_round_button.visible=review_index<0 and session.round_complete() and session.has_next_round() and not animations_active() and session.pending.is_empty()
	if is_instance_valid(martian):
		martian.refresh()
		if not learning_context or page=="report":martian.hide()
		elif not martian.incoming().is_empty():martian.show()
		# The new right-side defense view carries per-shot outcomes while open; history remains in Report.
		if martian.visible:toast.hide()
	for row in session.public_rows(review_index):
		if row.answered:result_cells[row.contact_id].tooltip_text+="\nProjectile: "+row.result.get("projectile_outcome","PENDING")
func show_result_details(id: int) -> void:
	super.show_result_details(id)
	for row in session.public_rows(review_index):
		if row.contact_id==id and row.answered:hover_explanation.text+="\nProjectile outcome: "+row.result.get("projectile_outcome","PENDING");return
func completion_status() -> String:
	if not session.round_complete():return ""
	if session.has_next_round():return "Finishing projectile effects..." if animations_active() else "Next round available - click NEXT ROUND"
	var m: Dictionary=session.metrics()
	return "Session complete: %d correct / %d incorrect / %.0f%%" % [m.correct,m.incorrect,m.percentage]

func build_report() -> void:
	super.build_report()
	var questions: Array=session.round_history[review_index].questions if review_index>=0 else loader.questions
	for index in range(report_order.size()):
		var learning_id: String=report_order[index]
		var matches: Array=questions.filter(func(q):return q.get("learning_id",q.question_id)==learning_id)
		if matches.is_empty():continue
		var q: Dictionary=matches[0]
		var old: Control=report_grid.get_child(9+index*9+2)
		var attack:=Button.new();attack.flat=true;attack.text=old.text;attack.custom_minimum_size=old.custom_minimum_size;attack.add_theme_font_size_override("font_size",18)
		report_grid.remove_child(old);old.queue_free();report_grid.add_child(attack);report_grid.move_child(attack,9+index*9+2)
		attack.mouse_entered.connect(func():show_attack_explanation(attack,int(q.attack_id)))
		attack.mouse_exited.connect(func():clear_explanation(attack))
		attack.pressed.connect(func():show_attack_explanation(attack,int(q.attack_id)))
		attack.tooltip_text="Review attack definition"
		var contact: Control=report_grid.get_child(9+index*9+1)
		contact.tooltip_text="Physical target: "+session.question_targets.get(learning_id,"Not introduced yet")
func show_attack_explanation(control: Button,attack_id: int) -> void:
	hovered_choice=control
	var attack: Dictionary=loader.attacks.get(attack_id,{})
	var description: String=str(attack.get("definition",""))
	if description.strip_edges().is_empty():description="No description available in the current catalog."
	hover_explanation.text=str(attack.get("attack_name","Unknown attack"))+"\n"+description
	hover_explanation.show();report_status.hide()
	if is_instance_valid(definition_box):definition_box.show()
