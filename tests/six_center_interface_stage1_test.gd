extends "res://tests/prototype12_test.gd"
func snapshot() -> String:
	return JSON.stringify([learning.session.answers,learning.session.results,learning.session.internal_threats,learning.session.physical_targets,learning.session.pending,learning.session.firing_mode,learning.session.now,learning.session.round_index,command.mission.public_snapshot(),command.operations.session.events()])
func select_center(index: int) -> void:
	learning.navigation.select(index);learning.navigation.item_selected.emit(index);await frames()
func run() -> void:
	game=load("res://scene/odc_entry.tscn").instantiate();test_viewport.add_child(game);await frames(8)
	game.open_orbital();await frames(12)
	learning=game.live_game;command=learning.command;command.set_strategic_pause(true)
	check(learning.navigation.item_count==7,"One selector: group plus six centers")
	check(not command.decision_pages.center_control.visible and not learning.learning_center_select.visible and not learning.overview_button.visible,"Competing selectors hidden; adapters retained")
	check(learning.group_ui.authority.text.contains("TACTICAL GROUP COMMAND"),"Approved six-center command duty displayed")
	check(learning.tactical_console==learning.security_console,"Tactical and Security share one live inspector instance")
	check(learning.orbital_display.centers.size()==6 and learning.orbital_canvas.visible and not learning.session.analyzed,"Group overview visible without silently analyzing")
	await capture("stage1_group_before_analysis")
	await press(learning.nav.analyze);await press(learning.yes_button)
	check(learning.loader.rounds.map(func(r):return r.size())==[5,5,5,5,2],"22-question structure unchanged")
	var q: Dictionary=learning.loader.questions[0];check(q.attack_id==33 and q.center_id=="DC-01","Deterministic actual DNS cache poisoning scenario")
	learning.select_answer(q.contact_id,q.correct_defense_id);learning.close_page()
	var before:=snapshot();var mission: String=learning.navigation_context.mission_id()
	for i in range(1,7):
		await select_center(i);var c: String="DC-%02d" % i
		check(learning.navigation_context.selected_center==c and learning.orbital_display.centers==[c],"Center selected exactly: "+c)
		await press(learning.group_ui.inspector_button)
		check(learning.security_console.center_id==c and learning.security_console.visible,"Shared center-aware inspector: "+c)
		check(learning.security_console.tactical_tools.disabled==(i>3),"Honest legacy capability: "+c)
		if i<=3:
			await press(learning.security_console.tactical_tools)
			check(command.focused_center==c and command.decision_pages.opened.threat,"Correct legacy actor and response interface: "+c)
			learning.open_security(c);await frames()
		if i>3:
			var focused: String=command.focused_center;learning.open_legacy_tactical()
			check(command.focused_center==focused and learning.navigation_notice.text.contains("not implemented"),"Unsupported actor never falls back to DC-01")
		await press(learning.security_console.back_button)
		check(snapshot()==before,"Navigation preserves answers, clocks, records, scores: "+c)
	await press(learning.group_ui.inspector_button)
	check(learning.security_console.center_id=="DC-06" and learning.security_console.visible,"T icon opens selected center inspector, never legacy DC-01")
	learning.security_console.dismiss()
	await press(learning.group_ui.left_buttons.overview)
	check(learning.navigation.selected==0,"O icon opens unified group overview")
	await select_center(0)
	check(learning.navigation_context.mission_id()==mission and learning.orbital_display.centers.size()==6,"Overview retains same mission")
	await press(learning.nav.report);await press(learning.submit_answers_button);await frames()
	check(learning.projectiles.size()==1 and learning.projectiles[0].duration==36,"Existing correct-only launch and 36-second flight")
	var p=learning.projectiles[0];var initial: Vector2=p.head;var layout: Array=learning.orbital_display.centers.duplicate()
	await select_center(6)
	check(learning.orbital_display.centers==layout and not learning.group_ui.requested_layout.is_empty(),"View change deferred during flight without target geometry reset")
	var rng:=RandomNumberGenerator.new();var seed_value:=0
	while true:
		rng.seed=seed_value
		if rng.randf()<0.5:break
		seed_value+=1
	learning.session.evasion_rng.seed=seed_value
	await press(learning.martian.evade_button);await sim(18)
	check(p.head!=initial and learning.session.results.is_empty(),"Continuous pursuit; no premature result")
	await sim(18);await sim(2)
	check(learning.session.results[q.contact_id].projectile_outcome=="EVADED","Actual evaded callback preserved")
	check(learning.orbital_display.centers==["DC-06"],"Deferred navigation applied only after effects")
	learning.open_security("DC-01");await frames()
	var rows: Array=learning.incident_rows("DC-01")
	check(rows.size()==1 and rows[0].attack_id==33 and rows[0].arrival_cause=="EVADED_INTERCEPTION","Authoritative DNS arrival in unchanged registry")
	check(learning.security_console.detail.text.contains("DNS cache poisoning") and learning.security_console.detail.text.contains(rows[0].physical_id),"Shared inspector retains exact canonical and physical identity")
	check(not learning.security_console.lesson_toggle.button_pressed and not learning.security_console.detail.text.contains(rows[0].definition),"Lengthy definition collapsed by default")
	await press(learning.security_console.lesson_toggle)
	check(learning.security_console.detail.text.contains(rows[0].definition),"Existing definition available once on demand")
	await capture("stage1_dns_inspector")
	for c in learning.navigation_context.CENTERS:
		learning.open_security(c);await frames()
		check(learning.incident_rows(c).all(func(r):return r.center_id==c),"No cross-center contamination: "+c)
		if c!="DC-01":check(not learning.security_console.detail.text.contains(rows[0].physical_id),"Other centers do not show DC-01 incident")
	learning.security_console.dismiss();await select_center(0)
	for res in [Vector2i(1280,720),Vector2i(1600,900),Vector2i(1920,1080)]:
		test_viewport.size=res;await frames(12)
		check(learning.navigation.get_global_transform_with_canvas().origin.x>=0,"Selector within viewport "+str(res))
		for center in learning.group_ui.tile_links:
			var b: Button=learning.group_ui.tile_links[center];var bounds:=b.get_global_transform_with_canvas()*Rect2(Vector2.ZERO,b.size)
			check(bounds.end.x<=res.x and bounds.end.y<=res.y,"Selectable tile fits "+center+" / "+str(res))
		await capture("stage1_group_%dx%d" % [res.x,res.y])
		learning.open_security("DC-01");await frames()
		var back: Button=learning.security_console.back_button;var rect:=back.get_global_transform_with_canvas()*Rect2(Vector2.ZERO,back.size)
		check(rect.end.x<=res.x and rect.end.y<=res.y,"Inspector controls fit "+str(res))
		await capture("stage1_inspector_%dx%d" % [res.x,res.y])
		await click_at(back.get_global_transform_with_canvas()*(back.size/2));await frames()
		check(not learning.security_console.visible,"Actual scaled Return button works "+str(res))
		var link: Button=learning.group_ui.tile_links["DC-05"]
		pointer_at(link.get_global_transform_with_canvas()*(link.size/2));await frames()
		await click_at(link.get_global_transform_with_canvas()*(link.size/2));await frames()
		check(learning.navigation_context.selected_center=="DC-05" and learning.group_ui.context_title.text.begins_with("DC-05"),"Actual scaled center tile selects its decision context "+str(res))
		learning.security_console.dismiss()
	test_viewport.size=Vector2i(1600,900);await frames()
	# Remaining partial answers stay available; no resubmission of the evaluated question.
	await press(learning.nav.report);var second: Dictionary=learning.loader.questions[1]
	check(not learning.option_buttons[int(second.contact_id)][0].disabled,"Remaining unanswered row editable after navigation")
	learning.select_answer(second.contact_id,second.correct_defense_id);await press(learning.submit_answers_button);await frames()
	await select_center(0);learning.reset_view()
	check(learning.group_ui.requested_layout.is_empty() and not learning.queued_reset_center.is_empty(),"Manual reset supersedes an older deferred group view without interrupting flight")
	await sim(36);await sim(2)
	check(learning.session.results.size()==2 and learning.session.results[second.contact_id].projectile_outcome=="HIT","Second partial submission evaluates once and HIT remains HIT")
	check(learning.session.internal_for_center(second.center_id).is_empty(),"HIT does not create arrival")
	await select_center(0);await capture("stage1_group_after_partial")
	game.queue_free();await frames();print("SIX CENTER INTERFACE STAGE 1: ","PASS" if failures==0 else "FAIL"," (",failures," failures / ",checks," checks)");quit(0 if failures==0 else 1)
