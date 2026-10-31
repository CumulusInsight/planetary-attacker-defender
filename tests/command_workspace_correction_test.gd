extends "res://tests/prototype12_test.gd"
func native_press(control: Button) -> void:
	pointer_at(control.get_global_transform_with_canvas()*(control.size/2));await frames(2)
	await click_at(control.get_global_transform_with_canvas()*(control.size/2));await frames(4)
func mission_state() -> String:
	return JSON.stringify([learning.session.answers,learning.session.results,learning.session.pending,learning.session.internal_threats,learning.session.now,learning.session.round_index,command.mission.public_snapshot(),command.operations.session.events()])
func run() -> void:
	root.gui_embed_subwindows=false
	game=load("res://scene/odc_entry.tscn").instantiate();test_viewport.add_child(game);await frames(14)
	learning=game.live_game;command=learning.command;command.set_strategic_pause(true)
	var official: Dictionary=command.mission.public_snapshot();var ledger: Array=command.operations.session.events()
	var ui=learning.group_ui
	check(not game.overlay.visible and learning.orbital_display.centers.size()==6,"Launcher landing is the live six-center graphical workspace")
	check(ui.menus.keys()==["COMMAND","OPERATIONS","PERSONNEL","TRAINING","REPORTS"],"Five discoverable top command categories")
	check(ui.authority.text=="TACTICAL GROUP COMMAND" and ui.group_caption.text.contains("DC-06"),"Visible parent group and six subordinate assets")
	for key in ui.menus:
		await native_press(ui.menus[key]);check(ui.menus[key].get_popup().visible,"Native top menu opens: "+key);ui.menus[key].get_popup().hide();await frames()
	check(ui.left_buttons.size()==4 and learning.nav.analyze.is_visible_in_tree() and learning.nav.decide.is_visible_in_tree(),"Left navigation and operational bottom actions visible together")
	await capture("correction_default")
	var original:=mission_state();var mission: String=learning.navigation_context.mission_id()
	for i in range(1,7):
		ui.menu.get_popup().id_pressed.emit(i);await frames();var center: String="DC-%02d" % i
		check(learning.navigation_context.selected_center==center and ui.context_title.text.begins_with(center),"COMMAND selection retains exact center: "+center)
		check(learning.orbital_display.centers==[center] and mission_state()==original,"Same mission, records and clocks: "+center)
		if i>3:
			var actor: String=command.focused_center;ui.operations_destination(4);ui.reports_destination(1);await frames()
			check(command.focused_center==actor and learning.navigation_notice.text.contains("not implemented"),"Unsupported legacy evidence/tools do not redirect: "+center)
	ui.select_page("history");check(ui.context_text.text.contains("learning engagement records"),"History available even without an active-round encounter")
	ui.select_page("evidence");check(ui.context_text.text.contains("No SIEM telemetry"),"Evidence uncertainty available without a current question")
	ui.menu.get_popup().id_pressed.emit(0);await frames()
	check(learning.navigation_context.mission_id()==mission and learning.orbital_display.centers.size()==6,"Group Overview returns to retained mission")
	ui.personnel_destination(0);await frames();check(ui.personnel_panel.visible and learning.mode_modal_open(),"Personnel is read-only existing training crew and gates firing")
	await native_press(ui.personnel_close)
	await native_press(learning.nav.analyze);check(learning.page=="analyze","Bottom Analyze uses existing prompt")
	await native_press(learning.yes_button);check(learning.page=="report" and learning.session.analyzed,"Existing Yes opens current group Report")
	check(learning.loader.rounds.map(func(r):return r.size())==[5,5,5,5,2],"Existing catalog-driven 22 questions preserved")
	var q: Dictionary=learning.loader.questions[0];var wrong: Dictionary=learning.loader.questions[1]
	check(q.attack_id==33 and q.center_id=="DC-01","Seed reproduces actual DNS cache poisoning")
	learning.select_answer(q.contact_id,q.correct_defense_id);learning.select_answer(wrong.contact_id,wrong.options.filter(func(d):return d!=wrong.correct_defense_id)[0])
	await native_press(learning.closes.report)
	check(learning.session.results.is_empty() and learning.session.pending.is_empty(),"CLOSE preserves selections without grading or launching")
	learning.select_group_center("DC-01");await frames();await native_press(ui.left_buttons.assessment)
	check(ui.context_text.text.contains("DNS cache poisoning") and ui.context_text.text.contains(learning.loader.rich_attacks[33].question),"Assessment explains actual center, attack and scenario before response")
	check(not ui.context_text.text.contains("Correct answer"),"No early answer-key disclosure")
	await capture("correction_assessment")
	learning.fire_mode_control.select(1);learning.fire_mode_control.item_selected.emit(1);await frames()
	await native_press(learning.nav.report);await capture("correction_report");await native_press(learning.submit_answers_button);await frames()
	check(learning.page.is_empty() and learning.session.authorized_targets().size()==1 and learning.projectiles.is_empty(),"Partial submission preserves PLAYER FIRE authorization without launching")
	check(learning.session.results.has(wrong.contact_id) and not learning.session.results[wrong.contact_id].answer_correct,"Wrong selection graded once, without missile")
	learning.open_orbital_view();await frames()
	var point: Vector2=learning.orbital_canvas.transform*(learning.orbital_display.origins["DC-01"]+Vector2(38,0))
	pointer_at(point);await frames();await click_at(point);await frames()
	check(learning.projectiles.size()==1,"Actual left click maps transformed workspace to existing authorized homing launch")
	if learning.projectiles.is_empty():game.queue_free();await frames();quit(1);return
	var p=learning.projectiles[0];check(p.duration==36 and learning.session.flights.size()==1,"Exact existing flight duration and one authorization claimed")
	await click_at(point);await frames();check(learning.projectiles.size()==1,"Repeated input cannot duplicate launch")
	var rng:=RandomNumberGenerator.new();var seed_value:=0
	while true:
		rng.seed=seed_value
		if rng.randf()<0.5:break
		seed_value+=1
	learning.session.evasion_rng.seed=seed_value;await native_press(learning.martian.evade_button)
	check(learning.martian.visible and not ui.context_panel.visible,"Right region hands over to actual Martian warning/evasion controls")
	check(not learning.toast.visible,"Incoming warning owns right region without overlapping a second result panel")
	await capture("correction_incoming")
	game.open_watch();await frames();check(not is_instance_valid(game.watch) and learning.navigation_notice.text.contains("queued or in flight"),"Training retains explicit safe-point restriction")
	var head: Vector2=p.head;await frames(8);check(p.head==head,"Strategic pause preserves presentation flight")
	await sim(35.99);check(not learning.session.results.has(q.contact_id),"No early impact from presentation transform")
	await sim(0.01);await sim(2)
	var arrivals: Array=learning.incident_rows("DC-01")
	check(arrivals.size()==1 and arrivals[0].attack_id==33 and arrivals[0].source_outcome=="EVADED","Authoritative DNS passage callback reaches same registry")
	await native_press(learning.martian.close_button);learning.select_group_center("DC-01");await frames()
	check(ui.context_panel.visible and learning.toast.visible,"Resolved receipt is presented inside the right context region")
	for child in ui.context_panel.get_children():
		if child is Button and child.position.y>=500:check(not child.visible,"No hidden-under-receipt contextual action remains clickable")
	await native_press(ui.left_buttons.evidence);check(ui.context_text.text.contains(arrivals[0].physical_id),"Evidence panel uses exact center-specific live arrival")
	await native_press(ui.left_buttons.history);check(ui.context_text.text.contains("DNS cache poisoning") and ui.context_text.text.contains("EVADED"),"Learning history preserves full attack identity and physical outcome")
	await native_press(ui.inspector_button);check(learning.security_console.visible and learning.security_console==learning.tactical_console and learning.security_console.detail.text.contains(arrivals[0].physical_id),"Shared incident inspector retained")
	await capture("correction_inspector");await native_press(learning.security_console.back_button)
	ui.reports_destination(1);await frames();check(command.focused_center=="DC-01" and command.decision_pages.drawer_mode=="intelligence" and command.decision_pages.opened.drawer,"Original Evidence remains accessible for exact supported actor")
	ui.reports_destination(2);await frames();check(command.decision_pages.drawer_mode=="history","Original Decision Timeline remains separate and reachable")
	ui.reports_destination(3);await frames();check(command.scorecard_open,"Official scorecard preserved separately")
	await native_press(command.mission_ui.close_button);learning.open_orbital_view();await frames()
	for res in [Vector2i(1280,720),Vector2i(1600,900),Vector2i(1920,1080)]:
		test_viewport.size=res;await frames(12)
		for key in ui.menus:
			var b: Button=ui.menus[key];var rect: Rect2=b.get_global_transform_with_canvas()*Rect2(Vector2.ZERO,b.size)
			check(rect.position.x>=0 and rect.end.x<=res.x,"Readable menu bounds "+key+" / "+str(res))
		for key in ui.left_buttons:
			var b: Button=ui.left_buttons[key];var rect: Rect2=b.get_global_transform_with_canvas()*Rect2(Vector2.ZERO,b.size)
			check(rect.end.y<=res.y,"Left navigation fits "+key+" / "+str(res))
		var rect: Rect2=ui.bottom.get_global_transform_with_canvas()*Rect2(Vector2.ZERO,ui.bottom.size);check(rect.end.x<=res.x and rect.end.y<=res.y,"Bottom operational controls fit "+str(res))
		await native_press(ui.left_buttons.assessment);check(ui.context_mode=="assessment","Native left action works at "+str(res))
		await capture("correction_workspace_%dx%d" % [res.x,res.y])
		await native_press(ui.inspector_button);await capture("correction_detail_%dx%d" % [res.x,res.y]);await native_press(learning.security_console.back_button)
	test_viewport.size=Vector2i(1600,900);await frames();command.set_strategic_pause(true);game.open_watch();await frames()
	check(is_instance_valid(game.watch) and game.watch.session.attack.attack_id==53,"Safe training remains separate credential exercise, not overwritten by DNS")
	game.watch.request_return();await frames();game.open_orbital();await frames()
	check(game.live_game==learning and learning.incident_rows("DC-01")[0].physical_id==arrivals[0].physical_id,"Training return preserves live identity and mission")
	check(command.mission.public_snapshot()==official and command.operations.session.events()==ledger,"Official scoring and canonical operational ledger unchanged")
	game.queue_free();await frames();print("COMMAND WORKSPACE CORRECTION: ","PASS" if failures==0 else "FAIL"," (",failures," failures / ",checks," checks)");quit(0 if failures==0 else 1)
