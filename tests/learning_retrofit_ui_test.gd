extends "res://tests/prototype12_live_status_test.gd"
func run() -> void:
	learning=load("res://scene/learning_retrofit_command.tscn").instantiate();learning.session_seed=12345;game=learning;test_viewport.add_child(learning);await frames();command=learning.command;command.set_strategic_pause(true);pointer_at(Vector2(40,140))
	var official: Dictionary=command.mission.public_snapshot();var canonical_events: Array=command.operations.session.events();var actors: Array=command.registry.contacts.keys()
	check(learning.error.is_empty() and learning.loader.bank_size==100,"Main full-mode uses complete canonical retrofit")
	await press(learning.nav.analyze);await press(learning.yes_button);await capture("retrofit_report")
	check(learning.report_grid.get_global_rect().end.x<=1585,"Nine columns fit the full viewport")
	var q: Dictionary=learning.loader.questions[0];var id:=int(q.contact_id)
	learning.open_lesson(q);await frames();await capture("retrofit_question")
	var panel=learning.detail_panel;var lesson: Dictionary=learning.loader.rich_attacks[int(q.attack_id)]
	check(panel.prompt.text==lesson.question and panel.visible,"Actual authored scenario visible in full mode")
	check(panel.prompt.get_line_count()*panel.prompt.get_theme_font("font").get_height(22)<=panel.prompt.size.y,"Question wraps without clipping")
	check(panel.attack_body.text.contains(lesson.definition) and panel.attack_body.text.contains(lesson.example),"Full definition and distinct example remain untruncated")
	check(not panel.body.text.contains(lesson.explanation),"No designated answer reasoning before submission")
	var answer_index: int=q.options.find(int(q.correct_defense_id));panel.lesson_scroll.ensure_control_visible(panel.choices[answer_index]);await frames();await press(panel.choices[answer_index]);await frames();await capture("retrofit_defense")
	var defense: Dictionary=learning.loader.rich_defenses[int(q.correct_defense_id)]
	check(panel.body.text.contains(defense.definition) and panel.body.text.contains(defense.mechanism) and panel.body.text.contains(defense.conditions) and panel.body.text.contains(defense.limitations),"Full selected-defense teaching fields")
	check(learning.session.results.is_empty() and learning.session.pending.is_empty(),"Lesson selection does not grade or launch")
	panel.lesson_scroll.scroll_vertical=120;await frames();check(panel.lesson_scroll.scroll_vertical>=100,"Long learning details scroll and do not reset each refresh")
	var key:=InputEventKey.new();key.keycode=KEY_ESCAPE;key.pressed=true;test_viewport.push_input(key,true);await frames();check(not panel.visible,"Keyboard Escape closes lesson")
	# Full names and questions across every round; current UI remains a compact board plus separate lesson.
	for question in learning.loader.questions:
		var attack: Control=learning.report_grid.get_child(9+learning.report_order.find(question.learning_id)*9+2)
		check(attack.text==learning.loader.rich_attacks[int(question.attack_id)].display_name,"Board uses full attack display name")
		check(attack.get_line_count() if attack is Label else attack.custom_minimum_size.y>=80,"Rows reserve readable wrapped height")
	choose(2);panel.dismiss();await press(learning.submit_answers_button);await frames()
	check(learning.projectiles.size()==1 and learning.session.results.size()==3 and learning.session.pending.shots.size()==1,"Original correct-only staggered authority preserved")
	for result in learning.session.results.values():
		var status: String=learning.session.live_status(int(result.contact_id))
		check(status.begins_with("INCORRECT ANSWER") and not status.contains("MISSILE LAUNCHED"),"Incorrect wording has no contradictory launch")
	var p=learning.projectiles[0];var first:=int(p.contact_id);var key_physical: String=learning.session.flights[first].physical_id
	var seed_value:=-1
	for candidate in range(100):
		var random:=RandomNumberGenerator.new();random.seed=candidate
		if random.randf()<0.5 and random.randf()>=0.5:seed_value=candidate;break
	learning.session.evasion_rng.seed=seed_value
	await sim(10);await press(learning.martian.evade_button)
	var direction: Vector2=learning.orbital_display.pursuits[first].direction;var previous: Vector2=learning.orbital_display.markers[first].position
	for i in range(10):
		await sim(0.25);var current: Vector2=learning.orbital_display.markers[first].position
		check(current.distance_to(previous)<18,"Smooth threat travel without teleport")
		check(absf((current-previous).cross(direction))<0.01,"Directional movement replaces chaotic zigzag")
		previous=current
	await capture("retrofit_pursuit")
	check(p.samples.size()>2 and p.head.distance_to(p.origin)>20,"Visible fast-closing projectile and fading trail")
	await sim(2.5);check(learning.projectiles.size()==2,"Second actual launch still 15 seconds later")
	var second=learning.projectiles[1];await press(learning.martian.evade_button)
	check(learning.session.flights[first].evasion_success and not learning.session.flights[second.contact_id].evasion_success,"Independent controlled success/failure for presentation test")
	await sim(18.5);check(learning.orbital_display.markers[first].visible,"Escaping target remains observable through most of pursuit")
	await capture("retrofit_escape")
	await sim(2.5)
	check(learning.session.results[first].projectile_outcome=="EVADED" and learning.session.physical_targets[key_physical].alive,"Escape depicts authoritative survival without changing answer grade")
	check(not learning.orbital_display.markers[first].visible and learning.session.metrics().correct==1,"Survivor exits its own display; correctness remains correct")
	await sim(15)
	check(learning.session.results[second.contact_id].projectile_outcome=="HIT" and second.head.is_equal_approx(second.target_at_impact),"Successful pursuit reaches target before disabling")
	check(learning.session.live_status(second.contact_id).ends_with("THREAT DISABLED"),"Confirmed hit wording")
	await capture("retrofit_hit");await sim(2);learning.show_page("report");learning.open_lesson(q);await frames();await capture("retrofit_reasoning")
	check(panel.body.text.contains(lesson.explanation) and panel.body.text.contains(lesson.distractor_reasoning),"Full post-submission reasoning and option contrast")
	panel.lesson_scroll.scroll_vertical=int(panel.lesson_scroll.get_v_scroll_bar().max_value);await frames();await capture("retrofit_reasoning_scrolled")
	panel.dismiss();check(learning.next_round_button.visible,"NEXT waits for all effects")
	for round_number in range(1,5):
		learning.next_round();await frames();choose(learning.loader.questions.size());panel.dismiss();learning.close_page();learning.request_fire(0);await frames()
		for i in range(1,learning.loader.questions.size()):await sim(15)
		await sim(36);await sim(2)
	check(learning.session.all_results.size()==22 and learning.session.metrics().correct==19 and learning.session.metrics().incorrect==3,"Five rounds and original cumulative grading preserved")
	learning.enter_review();await frames();check(learning.review_model.questions.size()==3,"Missed review uses retrofit questions only")
	var review_q: Dictionary=learning.review_model.questions[0];learning.detail_panel.open_question(review_q,false,true);await frames();await capture("retrofit_review")
	var original: Dictionary=learning.session.all_results.duplicate(true);var rng_state: int=learning.session.evasion_rng.state
	panel.lesson_scroll.ensure_control_visible(panel.choices[review_q.options.find(int(review_q.correct_defense_id))]);await frames();await press(panel.choices[review_q.options.find(int(review_q.correct_defense_id))]);await frames()
	await capture("retrofit_review_after")
	check(panel.body.text.contains(learning.loader.rich_attacks[int(review_q.attack_id)].explanation),"Rich review reveals full answer reasoning only after review choice")
	check(learning.projectiles.is_empty() and learning.session.all_results==original and learning.session.evasion_rng.state==rng_state,"Review remains noncombat and cannot change original score/history/RNG")
	check(command.mission.public_snapshot()==official and command.operations.session.events()==canonical_events and command.registry.contacts.keys()==actors,"Accepted canonical scoring, ledger and actors unchanged")
	await close_game();print("LEARNING RETROFIT UI: ","PASS" if failures==0 else "FAIL"," (",failures," failures; ",checks," checks)");quit(0 if failures==0 else 1)
