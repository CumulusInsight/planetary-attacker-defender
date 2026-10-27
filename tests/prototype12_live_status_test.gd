extends "res://tests/prototype12_correct_only_test.gd"
func run() -> void:
	learning=load("res://scene/correct_only_learning_command.tscn").instantiate();learning.session_seed=12345;game=learning;test_viewport.add_child(learning);await frames();command=learning.command;command.set_strategic_pause(true);pointer_at(Vector2(40,140))
	var official: Dictionary=command.mission.public_snapshot();var events: Array=command.operations.session.events()
	await press(learning.nav.analyze);await press(learning.yes_button)
	check(learning.closes.report.text=="CLOSE" and learning.submit_answers_button.text=="SUBMIT ANSWERS","Separate Report actions")
	check(learning.closes.report.get_global_rect().end.x<learning.submit_answers_button.get_global_rect().position.x,"Header controls do not overlap")
	await capture("p12_live_report_controls")
	await press(learning.submit_answers_button)
	check(learning.page=="report" and learning.submission_notice.contains("C-") and learning.session.pending.is_empty() and learning.session.results.is_empty(),"Incomplete submission names missing contacts and remains open without grading")
	var q: Dictionary=learning.loader.questions[0];var id: int=q.contact_id;learning.select_answer(id,int(q.correct_defense_id));var answers: Dictionary=learning.session.answers.duplicate(true)
	await press(learning.closes.report);await frames()
	check(learning.session.answers==answers and learning.session.pending.is_empty() and learning.session.results.is_empty() and learning.martian.incoming().is_empty(),"CLOSE preserves unsent answer without firing or warning")
	await press(learning.nav.report);check(learning.session.answers==answers,"R preserves selections")
	choose(3);await press(learning.submit_answers_button);await frames()
	check(learning.page=="" and learning.session.results.size()==2 and learning.projectiles.size()==1 and learning.session.pending.shots.size()==2,"Submit mixed selections uses correct-only authority and returns to orbital view")
	var first: int=learning.projectiles[0].contact_id
	check(learning.session.live_status(first)=="CORRECT ANSWER — MISSILE LAUNCHED","Actual launch status")
	for r in learning.session.results.values():check(learning.session.live_status(int(r.contact_id))=="ANSWER INCORRECT — MISSILE NOT LAUNCHED","Incorrect status without physical launch")
	var queued: int=learning.session.pending.shots[0].contact_id
	check(learning.session.live_status(queued)=="CORRECT ANSWER — MISSILE PENDING LAUNCH","Queued correct status")
	await capture("p12_live_mixed_launch")
	for center_id in learning.orbital_display.centers:
		var text: Label=learning.orbital_display.status_labels[center_id]
		check(text.get_line_count()*text.get_theme_font("font").get_height(14)<=text.size.y,"Six-center status wraps within its band")
		check(text.position.y>=learning.orbital_display.tiles[center_id].end.y,"Status is beneath orbital area")
	var snapshot: Dictionary=learning.session.pending.duplicate(true);learning.show_page("report");await frames()
	check(learning.submit_answers_button.disabled and learning.option_buttons[queued].all(func(b):return b.disabled),"Already submitted answers cannot be edited or resubmitted")
	var old_answer: int=learning.session.answers[queued];check(not learning.session.select_answer(queued,int(learning.session.question(queued).options.filter(func(d):return d!=old_answer)[0])),"Authoritative submission lock")
	check(not learning.session.submit_answers().ok,"Duplicate submission rejected")
	await press(learning.closes.report);check(learning.session.pending==snapshot,"CLOSE leaves active queue unchanged")
	await sim(14.999);check(learning.projectiles.size()==1,"No early stagger launch")
	await sim(0.001);check(learning.projectiles.size()==2,"Second launch at 15 seconds")
	await sim(15);check(learning.projectiles.size()==3 and learning.session.pending.is_empty(),"Third launch at 30 seconds")
	# One finalized evasion and two hits; ordering cannot reveal final status early.
	var evade_id: int=learning.projectiles[2].contact_id
	learning.session.evasion_rng.seed=1
	var evasion: Array=learning.session.evade_all()
	# Select a successful deterministic roll by a local controlled fixture if necessary.
	for p in learning.projectiles:
		if evasion.has(int(p.contact_id)):p.order_evasion(learning.session.now,learning.session.flights[int(p.contact_id)].evasion_success)
	var still_airborne: int=learning.projectiles[2].contact_id
	check(learning.session.live_status(still_airborne)=="CORRECT ANSWER — MISSILE LAUNCHED","No final evasion outcome before callback")
	await sim(5.999);check(not learning.session.results.has(first),"36-second flight not shortened")
	await sim(0.001)
	var first_result: Dictionary=learning.session.results[first]
	check(learning.session.live_status(first).contains("THREAT EVADED MISSILE") if first_result.projectile_outcome=="EVADED" else learning.session.live_status(first).contains("THREAT DISABLED"),"Final status follows authoritative callback")
	await sim(30);await sim(2)
	check(learning.session.results.values().any(func(r):return r.get("projectile_outcome","")=="HIT") and learning.session.results.values().any(func(r):return r.get("projectile_outcome","")=="EVADED"),"Rendered fixture includes confirmed HIT and EVADED")
	for row in learning.loader.questions:
		var result: Dictionary=learning.session.results[int(row.contact_id)]
		if result.answer_correct:check(learning.session.live_status(int(row.contact_id)).ends_with("THREAT EVADED MISSILE" if result.projectile_outcome=="EVADED" else "THREAT DISABLED"),"Final physical outcome displayed per contact")
	await capture("p12_live_final_six")
	for kind in ["HIT","EVADED","NOT LAUNCHED"]:
		var outcome: Dictionary=learning.session.results.values().filter(func(r):return r.projectile_outcome==kind)[0]
		learning.apply_single_view(outcome.center_id);await frames();await capture("p12_live_"+kind.to_lower().replace(" ","_"))
	learning.apply_single_view(learning.learning_contacts[first].center_id);await frames();await capture("p12_live_enlarged")
	check(learning.orbital_display.status_labels[learning.learning_contacts[first].center_id].get_theme_font_size("font_size")==18,"Enlarged full wording readable")
	# Multiple rows in one center use independent question identities, no last-result overwrite.
	var center: String=learning.loader.questions[0].center_id;var other: Dictionary=learning.loader.questions[1];var old_center: String=other.center_id;other.center_id=center
	learning.orbital_display.layout_centers([center]);learning.orbital_display.sync(true)
	var body: String=learning.orbital_display.status_labels[center].text
	check(body.contains("C-%03d" % learning.loader.questions[0].contact_id) and body.contains("C-%03d" % other.contact_id),"Same-center targets retain separate status lines")
	other.center_id=old_center
	for centers in [["DC-01","DC-02"],["DC-01","DC-02","DC-03"]]:
		learning.orbital_display.layout_centers(centers);learning.orbital_display.sync(true)
		for c in centers:check(learning.orbital_display.status_areas[c].end.y<learning.reset_view_button.position.y,"Two/three-center statuses leave manual reset accessible")
	learning.show_page("report");await frames();check(not learning.submit_answers_button.visible and learning.next_round_button.visible,"Completed round hides Submit; NEXT preserved")
	await press(learning.next_round_button);learning.select_report_round(1);await frames()
	check(learning.review_index>=0 and not learning.submit_answers_button.visible,"Historical Report read only")
	var saved: Dictionary=learning.session.all_results.duplicate(true);learning.submit_report();check(learning.session.all_results==saved and learning.session.pending.is_empty(),"Historical submit cannot fire")
	learning.select_report_round(0);choose(5);learning.close_page();learning.request_fire(60);await frames()
	check(learning.projectiles.is_empty() and is_equal_approx(float(learning.session.countdown()),60.0),"D WAIT retains authorized delay")
	for question in learning.loader.questions:check(learning.session.live_status(int(question.contact_id)).ends_with("PENDING LAUNCH"),"WAIT status remains pending")
	learning.apply_single_view(learning.loader.questions[0].center_id);await frames();await capture("p12_live_wait_pending");learning.show_page("report");await press(learning.closes.report);await sim(59);check(learning.projectiles.is_empty(),"Report CLOSE does not accelerate WAIT")
	await sim(1);check(learning.projectiles.size()==1,"WAIT launch at exact delay");await capture("p12_live_wait_launched")
	check(command.mission.public_snapshot()==official and command.operations.session.events()==events,"Original operational state unchanged")
	await close_game();await submission_models();await fractional_boundaries();print("PROTOTYPE 12 LIVE STATUS: ","PASS" if failures==0 else "FAIL"," (",failures," failures; ",checks," checks)");quit(0 if failures==0 else 1)

