extends "res://tests/prototype12_test.gd"
const CorrectSession=preload("res://script/correct_only_learning_session.gd")
func model_fixture(correct: int) -> RefCounted:
	var model=CorrectSession.new();model.configure(learning.loader);model.advance(100);model.analyze(learning.learning_rows())
	for i in range(learning.loader.questions.size()):
		var q: Dictionary=learning.loader.questions[i];model.select_answer(int(q.contact_id),int(q.correct_defense_id) if i<correct else int(q.options.filter(func(d):return d!=q.correct_defense_id)[0]))
	return model
func scheduling_checks() -> void:
	var empty=CorrectSession.new();empty.configure(learning.loader);empty.analyze(learning.learning_rows())
	check(not empty.request_fire(-1,0).ok and empty.pending.is_empty() and empty.results.is_empty() and empty.begin_due().is_empty(),"Unanswered questions neither queue, fire, nor grade")
	var lone=CorrectSession.new();lone.configure(learning.loader);lone.analyze(learning.learning_rows());var only: Dictionary=learning.loader.questions[0];lone.select_answer(int(only.contact_id),int(only.correct_defense_id));lone.request_fire(-1,0)
	check(lone.pending.shots.size()==1 and lone.results.is_empty(),"One correct selection queues one missile; four unanswered questions stay ungraded")
	var lone_shot: Dictionary=lone.begin_due();lone.claim_launch(lone_shot);lone.advance(36);lone.finish_shot(int(only.contact_id),lone.generation)
	check(lone.metrics().correct==1 and lone.metrics().incorrect==0 and lone.results.size()==1,"Only the fired correct answer grades at impact; unanswered rows remain untouched")
	var wrong=model_fixture(0);var state: int=wrong.evasion_rng.state
	check(wrong.request_fire(-1,0).ok and wrong.pending.is_empty() and wrong.begin_volley().is_empty(),"All incorrect selections create zero launch slots")
	check(wrong.metrics().incorrect==5 and wrong.metrics().correct==0 and wrong.results.values().all(func(r):return r.projectile_outcome=="NOT LAUNCHED"),"Incorrect answers recorded exactly once without pretending to physically miss")
	check(wrong.evade_all().is_empty() and wrong.evasion_rng.state==state and wrong.physical_targets.values().all(func(t):return t.alive),"Wrong answers cannot consume evasion RNG or remove targets")
	check(not wrong.request_fire(-1,0).ok and wrong.metrics().incorrect==5,"Repeated wrong firing does not regrade")
	for count in [1,3,5]:
		var model=model_fixture(count);var response: Dictionary=model.request_fire(-1,0)
		check(response.scheduled==count and response.incorrect==5-count,"Only correct answers occupy sorted launch slots")
		var ids: Array=model.pending.shots.map(func(s):return s.contact_id);var sorted_ids:=ids.duplicate();sorted_ids.sort();check(ids==sorted_ids,"Stable contact-ID scheduling order")
		var times: Array=[]
		for index in range(count):
			var due: float=100+index*15
			if index>0:model.advance(due-0.001);check(model.begin_due().is_empty(),"No launch before stagger boundary")
			else:check(model.countdown()==0,"First launch is eligible immediately")
			model.advance(due);var shots: Array=model.begin_volley();check(shots.size()==1,"Exactly one due projectile")
			if shots.is_empty():continue
			var shot: Dictionary=shots[0];times.append(shot.launched_at)
			check(model.claim_launch(shot) and not model.claim_launch(shot),"Launch authorization can be claimed once")
			check(model.begin_due().is_empty() and not model.request_fire(-1,0).ok,"No duplicate burst or second firing decision")
			check(model.finish_shot(shot.contact_id,model.generation).is_empty(),"Correct grading cannot precede 36-second impact")
		var expected_times: Array=[]
		for index in range(count):expected_times.append(100.0+index*15)
		check(times==expected_times,"Actual launch timing exactly 0/15/30/45/60 as applicable")
	for delay in [60,300,600]:
		var model=model_fixture(3);model.request_fire(-1,delay)
		check(model.countdown()==delay and model.pending.shots.size()==3,"WAIT applies before stagger, without short cuts")
		model.advance(100+delay-0.001);check(model.begin_due().is_empty(),"WAIT does not launch early")
		model.advance(100+delay);var shot: Dictionary=model.begin_due();check(shot.launched_at==100+delay and model.countdown()==15,"First WAIT launch begins 15-second spacing")
		check(model.cancel() and model.pending.is_empty() and model.flights.size()==1,"Cancel removes queued launches, never the airborne missile")
	var jump=model_fixture(5);jump.request_fire(-1,0);jump.begin_due();jump.advance(200);var overdue: Dictionary=jump.begin_due()
	check(overdue.launched_at==200 and jump.begin_due().is_empty() and jump.countdown()==15,"Long frame/clock jump cannot create a catch-up burst")
	var tamper=model_fixture(5);tamper.request_fire(-1,0);var first: Dictionary=tamper.pending.shots[0];var q: Dictionary=tamper.question(first.contact_id);first.defense_id=int(q.options.filter(func(d):return d!=q.correct_defense_id)[0])
	check(tamper.begin_due().is_empty() and tamper.flights.is_empty(),"Queue-drain authority revalidates defenses instead of trusting UI/snapshot flags")
	# Whole-session no-miss and all-miss fixtures test both completion branches without physical UI shortcuts.
	for correct in [true,false]:
		var all_model=CorrectSession.new();all_model.configure(learning.loader);all_model.analyze(learning.learning_rows())
		for round_number in range(5):
			for question in learning.loader.questions:all_model.select_answer(int(question.contact_id),int(question.correct_defense_id) if correct else int(question.options.filter(func(d):return d!=question.correct_defense_id)[0]))
			all_model.request_fire(-1,0)
			while not all_model.pending.is_empty():
				all_model.advance(maxf(all_model.now,float(all_model.pending.due_at)));var item: Dictionary=all_model.begin_due();check(all_model.claim_launch(item),"Valid correct-only fixture launch")
			var airborne: Array=all_model.flights.keys()
			all_model.advance(all_model.now+36)
			for id in airborne:all_model.finish_shot(id,all_model.generation)
			if round_number<4:check(all_model.advance_round(learning.learning_rows()),"Full-session model advances only processed rounds")
		check(all_model.all_results.size()==22 and all_model.session_complete(),"All 22 processed under either grading path")
		if correct:check(all_model.start_review()==null and all_model.metrics().incorrect==0,"Zero-missed session never constructs empty review")
		else:
			var original: Dictionary=all_model.all_results.duplicate(true);var score: Dictionary=all_model.metrics();var review=all_model.start_review()
			check(review.questions.size()==22 and not all_model.request_fire(-1,0).ok and all_model.begin_due().is_empty(),"All-missed review is noncombat and only original misses")
			for item in review.questions:review.evaluate(item.learning_id,int(item.correct_defense_id))
			all_model.advance(all_model.now+600);check(all_model.all_results==original and all_model.metrics()==score and review.performance().corrected==22,"Review and clock cannot rewrite original score/history")
	learning.loader.activate_round(0)
