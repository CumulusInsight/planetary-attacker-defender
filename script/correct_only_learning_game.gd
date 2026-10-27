extends "res://script/six_center_learning_game.gd"
var completion_prompt: Panel
var completion_text: Label
var review_button: Button
var finish_session_button: Button
var review_panel: Panel
var review_model: RefCounted
var completion_prompted:=false
var prepared_batch:=-1
var submit_answers_button: Button
var submission_notice:=""
func _ready() -> void:
	super._ready()
	closes.report.text="CLOSE";closes.report.position=Vector2(1230,10);closes.report.size=Vector2(108,32)
	submit_answers_button=button(windows.report,"SUBMIT ANSWERS",Rect2(1346,10,196,32),submit_report)
	round_control.position=Vector2(866,10);round_control.size=Vector2(350,32)
	for child in windows.report.get_children():
		if child is Label and child.position.y<40:child.text="REPORT"
	var current_clock: float=session.now
	session=preload("res://script/correct_only_learning_session.gd").new();session.configure(loader);session.advance(current_clock)
	completion_prompt=Panel.new();place(shell,completion_prompt,Rect2(340,230,920,350));completion_prompt.z_index=40
	label(completion_prompt,Rect2(24,18,800,32),22).text="LEARNING SESSION COMPLETE"
	var line:=HSeparator.new();place(completion_prompt,line,Rect2(24,60,872,4))
	completion_text=label(completion_prompt,Rect2(24,80,872,176),21)
	review_button=button(completion_prompt,"REVIEW MISSED QUESTIONS",Rect2(24,280,540,44),enter_review)
	finish_session_button=button(completion_prompt,"FINISH SESSION",Rect2(584,280,312,44),func():completion_prompt.hide())
	completion_prompt.hide();refresh()
func request_fire(delay: int) -> void:
	if session.review_locked:return
	super.request_fire(delay)
func launch(shot: Dictionary) -> void:
	if not session.claim_launch(shot):return
	learning_context=true
	if not page.is_empty():close_page()
	update_learning_presentation()
	var id: int=shot.contact_id;var center: String=learning_contacts[id].center_id
	shot.visual_scale=orbital_display.ratios[center];shot.visual_bounds=orbital_display.tiles[center].grow(-12)
	var p=preload("res://script/correct_only_projectile.gd").new();p.setup(orbital_display.markers[id],orbital_display.origins[center],session.now,shot);orbital_display.add_child(p);projectiles.append(p);p.impacted.connect(impact);martian.add_shot(p)
func _process(_delta: float) -> void:
	if not is_instance_valid(command):return
	session.advance(command.operations.session.now)
	var shots: Array=session.begin_volley()
	if not shots.is_empty():
		learning_context=true
		if prepared_batch!=int(shots[0].batch_id):
			prepared_batch=int(shots[0].batch_id);var centers: Array=session.launch_centers.duplicate()
			if centers.size()>3:centers=["DC-01","DC-02","DC-03","DC-04","DC-05","DC-06"]
			if not centers.all(func(c):return c in orbital_display.centers):orbital_display.layout_centers(centers)
			view_mode="multi" if orbital_display.centers.size()>1 else "single"
		focus_contact(int(shots[0].contact_id),false)
		for shot in shots:launch(shot)
	update_learning_presentation()
	for p in projectiles:
		if is_instance_valid(p):p.step(session.now)
	projectiles=projectiles.filter(func(p):return is_instance_valid(p) and not p.is_queued_for_deletion())
	if projectiles.is_empty() and not queued_reset_center.is_empty() and learning_context:apply_single_view(queued_reset_center)
	refresh()
