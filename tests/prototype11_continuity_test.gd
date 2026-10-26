extends "res://tests/prototype11_multicenter_test.gd"
func choose_round(correct_count: int) -> void:
	var i:=0
	for q in learning.loader.questions:
		var answer: int=q.correct_defense_id if i<correct_count else q.options.filter(func(d):return d!=q.correct_defense_id)[0]
		await press(learning.option_buttons[int(q.contact_id)][q.options.map(func(d):return int(d)).find(answer)]);i+=1
func select_history(index: int) -> void:
	learning.round_control.select(index);learning.round_control.item_selected.emit(index);await frames()
func model_continuity() -> void:
	var bank_loader=preload("res://script/learning_question_loader.gd").new();bank_loader.load_questions(command.decision_pages.model);bank_loader.prepare_session(command.decision_pages.model,54321,1)
	check(bank_loader.rounds.map(func(r):return r.size())==[5,5,2],"Seeded bank plan is exactly five/five/two")
	var again=preload("res://script/learning_question_loader.gd").new();again.load_questions(command.decision_pages.model);again.prepare_session(command.decision_pages.model,54321,1)
	check(again.rounds==bank_loader.rounds,"Full round plan reproducible from seed")
	var s=Session.new();s.configure(bank_loader);s.advance(100);s.analyze(command.registry.public_rows())
	var used:={};var used_contacts:={};var reused:=false;var original_record: Dictionary={};var original_key:="";var previous_token:=-1
	for round_number in range(3):
		check(s.loader.questions.size()==[5,5,2][round_number],"Correct current round size")
		check(not s.advance_round(command.registry.public_rows()),"Cannot advance an unfinished round")
		for q in s.loader.questions:
			check(not used.has(q.question_id),"No repeated attack templates while unused questions remain");used[q.question_id]=true
			if used_contacts.has(int(q.contact_id)):reused=true
			used_contacts[int(q.contact_id)]=true
			s.select_answer(q.contact_id,q.correct_defense_id)
		s.request_fire(s.focused,0);var shots: Array=s.begin_volley()
		if previous_token>=0:check(s.finish_shot(shots[0].contact_id,previous_token).is_empty(),"Stale prior-round callback cannot resolve reused contact")
		for shot in shots:
			var result: Dictionary=s.finish_shot(shot.contact_id,s.generation)
			check(result.learning_id.begins_with("R%02d/" % [round_number+1]),"Per-question identity includes round, independent of contact reuse")
			check(s.finish_shot(shot.contact_id,s.generation).is_empty(),"Duplicate completion never adds cumulative score")
		check(s.metrics().correct==[5,10,12][round_number] and s.metrics().percentage==100,"Cumulative score preserves previous rounds")
		if round_number==0:original_key=s.all_results.keys()[0];original_record=s.all_results[original_key].duplicate(true)
		check(s.all_results[original_key]==original_record,"Reused contact cannot overwrite prior learning result")
		s.advance(s.now+2)
		if round_number<2:
			var elapsed: float=s.metrics().elapsed
			previous_token=s.generation
			check(s.advance_round(command.registry.public_rows()),"Only completed round advances")
			check(s.metrics().elapsed==elapsed and s.results.is_empty() and s.answers.is_empty(),"Round transition keeps cumulative time but clears only current selections/results")
			check(s.public_rows(0).all(func(r):return r.answered),"Archived round remains complete and reviewable")
		else:check(s.session_complete() and not s.has_next_round() and not s.advance_round(command.registry.public_rows()),"Bank exhausted; no silent repeat or fourth round")
	check(used.size()==12 and reused and s.all_results.size()==12,"All twelve unique questions survive deliberate contact-slot reuse")
	check(s.round_history.size()==2 and s.metrics().elapsed==6,"Previous rounds and cumulative elapsed time retained")
	s.reset();check(s.round_index==0 and s.all_results.is_empty() and s.round_history.is_empty() and s.metrics().correct==0,"Explicit restart resets complete learning session only")