func run() -> void:
	learning=load("res://scene/correct_only_learning_command.tscn").instantiate();learning.session_seed=12345;game=learning;test_viewport.add_child(learning);await frames();command=learning.command;command.set_strategic_pause(true);pointer_at(Vector2(40,130));scheduling_checks()
	var official: Dictionary=command.mission.public_snapshot();var events: Array=command.operations.session.events();var canonical: Array=command.registry.contacts.keys()
	await open_report();choose(0);learning.close_page();var rng: int=learning.session.evasion_rng.state;learning.request_fire(0);await frames()
	check(learning.projectiles.is_empty() and learning.session.pending.is_empty() and learning.martian.records.is_empty() and not learning.martian.warning.visible and not learning.martian.alarm.playing,"All-wrong rendered firing produces no missiles, launch warning, or alarm")
	check(learning.session.metrics().incorrect==5 and learning.session.evasion_rng.state==rng,"Rendered wrong answers grade without any evasion trial")
	learning.restart_learning();await frames();choose(3);learning.request_fire(60);learning.show_page("report");await frames()
	check(learning.session.results.size()==2 and learning.session.pending.shots.size()==3 and learning.projectiles.is_empty(),"Mixed Report grades two misses and queues only three correct answers")
	var queued_copy: Dictionary=learning.session.pending.duplicate(true)
	learning.learning_center_select.select(5);learning.learning_center_select.item_selected.emit(5);await frames();check(learning.orbital_display.centers==["DC-06"] and learning.session.pending==queued_copy,"Orbital center switching during WAIT preserves the launch queue")
	await press(learning.overview_button);check(learning.orbital_display.centers.size()==6 and learning.session.pending==queued_copy,"Returning to six centers never resets queued launch times")
	await capture("p12_correct_mixed_report")
	var queued: int=learning.session.pending.shots[0].contact_id;var wrong_def: int=learning.session.question(queued).options.filter(func(d):return d!=learning.session.question(queued).correct_defense_id)[0]
	check(not learning.session.select_answer(queued,wrong_def) and learning.option_buttons[queued].all(func(b):return b.disabled),"Queued authorization snapshot is locked; cancellation required to edit")
	learning.session.cancel();learning.close_page();learning.request_fire(0);await frames()
	check(learning.projectiles.size()==1 and learning.session.pending.shots.size()==2 and learning.martian.incoming().size()==1,"First correct missile launches immediately")
	var start: float=learning.projectiles[0].fired_at;check(learning.projectiles[0].duration==36,"Flight duration remains 36 simulation seconds")
	await capture("p12_correct_first_launch");await press(learning.martian.evade_button)
	var before: Dictionary=learning.session.pending.duplicate(true);await create_timer(0.25).timeout;check(learning.projectiles.size()==1 and learning.session.pending==before,"Strategic pause holds the queue and current flight")
	learning.show_page("report");learning.close_page();check(learning.session.pending==before,"Report navigation preserves pending queue")
	await sim(14.999);check(learning.martian.incoming().size()==1,"No second launch before 15 seconds")
	await sim(0.001);check(learning.projectiles.size()==2 and absf(learning.projectiles[1].fired_at-start-15)<0.00000002,"Second actual launch exactly 15 seconds later")
	check(learning.martian.evade_button.disabled==false and not learning.session.flights[learning.projectiles[1].contact_id].get("evasion_attempted",false),"Later airborne projectile is eligible for a new EVADE ALL command")
	await capture("p12_correct_second_launch");await press(learning.martian.evade_button)
	await sim(15);check(learning.projectiles.size()==3 and absf(learning.projectiles[2].fired_at-start-30)<0.00000002 and learning.session.pending.is_empty(),"Third correct-only missile launches at 30 seconds")
	if learning.projectiles.size()!=3:quit(1);return
	await capture("p12_correct_overlapping");await press(learning.martian.evade_button)
	var launch_count: int=learning.projectiles.size();learning.launch(learning.session.flights.values()[0]);check(learning.projectiles.size()==launch_count,"Controller rejects duplicate launch calls")
	check(learning.session.results.size()==2 and learning.session.metrics().correct==0 and not learning.next_round_button.visible,"No early correct grading or NEXT while airborne")
	await sim(6);check(learning.session.metrics().correct==1,"First result at 36 seconds, independently of later launches");await sim(15);check(learning.session.metrics().correct==2,"Second result at 51 seconds");await sim(15);check(learning.session.results.size()==5 and learning.session.metrics().correct==3 and learning.session.metrics().incorrect==2,"Mixed sequence grades all five exactly once")
	check(not learning.next_round_button.visible and learning.animations_active(),"NEXT remains blocked through final impact effects")
	await sim(2);learning.show_page("report");await frames();check(learning.next_round_button.visible,"NEXT enabled after entire queue/flight/effects sequence")
	var missed_keys: Array=learning.session.results.values().filter(func(r):return not r.answer_correct).map(func(r):return r.physical_id)
	for key in missed_keys:check(learning.session.physical_targets[key].alive,"Wrong answer target remains physically alive")
	for round_index in range(1,5):
		await press(learning.next_round_button);choose(learning.loader.questions.size());learning.close_page();learning.request_fire(0);await frames()
		var fired: float=learning.projectiles[0].fired_at;var count: int=learning.loader.questions.size()
		for index in range(1,count):await sim(15)
		check(learning.session.pending.is_empty(),"Later-round launch queue drains with stagger, including DC-06")
		await sim(36);check(not learning.next_round_button.visible,"Final projectile effects still block NEXT")
		await sim(2);learning.show_page("report");await frames()
		for key in missed_keys:check(learning.session.physical_targets[key].alive,"Missed targets persist across all five rounds")
	check(learning.session.all_results.size()==22 and learning.session.metrics().correct==20 and learning.session.metrics().incorrect==2,"All 22 original outcomes retain 20/2 score")
	check(learning.completion_prompt.visible and learning.completion_text.text.contains("2 incorrect") and learning.review_button.visible,"Completion prompt appears once after all effects and includes missed count")
	learning.completion_prompt.hide();await capture("p12_correct_completed_session");learning.completion_prompt.show();await capture("p12_correct_review_prompt")
	var original_score: Dictionary=learning.session.metrics();var original_results: Dictionary=learning.session.all_results.duplicate(true);var history: Array=learning.session.round_history.duplicate(true);var physical: Dictionary=learning.session.physical_targets.duplicate(true);var evasion: int=learning.session.evasion_rng.state
	await press(learning.review_button);await frames();check(learning.review_model.questions.size()==2 and learning.review_panel.visible,"Review contains exactly the two missed questions")
	check(learning.review_panel.description.text.is_empty() and learning.review_panel.cells.values().all(func(c):return not c.tooltip_text.contains("Correct countermeasure")),"No review answer disclosure before selection")
	for item in learning.review_model.questions:
		var original: Dictionary=learning.loader.rounds[item.round_number-1].filter(func(source):return source.learning_id==item.learning_id)[0]
		check(item.options==original.options and item.attack_id==original.attack_id,"Review retains exact original attack and four answer choices")
	var q: Dictionary=learning.review_model.questions[0];var attack_control: Button=learning.review_panel.grid.get_child(10);await press(attack_control)
	check(learning.review_panel.description.get_theme_font_size("font_size")==34 and learning.review_panel.box.get_theme_stylebox("panel").border_width_left==3,"Review retains large red-bordered definitions")
	learning.review_panel.clear_description();await capture("p12_correct_review_screen")
	for i in range(2):
		q=learning.review_model.questions[i];var answer: int=int(q.correct_defense_id) if i==0 else int(q.options.filter(func(d):return d!=q.correct_defense_id)[0]);var index: int=q.options.find(answer)
		await press(learning.review_panel.buttons[q.learning_id][index]);check(learning.review_panel.description.text.contains("Correct countermeasure:"),"Review explains designated answer only after evaluation")
		check(learning.review_panel.description.text.contains(command.decision_pages.words(learning.review_model.defenses[int(q.correct_defense_id)].definition,23)),"Post-evaluation review teaches the designated defense purpose from the catalog")
	await capture("p12_correct_review_feedback")
	learning.request_fire(0);check(not learning.session.request_fire(-1,0).ok and learning.projectiles.is_empty() and learning.session.begin_volley().is_empty(),"Review cannot launch through controller or authoritative session")
	await sim(10)
	check(learning.session.all_results==original_results and learning.session.round_history==history and learning.session.metrics()==original_score,"Review preserves original score, elapsed time and historical answers")
	check(learning.session.physical_targets==physical and learning.session.evasion_rng.state==evasion and not learning.martian.alarm.playing,"Review cannot change physical targets, alarms or RNG")
	var performance: Dictionary=learning.review_model.performance();check(performance.reviewed==2 and performance.corrected==1 and performance.still_incorrect==1,"Review performance separately reports one corrected and one still incorrect")
	await press(learning.review_panel.finish_button);await capture("p12_correct_review_summary")
	check(learning.completion_text.text.contains("Original score: 20 correct / 2 incorrect") and learning.completion_text.text.contains("Corrected during review: 1"),"Final original/review summary is explicit")
	await press(learning.finish_session_button);await frames();check(not learning.completion_prompt.visible and learning.session.all_results==original_results,"FINISH SESSION retains results and does not reopen prompt")
	check(command.mission.public_snapshot()==official and command.operations.session.events()==events and command.registry.contacts.keys()==canonical,"Canonical P10 scores, events and contacts unchanged")
	await close_game();await zero_missed_ui();print("PROTOTYPE 12 CORRECT ONLY: ","PASS" if failures==0 else "FAIL"," (",failures," failures; ",checks," checks)");quit(0 if failures==0 else 1)

func zero_missed_ui() -> void:
	learning=load("res://scene/correct_only_learning_command.tscn").instantiate();learning.session_seed=12345;game=learning;test_viewport.add_child(learning);await frames();command=learning.command;command.set_strategic_pause(true);learning.analyze();learning.close_page()
	for round_number in range(5):
		choose(learning.loader.questions.size());learning.request_fire(0);await frames()
		for i in range(1,learning.loader.questions.size()):await sim(15)
		await sim(36);await sim(2)
		if round_number<4:learning.next_round();learning.close_page();await frames()
	check(learning.completion_prompt.visible and learning.completion_text.text.contains("Congratulations") and not learning.review_button.visible,"Zero-missed completion shows congratulations without empty review")
	var results: Dictionary=learning.session.all_results.duplicate(true);await press(learning.finish_session_button);await frames();check(learning.session.metrics().correct==22 and learning.session.all_results==results and not learning.completion_prompt.visible,"FINISH SESSION preserves a perfect original score")
	await close_game()