func submission_models() -> void:
	# Detached models use the same validated source and launch authority.
	learning=load("res://scene/correct_only_learning_command.tscn").instantiate();learning.session_seed=12345;game=learning;test_viewport.add_child(learning);await frames();command=learning.command;command.set_strategic_pause(true);learning.analyze();learning.close_page();learning.set_process(false)
	for delay in [0,60,300,600]:
		var model=model_fixture(3);var response: Dictionary=model.submit_answers(delay)
		check(response.ok and response.scheduled==3 and response.incorrect==2,"Submission reuses mixed grading authority")
		check(model.countdown()==delay and model.pending.shots.size()==3,"Submission preserves each supported WAIT")
		check(not model.submit_answers(delay).ok,"Repeated Report submission rejected")
		var q: Dictionary=model.loader.questions[0];check(not model.select_answer(int(q.contact_id),int(q.options[0])),"Accepted selection locked in session")
		var id: int=model.pending.shots[0].contact_id
		check(model.live_status(id).ends_with("PENDING LAUNCH"),"WAIT state projects pending without launch")
		model.advance(model.now+delay);var shot: Dictionary=model.begin_due();model.claim_launch(shot)
		check(model.live_status(id)=="CORRECT ANSWER \u2014 MISSILE LAUNCHED","Claimed shot only reports launched")
		model.flights[id].evasion_success=true;model.flights[id].evaded=true
		check(not model.live_status(id).contains("THREAT"),"No early final physical outcome")
		model.advance(model.now+36);model.finish_shot(id,model.generation)
	var model=model_fixture(0);var rng: int=model.evasion_rng.state;var response: Dictionary=model.submit_answers()
	check(response.ok and model.pending.is_empty() and model.metrics().incorrect==5 and model.evasion_rng.state==rng,"All-wrong submit creates no missiles or RNG draws")
	for round_number in range(1,5):
		check(model.advance_round(learning.learning_rows()),"Submission fixtures preserve NEXT progression")
		for question in model.loader.questions:model.select_answer(int(question.contact_id),int(question.options.filter(func(d):return d!=question.correct_defense_id)[0]))
		model.submit_answers()
	var original: Dictionary=model.all_results.duplicate(true);var before_rng: int=model.evasion_rng.state;var review=model.start_review()
	check(review!=null and not model.submit_answers().ok and model.pending.is_empty() and model.flights.is_empty(),"Review cannot submit physical missiles")
	check(model.all_results==original and model.evasion_rng.state==before_rng,"Review submit cannot change original history or RNG")
	await close_game()

func fractional_boundaries() -> void:
	var target:=Node2D.new();test_viewport.add_child(target);target.position=Vector2(400,300)
	for frame in range(60):
		var p=preload("res://script/correct_only_projectile.gd").new();test_viewport.add_child(p)
		var fired: float=30.0+float(frame)/60.0
		p.setup(target,Vector2(100,100),fired,{"hit":true,"contact_id":8,"generation":0})
		p.step(fired+35.999);check(not p.impacted_already,"Fractional-clock flight cannot impact early")
		p.step(fired+36.0);check(p.impacted_already and p.duration==36.0,"36-second boundary works across every fractional start phase")
		p.queue_free()
	target.queue_free();await frames()
