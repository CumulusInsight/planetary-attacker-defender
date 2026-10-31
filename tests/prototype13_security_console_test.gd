extends "res://tests/prototype12_live_status_test.gd"
func state() -> String:
	return JSON.stringify([learning.session.answers,learning.session.results,learning.session.internal_threats,learning.session.physical_targets,learning.session.pending,learning.session.firing_mode,learning.session.now,learning.session.round_index,command.mission.public_snapshot(),command.operations.session.events(),learning.war_room.planned_attacks,learning.learning_selected,learning.explicit_center])
func next_combat_round() -> void:
	for question in learning.loader.questions:
		if not learning.session.results.has(int(question.contact_id)):
			learning.select_answer(question.contact_id,question.options.filter(func(d):return d!=question.correct_defense_id)[0])
	await press(learning.nav.report);await press(learning.submit_answers_button);await frames()
	learning.next_round();await frames();await press(learning.closes.report);await frames()
func run() -> void:
	learning=load("res://scene/prototype13_command.tscn").instantiate();learning.session_seed=12345;game=learning;test_viewport.add_child(learning);await frames();command=learning.command;command.set_strategic_pause(true)
	var official: Dictionary=command.mission.public_snapshot();var ledger: Array=command.operations.session.events()
	await press(learning.nav.analyze);await press(learning.yes_button);await press(learning.closes.report);await frames()
	var console: Control=learning.security_console
	check(learning.group_ui.tile_links["DC-01"].visible,"DC-01 entry available without replacing six centers")
	var before:=state();await press(learning.group_ui.inspector_button)
	check(console.visible and console.count_label.text=="No internal threats recorded.","Opens DC-01 with live zero state")
	check(console.background.texture.resource_path=="res://images/space.jpg" and console.defend_button.disabled,"Original supplied background and unavailable defense")
	await capture("p13_console_zero")
	await press(console.back_button);check(state()==before,"Return preserves clock, answers, score, records and queue")
	var q: Dictionary=learning.loader.questions[0];check(q.center_id=="DC-01","Deterministic DC-01 encounter")
	learning.select_answer(q.contact_id,q.options.filter(func(d):return d!=q.correct_defense_id)[0]);await press(learning.nav.report);await press(learning.submit_answers_button);await frames()
	await press(learning.group_ui.inspector_button)
	var rows: Array=learning.session.internal_for_center("DC-01")
	check(rows.size()==1 and console.incident_buttons.size()==1,"Real incorrect submission produces one incident")
	check(console.detail.text.contains("Threat entered without interception.") and console.detail.text.contains(rows[0].physical_id) and console.detail.text.contains("NOT CONFIRMED"),"Authoritative identity, cause and qualification displayed")
	await press(console.lesson_toggle)
	check(console.detail.text.contains(learning.loader.rich_attacks[int(rows[0].learning_attack_id)].definition),"Actual attack definition from rich catalog")
	await capture("p13_console_one")
	await press(console.back_button)
	# Progress normally to another canonical DC-01 slot; never relocate a physical identity.
	await next_combat_round()
	var second: Dictionary=learning.loader.questions.filter(func(question):return question.center_id=="DC-01")[0]
	learning.select_answer(second.contact_id,second.correct_defense_id);await press(learning.nav.report);await press(learning.submit_answers_button);await frames()
	# The existing authoritative evasion API records the outcome, without a mock registry.
	var rng:=RandomNumberGenerator.new();var seed_value:=0
	while true:
		rng.seed=seed_value
		if rng.randf()<0.5:break
		seed_value+=1
	learning.session.evasion_rng.seed=seed_value
	var shot=learning.projectiles[0];learning.session.evade_shot(second.contact_id,shot.generation)
	await press(learning.group_ui.inspector_button);check(console.incident_buttons.size()==1,"Airborne shot does not prematurely create an incident")
	await sim(36);await sim(2);await frames()
	check(learning.session.internal_for_center("DC-01").size()==2,"Evaded interception joins same registry")
	check(console.incident_buttons.size()==2,"Open console refreshes live on authoritative impact")
	await press(console.back_button)
	await next_combat_round()
	var third: Dictionary=learning.loader.questions.filter(func(question):return question.center_id=="DC-01")[0]
	learning.select_answer(third.contact_id,third.correct_defense_id);await press(learning.nav.report);await press(learning.submit_answers_button);await frames();await sim(36);await sim(2)
	check(learning.session.internal_for_center("DC-01").size()==2,"HIT creates no incident")
	await press(learning.group_ui.inspector_button);check(console.incident_buttons.size()==2,"Distinct physical arrivals remain separate")
	await capture("p13_console_multiple")
	var evaded: Dictionary=learning.session.internal_for_center("DC-01").filter(func(r):return r.arrival_cause=="EVADED_INTERCEPTION")[0]
	await press(console.incident_buttons[evaded.physical_id]);check(console.detail.text.contains("Threat evaded orbital interception."),"Selected evasion details match registry")
	await capture("p13_console_detail")
	console.detail.scroll_to_line(8);await frames();await capture("p13_console_definition");console.detail.scroll_to_line(0)
	before=state();console.refresh_records();console.refresh_records();check(state()==before,"Read-only refresh preserves first-arrival registry")
	var escape:=InputEventKey.new();escape.keycode=KEY_ESCAPE;escape.pressed=true;test_viewport.push_input(escape);await frames();check(not console.visible and state()==before,"Escape returns without a command or state mutation");learning.security_console.open_console();await frames()
	check(not learning.player_fire_at(Vector2(400,400)),"Console cannot accidentally trigger player firing")
	test_viewport.size=Vector2i(1280,720);await frames(12);check((console.back_button.get_global_transform_with_canvas()*Rect2(Vector2.ZERO,console.back_button.size)).end.x<=1280 and (console.defend_button.get_global_transform_with_canvas()*Rect2(Vector2.ZERO,console.defend_button.size)).end.y<=720,"Responsive controls fit 1280 by 720")
	await capture("p13_console_1280")
	test_viewport.size=Vector2i(1920,1080);await frames(12);check((console.back_button.get_global_transform_with_canvas()*Rect2(Vector2.ZERO,console.back_button.size)).end.x<=1920 and (console.defend_button.get_global_transform_with_canvas()*Rect2(Vector2.ZERO,console.defend_button.size)).end.y<=1080,"Responsive controls fit 1920 by 1080")
	test_viewport.size=Vector2i(1600,900);await frames();await press(console.back_button);check(state()==before,"Console navigation leaves authoritative session unchanged")
	learning.orbital_display.layout_centers(["DC-01","DC-02","DC-03","DC-04","DC-05","DC-06"]);await frames();await capture("p13_console_return")
	for center in ["DC-02","DC-03","DC-04","DC-05","DC-06"]:check(learning.session.internal_for_center(center).all(func(r):return r.center_id==center),"Other centers retain their own authoritative records")
	check(command.mission.public_snapshot()==official and command.operations.session.events()==ledger,"Learning combat and console leave canonical mission and ledger unchanged")
	for center in ["DC-02","DC-03","DC-04","DC-05","DC-06"]:
		console.open_console(center);await frames();check(console.center_id==center and console.title_label.text.ends_with(center.right(2)),"Parameterized console identity: "+center);console.dismiss()
	var elapsed: float=learning.session.now;command.set_strategic_pause(false);console.open_console();await frames(30);check(learning.session.now>elapsed,"Console introduces no new pause or timer rule");console.dismiss();command.set_strategic_pause(true)
	await close_game();print("PROTOTYPE 13 SECURITY CONSOLE: ","PASS" if failures==0 else "FAIL"," (",failures," failures / ",checks," checks)");quit(0 if failures==0 else 1)
