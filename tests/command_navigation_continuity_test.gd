extends "res://tests/prototype12_test.gd"
func route(index: int) -> void:
	if index<7:
		learning.navigation.select(index);learning.navigation.item_selected.emit(index);await frames()
		if index>0:await press(learning.group_ui.inspector_button)
	else:
		learning.group_ui.command_destination(7) if index==9 else learning.group_ui.operations_destination(5) if index==7 else learning.request_host("training");await frames()
func run() -> void:
	root.gui_embed_subwindows=false
	game=load("res://scene/odc_entry.tscn").instantiate();test_viewport.add_child(game);await frames(8)
	await capture("continuity_command_desk")
	game.open_orbital();await frames(12)
	learning=game.live_game;command=learning.command
	check(learning.navigation.item_count==7 and not learning.command.decision_pages.role_select.visible,"Menu has six actual centers; legacy role indices remain hidden adapters")
	check(learning!=null and not game.overlay.visible,"Actual Command Desk button initializes and shows persistent live scene")
	command.set_strategic_pause(true)
	var original_ledger: Array=command.operations.session.events();var official: Dictionary=command.mission.public_snapshot()
	await press(learning.nav.analyze);await press(learning.yes_button)
	var q: Dictionary=learning.loader.questions[0];var id: int=q.contact_id
	check(q.attack_id==33 and q.center_id=="DC-01","Recorded seed reproduces actual DNS cache poisoning question")
	learning.select_answer(id,q.correct_defense_id);await press(learning.submit_answers_button);await frames()
	check(learning.projectiles.size()==1 and learning.session.flights.has(id),"Real submission creates one claimed missile through original launch code")
	game.open_watch();await frames();check(not is_instance_valid(game.watch) and learning.navigation_notice.text.contains("queued or in flight"),"Airborne training blocked with plain-language guidance")
	var rng:=RandomNumberGenerator.new();var seed_value:=0
	while true:
		rng.seed=seed_value
		if rng.randf()<0.5:break
		seed_value+=1
	learning.session.evasion_rng.seed=seed_value
	await press(learning.martian.evade_button);await capture("continuity_dns_incoming")
	await sim(35.99);check(learning.session.internal_for_center("DC-01").is_empty(),"No arrival before actual missile callback")
	await sim(0.01);check(learning.session.results[id].projectile_outcome=="EVADED","Real pursuit passage callback records EVADED")
	await sim(2);await frames()
	var arrival: Dictionary=learning.session.internal_for_center("DC-01")[0]
	print("DNS CALLBACK: attack=33 / ",arrival.physical_id," / ",arrival.arrival_cause," / outcome=",arrival.source_outcome," / roll=",learning.session.results[id].evasion_roll)
	check(arrival.learning_attack_id==33 and arrival.arrival_cause=="EVADED_INTERCEPTION" and not arrival.compromise_confirmed,"Source registry records same DNS identity and uncertainty")
	await route(1)
	check(learning.tactical_console.visible and learning.tactical_console.detail.text.contains("DNS cache poisoning") and learning.tactical_console.detail.text.contains(arrival.physical_id),"DC-01 Tactical Command displays exact current DNS arrival")
	await capture("continuity_dns_tactical")
	await press(learning.tactical_console.tactical_tools);check(command.focused_center=="DC-01" and command.decision_pages.opened.threat,"Tactical Officer tools preserve exact DC-01 operational interface");await route(1)
	learning.open_security(learning.navigation_context.selected_center);await frames()
	check(learning.security_console.visible and learning.security_console.detail.text.contains("DNS cache poisoning") and learning.security_console.detail.text.contains(arrival.physical_id) and learning.security_console.detail.text.contains("EVADED"),"Security Console shows same identity, name and physical outcome")
	await capture("continuity_dns_security")
	await press(learning.security_console.back_button)
	for i in range(1,7):
		await route(i)
		var center: String="DC-%02d" % i
		check(learning.navigation_context.selected_center==center and learning.tactical_console.center_id==center,"Exact center selection: "+center)
		if i>1:check(learning.tactical_console.title_label.get_parent().get_child(1).text.contains("TACTICAL GROUP COMMANDER") and not learning.tactical_console.detail.text.contains(arrival.physical_id),"Six-center authority without DC-01 contamination: "+center)
		learning.open_security(learning.navigation_context.selected_center);await frames()
		check(learning.security_console.center_id==center and learning.security_console.title_label.text.ends_with(center.right(2)),"Security Console bound to selected center: "+center)
		await press(learning.security_console.back_button)
	await route(7);check(command.command_level=="operations" and command.decision_pages.opened.contacts,"Fleet monitoring preserves Operations Commander tools without promotion");learning.learning_center_select.select(4);learning.learning_center_select.item_selected.emit(4);await frames();check(learning.navigation_context.selected_center=="DC-05","Learning center selector retains identity in new navigation")
	learning.command.decision_pages.center_control.select(2);learning.command.decision_pages.center_control.item_selected.emit(2);await frames();check(learning.navigation_context.selected_center=="DC-03","Canonical tactical selector retains identity in new navigation")
	await route(1);check(learning.tactical_console.detail.text.contains(arrival.physical_id),"Revisit retains same incident")
	for res in [Vector2i(1280,720),Vector2i(1600,900),Vector2i(1920,1080)]:
		test_viewport.size=res;await frames(8)
		check((learning.tactical_console.back_button.get_global_transform_with_canvas()*Rect2(Vector2.ZERO,learning.tactical_console.back_button.size)).end.x<=res.x and (learning.tactical_console.defend_button.get_global_transform_with_canvas()*Rect2(Vector2.ZERO,learning.tactical_console.defend_button.size)).end.y<=res.y,"Live command controls fit "+str(res))
		await capture("continuity_tactical_%dx%d" % [res.x,res.y])
	test_viewport.size=Vector2i(1600,900);await frames()
	await press(learning.tactical_console.back_button);await route(8);await frames()
	check(is_instance_valid(game.watch) and game.watch.visible and game.overlay.visible,"Safe explicit pause permits separate training")
	var w: Control=game.watch;var s: RefCounted=learning.session;var before:=JSON.stringify([s.internal_threats,s.results,s.physical_targets,s.firing_mode,s.now])
	check(learning.canvas.visible==false and not learning.nav.report.is_visible_in_tree(),"Live CanvasLayers are masked during training to prevent hidden UI input")
	check(w.content.get_child_count()>0 and w.session.attack.attack_id==53,"Training retains its own credential exercise, never overwrites DNS")
	await capture("continuity_training_badge")
	w.controls.start.pressed.emit();w.open_panel("checklist");await frames();check(not w.session.ready_to_finish(),"Training checklist retains actual prerequisites")
	check(not learning.player_fire_at(Vector2(500,400)),"Training UI cannot fire a live missile")
	await frames(20);check(JSON.stringify([s.internal_threats,s.results,s.physical_targets,s.firing_mode,s.now])==before,"Training cannot silently advance paused combat or mutate live incidents")
	w.request_return();await frames();game.open_orbital();await frames()
	check(game.live_game==learning and learning.session==s and learning.session.internal_for_center("DC-01")[0]==arrival,"Return retains same live session, first arrival and explicit pause")
	command.set_strategic_pause(false);game.open_watch();await frames();check(not game.overlay.visible and learning.navigation_notice.text.contains("Pause the live mission"),"Unpaused Learning Mode training requires explicit pause")
	command.set_learning_mode(false);game.open_watch();await frames();check(learning.navigation_notice.text.contains("Active Challenge"),"Active Challenge cannot enter training")
	command.set_learning_mode(true);command.set_strategic_pause(true)
	# A second correctly answered contact follows the real HIT callback and adds no arrival.
	var second: Dictionary=learning.loader.questions[1];learning.select_answer(second.contact_id,second.correct_defense_id);learning.show_page("report");await frames();await press(learning.submit_answers_button);await sim(36);await sim(2)
	check(learning.session.results[int(second.contact_id)].projectile_outcome=="HIT" and learning.session.internal_for_center(second.center_id).is_empty(),"Authoritative HIT creates no internal incident")
	check(command.operations.session.events()==original_ledger and command.mission.public_snapshot()==official,"Navigation/combat preserves canonical scoring and ledger")
	var mission: String=learning.navigation_context.mission_id();s.reset();await frames();await route(1)
	check(learning.incident_rows("DC-01").is_empty() and learning.navigation_context.mission_id()!=mission and not learning.tactical_console.detail.text.contains(arrival.physical_id),"Learning reset invalidates epoch and stale incident selection")
	await route(9);await frames();check(game.desk.visible,"Command menu returns to persistent Command Desk")
	game.remove_child(game.leave_dialog);root.add_child(game.leave_dialog);await frames()
	game.request_new_mission();await frames();check(game.leave_dialog.visible,"New Mission requires explicit confirmation")
	game.leave_dialog.hide();game.leave_dialog.confirmed.emit();await frames(20)
	check(game.live_game!=learning and game.live_game.navigation_context.mission_id()!=mission and game.live_game.session.internal_threats.is_empty(),"New Mission replaces live instance and clears old arrivals")
	check(game.watch==w,"New live mission does not reset separate training progress")
	learning=game.live_game;await route(1);await capture("continuity_new_mission_zero")
	game.queue_free();await frames();print("COMMAND NAVIGATION CONTINUITY: ","PASS" if failures==0 else "FAIL"," (",failures," failures / ",checks," checks)");quit(0 if failures==0 else 1)