func run() -> void:
	learning=load("res://scene/learning_command.tscn").instantiate();learning.session_seed=12345;game=learning;test_viewport.add_child(learning);await frames();command=learning.command;command.set_strategic_pause(true);pointer_at(Vector2(40,140));await frames()
	model_continuity()
	var official: Dictionary=command.mission.public_snapshot();var events: Array=command.operations.session.events();var cyber: Dictionary=command.cyber.session.public_view(10)
	check(learning.nav.size()==3 and learning.nav.analyze.text=="A" and learning.nav.report.text=="R" and learning.nav.decide.text=="D","Only A, R and D learning navigation; original P10 controls retained")
	check(command.decision_pages.top_buttons.keys()==["overview","contacts","threat","intelligence","history","mission","alerts"],"P10 taskbar order unchanged")
	await capture("p11_continuity_taskbar")
	await press(learning.nav.analyze);await capture("p11_continuity_analyze");await press(learning.no_button)
	check(not learning.session.analyzed and not learning.windows.report.visible,"A-R NO performs no analysis and opens no Report")
	await press(learning.nav.analyze);await press(learning.closes.analyze)
	check(not learning.session.analyzed and learning.page.is_empty(),"A-R CLOSE performs no analysis")
	await press(learning.nav.analyze);await press(learning.yes_button)
	check(learning.page=="report" and not learning.windows.analyze.visible and learning.session.analyzed,"A-R YES automatically opens Report and closes question")
	check(learning.report_grid.columns==9 and learning.report_grid.get_child(8).text=="RESULT" and learning.report_grid.get_global_rect().end.x<1580,"All nine Report columns fit at target resolution")
	check(learning.loader.questions.size()==5 and learning.round_control.item_count==1,"First round has five; no fictitious history")
	for row in range(5):
		for column in range(3):
			var field: Label=learning.report_grid.get_child(9+(row*9)+column)
			check(field.get_theme_font("font").get_string_size(field.text,HORIZONTAL_ALIGNMENT_LEFT,-1,field.get_theme_font_size("font_size")).x<=field.size.x,"Report center/contact/attack text fits its own column")
	await press(learning.reset_view_button);check(learning.orbital_display.centers==["DC-01"],"Unspecified RESET VIEW defaults to DC01")
	for cell in learning.result_cells.values():check(cell.text=="NOT ANSWERED" and not cell.tooltip_text.contains("Correct countermeasure"),"No answer key before choosing/firing")
	await choose_round(3)
	var answers: Dictionary=learning.session.answers.duplicate(true);var budgets: Dictionary=learning.session.learning_deadlines.duplicate(true)
	for row in learning.session.public_rows():
		check(learning.result_cells[row.contact_id].text=="SELECTED","Selections show SELECTED without correctness")
		var index: int=row.choices.map(func(d):return d.id).find(row.selected)
		check(learning.option_buttons[row.contact_id][index].get_node("SelectedUnderline").visible,"Selected countermeasure visibly underlined before firing")
		check(not learning.result_cells[row.contact_id].tooltip_text.contains("Correct countermeasure"),"Selected result cells do not disclose key")
	await capture("p11_continuity_selected")
	await open_report();check(learning.session.answers==answers and learning.session.learning_deadlines==budgets,"A-R reopen preserves answers and deadlines")
	# Manual reset is presentation only.
	check(not learning.reset_view_button.visible,"Reset hidden in existing single-center view")
	check(learning.view_mode=="single" and learning.orbital_display.centers.size()==1,"RESET VIEW makes one large center")
	check(learning.session.answers==answers and learning.session.learning_deadlines==budgets and learning.session.metrics().correct==0,"Reset does not alter answers/timers/score")
	var selector=command.decision_pages.center_control;selector.select(2);selector.item_selected.emit(2);await frames()
	check(learning.orbital_display.centers==["DC-03"] and learning.explicit_center=="DC-03","Existing dropdown selects exact large learning center")
	await press(learning.nav.decide);command.set_learning_mode(false);await press(learning.fire_buttons[0]);await create_timer(0.15).timeout
	check(learning.projectiles.size()==5 and learning.orbital_display.centers.size()==3,"Later volley restores all three firing displays from single view")
	check(learning.session.all_results.is_empty(),"No score before flight impacts")
	await capture("p11_continuity_multifire")
	await press(learning.reset_view_button)
	check(learning.orbital_display.centers.size()==3 and learning.queued_reset_center=="DC-03","Manual reset during flight queues without interrupting targets")
	await create_timer(3.05).timeout;await frames()
	check(learning.session.round_complete() and learning.session.metrics().correct==3 and learning.session.metrics().incorrect==2,"First mixed volley evaluates five independently")
	check(learning.orbital_display.centers.size()==3 and learning.animations_active(),"No automatic reset until impact animations finish")
	# Existing Decide -> Open Report reviews current results without advancing the bank.
	await press(learning.nav.decide);await press(learning.open_report)
	check(learning.session.round_index==0 and learning.page=="report","Current results remain reviewable before next-round analysis")
	check(not learning.toast.visible,"Report result cells remain unobstructed by floating feedback")
	for row in learning.session.public_rows():
		var result: Dictionary=row.result;var index: int=row.choices.map(func(d):return d.id).find(result.answer)
		check(learning.result_cells[row.contact_id].text==("CORRECT" if result.hit else "INCORRECT"),"Each evaluated Report row shows the actual outcome")
		check(learning.option_buttons[row.contact_id][index].button_pressed and learning.option_buttons[row.contact_id][index].get_node("SelectedUnderline").visible,"Actual fired defense remains selected and underlined")
		check(learning.result_cells[row.contact_id].get_theme_color("font_color")==Color("9de3ac" if result.hit else "ff9898"),"Green correct/red incorrect with readable text")
		check(learning.result_cells[row.contact_id].tooltip_text=="Correct countermeasure: "+result.correct_name,"Correct answer discoverable only after evaluation")
	var wrong: int=learning.session.results.keys().filter(func(id):return not learning.session.results[id].hit)[0]
	pointer_at(learning.result_cells[wrong].get_global_rect().get_center());await frames();check(learning.hover_explanation.text.contains(learning.session.results[wrong].correct_name),"Result hover reveals missed answer using existing explanation area")
	await capture("p11_continuity_results")
	await create_timer(1.9).timeout;learning.close_page();await frames()
	check(learning.orbital_display.centers==["DC-03"] and not learning.animations_active(),"Requested manual reset occurs after complete flight/effect sequence")
	check(learning.toast_label.text.contains("Next round available") and learning.session.all_results.size()==5,"Feedback and next-round notice survive reset")
	await capture("p11_continuity_single_reset")
	var first_results: Dictionary=learning.session.all_results.duplicate(true);var before_time: float=learning.session.metrics().elapsed
	await open_report()
	check(learning.session.round_index==1 and learning.loader.questions.size()==5 and learning.session.all_results==first_results,"A-R YES loads five different second-round questions and preserves results")
	check(learning.session.metrics().elapsed>=before_time and learning.session.metrics().correct==3,"Elapsed time and score cumulative across round transition")
	check(learning.round_control.item_count==2 and learning.session.round_history.size()==1,"Compact historical selector exposes previous completed round")
	var first_ids: Array=learning.session.round_history[0].questions.map(func(q):return q.question_id)
	check(learning.loader.questions.all(func(q):return q.question_id not in first_ids),"Second round excludes every completed template")
	await capture("p11_continuity_round2")
	await select_history(1)
	check(learning.review_index==0 and learning.session.round_index==1,"Historical selection does not change active round")
	for row in learning.session.public_rows(0):
		check(row.answered and learning.option_buttons[row.contact_id].all(func(b):return b.disabled),"Historical defenses cannot be edited")
		check(learning.time_labels[row.contact_id].text==row.recorded_time,"Historical deadline value is a recorded snapshot, not another contact's current timer")
	var new_answers: Dictionary=learning.session.answers.duplicate(true)
	learning.select_answer(int(learning.session.public_rows(0)[0].contact_id),138);learning.request_fire(0)
	check(learning.session.answers==new_answers and learning.session.pending.is_empty(),"History cannot select or schedule the reused current slot")
	await capture("p11_continuity_history")
	await select_history(0);await choose_round(4);await press(learning.nav.decide)
	command.set_learning_mode(true);command.set_strategic_pause(true);await press(learning.fire_buttons[60]);var countdown: float=learning.session.countdown();await frames(8)
	check(learning.session.pending.shots.size()==5 and learning.session.countdown()==countdown and learning.session.pending.shots.all(func(s):return s.learning_id.begins_with("R02/")),"Scheduled second-round volley remains immutable and paused")
	await press(learning.cancel_button);check(learning.session.pending.is_empty() and learning.session.all_results.size()==5,"Cancelling schedule adds no results")
	command.set_learning_mode(false);await press(learning.fire_buttons[0]);await create_timer(5.8).timeout;await frames()
	check(learning.session.metrics().correct==7 and learning.session.metrics().incorrect==3 and learning.session.all_results.size()==10,"Second volley accumulates score without overwriting first round")
	for key in first_results:check(learning.session.all_results[key]==first_results[key],"First-round result survives contact reuse unchanged")
	await open_report();check(learning.session.round_index==2 and learning.loader.questions.size()==2,"Final round contains remaining two questions")
	check(learning.round_control.item_count==3,"Both completed rounds available in same Report")
	await choose_round(1);await press(learning.nav.decide);await press(learning.fire_buttons[0]);await create_timer(5.8).timeout;await frames()
	check(learning.session.session_complete() and learning.session.all_results.size()==12 and learning.session.metrics().correct==8 and learning.session.metrics().incorrect==4,"All twelve questions evaluated exactly once with cumulative totals")
	check(is_equal_approx(learning.session.metrics().percentage,100.0*8/12) and learning.toast_label.text.contains("Session complete"),"Final score and session-complete message shown")
	await open_report();check(learning.session.round_index==2 and learning.session.all_results.size()==12,"A-R at completion reopens final results without a silent new session")
	await capture("p11_continuity_session_complete")
	check(command.mission.public_snapshot()==official and command.operations.session.events()==events and command.cyber.session.public_view(10)==cyber,"All round/view/learning actions preserve P10 scoring, ledger and evaluator")
	command.set_learning_mode(true);command.set_strategic_pause(true);await press(learning.restart_button)
	check(learning.session.round_index==0 and learning.loader.questions.size()==5 and learning.session.all_results.is_empty() and learning.session.round_history.is_empty(),"Existing Restart returns to round one and clears all session history deliberately")
	check(learning.session.metrics()=={"correct":0,"incorrect":0,"percentage":0.0,"elapsed":0.0} and learning.round_control.item_count==1,"Restart resets cumulative metrics and historical selector")
	check(learning.result_cells.values().all(func(c):return c.text=="NOT ANSWERED"),"Restart cannot retain old grading on reused slots")
	await press(command.decision_pages.top_buttons.threat);selector.select(1);selector.item_selected.emit(1);await frames()
	check(not learning.orbital_canvas.visible and command.focused_center=="DC-02" and selector.get_item_text(selector.selected)=="DC-02","Existing dropdown keeps original P10 behavior outside learning mode")
	await close_game()
	print("PROTOTYPE 11 GAMEPLAY CONTINUITY: ","PASS" if failures==0 else "FAIL"," (",failures," failures; ",checks," checks)")
	quit(0 if failures==0 else 1)