func refresh() -> void:
	super.refresh()
	fire_question.text="Launch correct answers only?"
	if session.analyzed and review_index<0 and not session.round_complete():report_status.text+="\nCorrect-only launches, 15 seconds apart. Wrong answers do not fire."
	for id in option_buttons:
		for control in option_buttons[id]:control.tooltip_text=control.text
		if session.is_pending(id):
			for control in option_buttons[id]:control.disabled=true;control.tooltip_text="Queued answer locked. Cancel the remaining launch queue to change it."
	if is_instance_valid(submit_answers_button):
		submit_answers_button.visible=review_index<0 and not session.review_locked and not session.round_complete()
		submit_answers_button.disabled=not session.analyzed or session.review_locked or session.round_complete() or not session.pending.is_empty() or session.in_flight() or animations_active() or loader.questions.any(func(q):return session.submitted_questions.has(q.learning_id))
		for q in loader.questions:
			if session.submitted_questions.has(q.learning_id) and option_buttons.has(int(q.contact_id)):
				for control in option_buttons[int(q.contact_id)]:control.disabled=true;control.tooltip_text="Submitted answer locked for this round."
		if not submission_notice.is_empty() and page=="report":report_status.text=submission_notice
	if not is_instance_valid(completion_prompt):return
	if review_model!=null:
		var p: Dictionary=review_model.performance()
		if session.session_complete():report_status.text+="\nReview: %d/%d reviewed | %d corrected | %d still incorrect | %d unreviewed" % [p.reviewed,p.total,p.corrected,p.still_incorrect,p.remaining]
	if session.session_complete() and session.pending.is_empty() and not animations_active() and not completion_prompted:
		completion_prompted=true;show_completion_prompt()
func show_completion_prompt() -> void:
	var score: Dictionary=session.metrics()
	completion_text.text="Learning session complete.\n%d incorrect questions.\nWould you like to review and retry the questions you missed?" % score.incorrect if score.incorrect>0 else "Congratulations!\nYou answered all 22 questions correctly.\nYour final results remain available in Report."
	review_button.visible=score.incorrect>0;finish_session_button.text="FINISH SESSION";completion_prompt.show()
func enter_review() -> void:
	if animations_active() or not session.pending.is_empty():return
	var model=session.start_review()
	if model==null:return
	review_model=model;completion_prompt.hide();close_page();martian.hide()
	review_panel=preload("res://script/missed_question_review_panel.gd").new();review_panel.configure(self,review_model)
func finish_review() -> void:
	if review_model==null:return
	if is_instance_valid(review_panel):review_panel.hide()
	var score: Dictionary=review_model.original_score;var p: Dictionary=review_model.performance()
	completion_text.text="Original score: %d correct / %d incorrect (%.0f%%)\nMissed questions reviewed: %d / %d\nCorrected during review: %d\nStill incorrect after review: %d\nUnreviewed: %d" % [score.correct,score.incorrect,score.percentage,p.reviewed,p.total,p.corrected,p.still_incorrect,p.remaining]
	review_button.hide();completion_prompt.show();refresh()
func restart_learning() -> void:
	if is_instance_valid(completion_prompt):completion_prompt.hide()
	if is_instance_valid(review_panel):review_panel.queue_free()
	review_model=null;completion_prompted=false;prepared_batch=-1;submission_notice="";super.restart_learning()

func build_learning_presentation() -> void:
	super.build_learning_presentation()
	orbital_canvas.remove_child(orbital_display);orbital_display.queue_free()
	orbital_display=preload("res://script/live_status_display.gd").new();orbital_canvas.add_child(orbital_display);orbital_display.configure(self)
func submit_report() -> void:
	if review_index>=0 or session.review_locked or animations_active():return
	session.advance(command.operations.session.now)
	var response: Dictionary=session.submit_answers(0)
	if not response.ok:
		submission_notice=response.error;clear_explanation();refresh();return
	submission_notice="";close_page();learning_context=true;update_learning_presentation();refresh()
func select_answer(id: int,defense: int) -> void:
	submission_notice="";super.select_answer(id,defense)

func round_status() -> String:
	return super.round_status().replace("Choose countermeasures, then D.","Choose all answers, then SUBMIT ANSWERS (now), or D for WAIT.")

func select_report_round(index: int) -> void:
	submission_notice="";super.select_report_round(index)
