extends "res://tests/prototype12_live_status_test.gd"
func run() -> void:
	learning=load("res://scene/learning_retrofit_command.tscn").instantiate();learning.session_seed=12345;game=learning;test_viewport.add_child(learning);await frames();command=learning.command;command.set_strategic_pause(true)
	var official: Dictionary=command.mission.public_snapshot();var events: Array=command.operations.session.events()
	await press(learning.nav.analyze);await press(learning.yes_button);await frames()
	var q: Dictionary=learning.loader.questions[0];var id: int=q.contact_id;var wrong: int=q.options.filter(func(d):return d!=q.correct_defense_id)[0]
	learning.select_answer(id,wrong);await press(learning.closes.report);await frames()
	check(learning.session.internal_threats.is_empty() and learning.session.results.is_empty(),"CLOSE never grades or creates an arrival")
	await press(learning.nav.report);await press(learning.submit_answers_button);await frames()
	var key: String=learning.session.question_targets[q.learning_id];var entry: Dictionary=learning.session.internal_threats[key]
	check(entry.arrival_cause=="UNOPPOSED_ARRIVAL" and entry.center_id==q.center_id,"Submitted wrong answer creates correct center arrival")
	check(learning.projectiles.is_empty() and learning.martian.incoming().is_empty() and learning.session.pending.is_empty(),"No missile, alarm threat or queue for wrong answer")
	var warning: Label=learning.orbital_display.internal_warning_labels[q.center_id]
	check(warning.visible and warning.text.contains("Threat has migrated inside your data center infrastructure.") and warning.text.contains("compromise not confirmed") and warning.text.contains("C-%03d" % id),"Persistent red warning identifies threat and clarification")
	check(warning.get_line_count()*warning.get_theme_font("font").get_height(13)<=warning.size.y,"Warning remains readable within tile")
	for other in learning.loader.questions:
		if other.contact_id!=id:check(not learning.session.internal_threats.has(learning.session.question_targets[other.learning_id]),"Partial submission leaves unanswered threats unflagged")
	await capture("unopposed_arrival_warning")
	var saved: Dictionary=learning.session.internal_threats.duplicate(true)
	await press(learning.nav.report);await frames();await press(learning.closes.report);learning.change_fire_mode(1);learning.change_fire_mode(0)
	await press(learning.war_room_button);await press(learning.war_room.back_button);await frames()
	learning.apply_single_view(q.center_id);await frames();check(warning.visible,"Warning survives return to single-center view")
	await capture("unopposed_arrival_single_center")
	learning.orbital_display.layout_centers(["DC-01","DC-02","DC-03","DC-04","DC-05","DC-06"]);await frames(20)
	check(learning.session.internal_threats==saved and command.mission.public_snapshot()==official and command.operations.session.events()==events,"Navigation/refresh/modes preserve unique record and original score/ledger")
	await close_game();print("UNOPPOSED ARRIVAL UI: ","PASS" if failures==0 else "FAIL"," (",failures," failures)");quit(0 if failures==0 else 1)
