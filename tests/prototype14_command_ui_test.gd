extends "res://tests/prototype4_test.gd"
var real_time:=false
var began:=0
func press14(id: String) -> void:
	var b: Button=game.controls[id]
	if game.body.is_ancestor_of(b):game.scroll.ensure_control_visible(b);await frames(8)
	check(b.is_visible_in_tree() and not b.disabled,"Control available: "+id)
	await click_at(b.get_global_rect().get_center());await frames()
func wait_watch(seconds: float) -> void:
	if real_time:await create_timer(seconds).timeout
	else:game.session.step(seconds);await frames()
func pause_observe(seconds: float) -> void:
	if real_time:await create_timer(seconds).timeout
func save_watch(name_value: String) -> void:
	var file:=FileAccess.open("user://p14_"+name_value+"_watch.json",FileAccess.WRITE)
	file.store_string(JSON.stringify({"elapsed_simulation":game.session.clock,"metrics":game.session.metrics,"events":game.session.events,"score":game.session.score(),"unauthorized":game.session.unauthorized,"session_revoked":game.session.session_revoked,"compromise_confirmed":game.session.compromise_confirmed},"  "))
func run() -> void:
	real_time=OS.get_cmdline_user_args().has("--p14-real-time");began=Time.get_ticks_msec()
	game=load("res://scene/prototype14_commanders_experience.tscn").instantiate();test_viewport.add_child(game);await frames(12)
	await capture("p14_arrival");await press14("start");await pause_observe(15)
	await press14("pause");var held_clock: float=game.session.clock;var held_visual: float=game.station.animation_time;await frames(12);check(game.session.clock==held_clock and game.station.animation_time==held_visual,"Pause holds scenario and environment animation");await press14("pause")
	await press14("company");await pause_observe(18)
	for id in ["mara","imani","eli"]:
		await press14("crew_"+id);await pause_observe(10);await press14("follow_"+id);await pause_observe(10)
	await press14("brief");check(game.session.crew_briefed,"Human-intelligence concern produces a private crew briefing, not attribution")
	await capture("p14_crew")
	await press14("upgrades");await pause_observe(12);await press14("choose_identity");await pause_observe(6);await press14("delegate")
	await wait_watch(20);await press14("journal");await pause_observe(12);await click_at(game.station.hotspots.core.get_global_rect().get_center());await frames();await press14("health");await pause_observe(20)
	await wait_watch(32);check(game.session.upgrade_ready,"Commissioned module visible")
	await capture("p14_identity_upgrade")
	if game.session.clock<90:await wait_watch(91-game.session.clock)
	await press14("incident");check(game.panel_mode=="identity" and game.session.account_known,"Incident routes to actual account visibility")
	check(game.context_title.text=="Identity & access" and game.session.attack.display_name=="Default credential exploitation","Full attack label available, not abbreviated")
	await capture("p14_identity_incident");await pause_observe(18);await press14("rotate");await wait_watch(19)
	check(game.session.credentials_retired,"Operational credential rotation completes")
	await click_at(game.station.hotspots.network.get_global_rect().get_center());await frames();await press14("trace");await wait_watch(17)
	await capture("p14_network_evidence");await pause_observe(12)
	await click_at(game.station.hotspots.core.get_global_rect().get_center());await frames();await press14("verify");await wait_watch(26)
	check(game.session.ready_to_finish() and not game.session.compromise_confirmed,"Service verified without inventing compromise")
	await press14("debrief");await press14("finish");check(game.session.finished,"Playable command sequence reaches recorded outcome")
	save_watch("realtime" if real_time else "success")
	await capture("p14_debrief");await press14("results_company");check(game.session.standings().size()==15,"Competitive standings")
	check(game.scroll.scroll_vertical==0,"New context opens at its title rather than inheriting an unrelated scroll offset")
	game.scroll.scroll_vertical=0;await frames();await capture("p14_company")
	game.open_panel("adversary");await frames();await capture("p14_adversary_debrief");check(game.session.finished,"Adversary perspective follows outcome")
	var final_events: Array=game.session.events.duplicate(true)
	for resolution in [Vector2i(1280,720),Vector2i(1600,900),Vector2i(1920,1080)]:
		test_viewport.size=resolution;game.open_panel("");await frames(10)
		check(game.content.get_global_rect().end.x<=resolution.x+1 and game.content.get_global_rect().end.y<=resolution.y+1,"Logical stage fits "+str(resolution))
		await capture("p14_station_%dx%d" % [resolution.x,resolution.y]);game.open_panel("debrief");await frames()
		check(game.context.get_global_rect().end.x<resolution.x and game.context.get_global_rect().end.y<resolution.y,"Context controls fit "+str(resolution))
		await capture("p14_debrief_%dx%d" % [resolution.x,resolution.y])
	check(game.session.events==final_events,"Navigation and resizing do not alter the command outcome")
	test_viewport.size=Vector2i(1600,900);await frames();game.restart_watch();await frames();check(not game.session.started and game.session.events.is_empty(),"Restart resets only the P14 watch")
	game.open_panel("adversary");check(not game.controls.has("adversary_back"),"No omniscient adversary debrief before completion")
	var escape_key:=InputEventKey.new();escape_key.keycode=KEY_ESCAPE;escape_key.pressed=true;test_viewport.push_input(escape_key);await frames();check(game.panel_mode.is_empty(),"Escape closes optional detail without resetting the watch")
	if not real_time:await recovery_route()
	await close_game();print("PROTOTYPE 14 UI: ","PASS" if failures==0 else "FAIL"," (",failures," failures / ",checks," checks / ",(Time.get_ticks_msec()-began)/1000.0," wall seconds / real-time=",real_time,")");quit(0 if failures==0 else 1)
func recovery_route() -> void:
	game.open_panel("");await frames();await press14("upgrades");check(game.panel_mode=="welcome","Closing welcome cannot strand a player before taking command")
	game.controls.start.grab_focus();var key:=InputEventKey.new();key.keycode=KEY_SPACE;key.pressed=true;test_viewport.push_input(key);await frames();key=InputEventKey.new();key.keycode=KEY_SPACE;key.pressed=false;test_viewport.push_input(key);await frames();check(game.session.started,"Native keyboard Space takes command without a mouse")
	for id in ["mara","imani","eli"]:await press14("crew_"+id)
	await press14("upgrades");await press14("choose_network");await press14("personal")
	await click_at(game.station.hotspots.identity.get_global_rect().get_center());await frames();await click_at(game.station.hotspots.network.get_global_rect().get_center());await frames();await wait_watch(91)
	check(game.session.upgrade_ready and game.session.connection_known,"Network upgrade is visibly useful; personal verification completes")
	await press14("incident");await capture("p14_network_upgrade");await press14("route");await wait_watch(80)
	check(not game.session.unauthorized and not game.session.credentials_retired,"Route isolation holds off access without fixing credentials")
	await press14("route");await frames();check(game.session.unauthorized,"Reopening an unrepaired route has a recoverable consequence")
	await press14("go_identity");await press14("audit");await wait_watch(23);await capture("p14_unauthorized_session")
	await press14("rotate");await wait_watch(19);check(not game.session.ready_to_finish(),"Credential replacement alone does not clear an active session")
	await press14("revoke");await press14("go_verify");await press14("health");await wait_watch(19);await press14("verify");await wait_watch(26)
	await press14("debrief");await press14("finish");check(game.session.finished and game.session.session_revoked,"Delayed route completes through actual operational recovery")
	save_watch("recovery")
	await capture("p14_recovered_debrief")
