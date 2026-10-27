extends "res://tests/prototype12_test.gd"
func run() -> void:
	learning=load("res://scene/six_center_learning_command.tscn").instantiate();learning.session_seed=12345;game=learning;test_viewport.add_child(learning);await frames();command=learning.command;command.set_strategic_pause(true);pointer_at(Vector2(40,130))
	check(not FileAccess.get_file_as_string("user://prototype12_catalog_session.json").contains("correct_defense_id"),"Reproduction record does not publish answer keys")
	check(learning.error.is_empty() and learning.loader.bank_size==100 and learning.loader.excluded.is_empty(),"All 100 authoritative attacks eligible; no new catalog content")
	check(learning.loader.rounds.map(func(r):return r.size())==[5,5,5,5,2],"Five-round 22-question plan")
	var seen: Array=[];var centers: Array=[]
	for group in learning.loader.rounds:
		for q in group:
			check(not q.attack_id in seen,"No repeated attack within session");seen.append(q.attack_id)
			if not q.center_id in centers:centers.append(q.center_id)
			check(q.options.size()==4 and q.options.count(q.correct_defense_id)==1,"Four distinct catalog choices with one designated answer")
			check(q.options.filter(func(d):return learning.loader.mappings.has("%d/%d" % [q.attack_id,d])).size()==1,"No valid mapped defense mislabeled a distractor")
			check(learning.learning_contacts[int(q.contact_id)].center_id==q.center_id,"Learning contact/center association valid")
	check(centers.size()==6 and seen.size()==22 and learning.learning_contacts.size()==36,"Six independent learning centers, 36 contact slots")
	var copy=preload("res://script/catalog_learning_loader.gd").new();check(copy.load_questions(command.decision_pages.model).is_empty(),"Validated catalog and original fixture still load")
	copy.generate(12345,learning.learning_rows());check(copy.rounds==learning.loader.rounds,"Seeded session exactly reproducible")
	copy.generate(12346,learning.learning_rows());check(copy.rounds!=learning.loader.rounds,"Different seed varies attacks/options")
	var unmapped: int=int(copy.attacks.keys()[0]);var keys: Array=copy.mappings.keys()
	for key in keys:
		if key.begins_with(str(unmapped)+"/"):copy.mappings.erase(key)
	check(copy.generate(1,learning.learning_rows()).is_empty() and copy.excluded.has(unmapped) and copy.bank_size==99,"Unsupported attack excluded with reason; no invented mapping")
	await probability_checks()
	var official: Dictionary=command.mission.public_snapshot();var events: Array=command.operations.session.events();var canonical: Array=command.registry.contacts.keys()
	await open_report();learning.close_page();await frames();await capture("p12_six_overview")
	check(learning.orbital_display.centers.size()==6 and learning.orbital_display.tiles["DC-04"].position.y>learning.orbital_display.tiles["DC-01"].position.y,"Six overview uses three columns and two rows")
	for tile in learning.orbital_display.tiles.values():check(learning.orbital_display.area.encloses(tile) and tile.end.x<learning.martian.position.x,"Tiles fit viewport and do not intersect warning panel")
	for subset in [["DC-01","DC-02"],["DC-01","DC-02","DC-03"]]:
		learning.orbital_display.layout_centers(subset);await frames();check(learning.orbital_display.centers==subset,"Two/three-center layouts remain available")
	learning.learning_center_select.select(5);learning.learning_center_select.item_selected.emit(5);await frames();check(learning.orbital_display.centers==["DC-06"] and not learning.reset_view_button.visible,"Extra center enlarges with reset button hidden")
	await capture("p12_six_single");await press(learning.overview_button)
	learning.show_page("report");await frames();var row: Dictionary=learning.loader.questions[0];var attack: Button=learning.report_grid.get_child(11);await press(attack)
	check(learning.definition_box.visible and learning.hover_explanation.get_theme_font_size("font_size")==34 and learning.hover_explanation.text.contains(learning.loader.attacks[int(row.attack_id)].definition),"Catalog-generated attack definitions keep exact 34px red-bordered presentation")
	for options in learning.option_buttons.values():
		for control in options:check(control.get_global_rect().end.y<=learning.definition_box.get_global_rect().position.y,"Wrapped catalog defense names do not overlap definition area")
	learning.clear_explanation();choose(3);learning.close_page()
	for delay in [60,300,600]:
		learning.request_fire(delay);check(learning.session.pending.shots.size()==5 and learning.session.countdown()==delay,"Expanded mode preserves exact multi-target minute waits");check(learning.session.cancel(),"Scheduled expanded volley cancels without launching")
	learning.request_fire(0);await frames()
	check(learning.projectiles.size()==5 and learning.martian.incoming().size()==5 and learning.martian.selector==null,"Five independent launches; individual selector removed")
	check(learning.martian.evade_button.text=="EVADE ALL PROJECTILES" and learning.martian.warning.visible,"Prominent EVADE ALL and warning")
	for p in learning.projectiles:check(p.duration==36 and p.fired_at==learning.projectiles[0].fired_at,"Exact continuous 36-second shared launch")
	await capture("p12_six_incoming");await press(learning.martian.evade_button);await capture("p12_six_evade_all")
	check(learning.session.flights.values().all(func(s):return s.evasion_attempted) and learning.martian.evade_button.disabled,"One click orders all eligible targets exactly once")
	var rolls: Dictionary=learning.session.flights.duplicate(true);learning.martian.evade_selected();check(learning.session.flights==rolls,"Repeated command does not reroll")
	var positions: Dictionary={}
	for id in learning.session.flights:positions[id]=learning.orbital_display.markers[id].position
	await sim(0.35)
	var moved:=0
	for id in positions:
		var marker=learning.orbital_display.markers[id];var center: String=learning.learning_contacts[id].center_id
		if marker.position.distance_to(positions[id])>20:moved+=1
		check(learning.orbital_display.tiles[center].has_point(marker.position),"Zigzag stays inside owning tile")
	check(moved==5,"Every attempted evasion visibly maneuvers, regardless of trial result")
	for i in range(18):await sim(0.1)
	await capture("p12_six_zigzag")
	var before: Array=learning.projectiles.map(func(p):return p.head);var offsets: Array=learning.orbital_display.markers.values().map(func(m):return m.position)
	await create_timer(0.2).timeout
	check(learning.projectiles.map(func(p):return p.head)==before and learning.orbital_display.markers.values().map(func(m):return m.position)==offsets,"Strategic pause holds homing flight and zigzag")
	learning.show_page("report");learning.sort_report(2);learning.close_page();check(learning.session.flights==rolls,"Report/sorting does not reroll trials")
	var frozen: Array=learning.projectiles.map(func(p):return p.head);await sim(1.0)
	check(learning.projectiles.map(func(p):return p.head)!=frozen and learning.session.results.is_empty(),"Projectile visibly travels continuously rather than delaying launch")
	var fired: float=learning.projectiles[0].fired_at;await sim(fired+35.999-learning.session.now)
	check(learning.session.results.is_empty(),"No premature impact before 36 seconds")
	await sim(0.002)
	check(learning.session.results.size()==5 and learning.session.metrics().correct==3 and learning.session.metrics().incorrect==2,"Knowledge scoring independent of evasion")
	for r in learning.session.results.values():
		check(r.evasion_attempted and r.evasion_probability==0.5 and r.evasion_roll>=0 and r.evasion_roll<=1,"Independent recorded Bernoulli trial")
		var expected: String="MISS" if not r.answer_correct else "EVADED" if r.evasion_success else "HIT"
		check(r.projectile_outcome==expected,"Physical outcome combines answer correctness and evasion trial")
		check(learning.session.physical_targets[r.physical_id].alive==(expected!="HIT"),"Only actual physical HIT removes target")
		check((learning.deadline_text(r.contact_id)=="00:00")==(expected=="HIT"),"Only HIT neutralizes learning TIME")
	await sim(2.0);await capture("p12_six_mixed")
	check(not learning.martian.alarm.playing and not learning.martian.warning.visible and learning.orbital_display.centers.size()==6,"Alarm stops; no automatic view reset")
	var survivors: Array=learning.session.results.values().filter(func(r):return r.projectile_outcome!="HIT").map(func(r):return r.physical_id)
	var dead: Array=learning.session.physical_targets.values().filter(func(t):return not t.alive).map(func(t):return t.physical_id)
	for round_index in range(1,5):
		learning.show_page("report");await press(learning.next_round_button)
		check(learning.session.round_index==round_index and learning.loader.questions.size()==(2 if round_index==4 else 5),"NEXT ROUND follows 5/5/5/5/2")
		for key in dead:check(not learning.session.physical_targets[key].alive,"Previously destroyed physical identity never resurrects")
		for key in survivors:check(learning.session.physical_targets[key].alive,"First-volley survivors remain alive in every later round")
		for options in learning.option_buttons.values():
			for control in options:check(control.get_global_rect().end.y<=learning.definition_box.get_global_rect().position.y,"All later-round choices remain above definition area")
		if round_index==3:await capture("p12_six_round4")
		if round_index==4:await capture("p12_six_round5")
		choose(learning.loader.questions.size());learning.close_page();learning.request_fire(0);await frames();await sim(36.01);await sim(2.0)
		for r in learning.session.results.values():dead.append(r.physical_id)
	learning.show_page("report");await frames();await capture("p12_six_final")
	check(learning.session.all_results.size()==22 and learning.session.metrics().correct==20 and learning.session.metrics().incorrect==2 and learning.session.session_complete(),"All 22 results and cumulative score retained")
	var physical: Dictionary=learning.session.physical_targets.duplicate(true);learning.select_report_round(1);await frames();check(learning.session.physical_targets==physical,"Historical evasion/physical results read-only")
	var historic: Dictionary=learning.session.round_history[0].results.values()[0];learning.show_result_details(historic.contact_id);check(learning.hover_explanation.text.contains("Evasion:"),"Historical evasion details available without extra columns")
	check(command.mission.public_snapshot()==official and command.operations.session.events()==events and command.registry.contacts.keys()==canonical and command.tactical_centers.size()==3,"No new canonical P10 centers, score or operational events")
	learning.restart_learning();await frames();check(learning.session.all_results.is_empty() and learning.session.physical_targets.values().all(func(t):return t.alive),"Explicit restart restores learning state only")
	await close_game();print("PROTOTYPE 12 SIX CENTERS: ","PASS" if failures==0 else "FAIL"," (",failures," failures; ",checks," checks)");quit(0 if failures==0 else 1)
func probability_checks() -> void:
	var found: Dictionary={}
	for seed_value in range(256):
		var rng:=RandomNumberGenerator.new();rng.seed=seed_value^0x45564144;var count:=0
		for i in range(5):
			if rng.randf()<0.5:count+=1
		if count in [0,2,5] and not found.has(count):found[count]=seed_value
	check(found.size()==3,"Controlled seeds cover zero, partial and complete evasion success")
	for count in found:
		var source=preload("res://script/catalog_learning_loader.gd").new();source.load_questions(command.decision_pages.model);source.generate(found[count],learning.learning_rows())
		var sessions: Array=[]
		for repeat in range(2):
			var model=preload("res://script/monte_carlo_session.gd").new();model.configure(source);model.analyze(learning.learning_rows())
			for q in source.questions:model.select_answer(int(q.contact_id),int(q.correct_defense_id))
			model.request_fire(-1,0);model.begin_volley();var ids: Array=model.evade_all();ids.sort()
			check(ids.size()==5 and model.evade_all().is_empty(),"Five trials accepted once in deterministic contact-ID order")
			check(model.flights.values().filter(func(s):return s.evasion_success).size()==count,"Controlled probability result matches expected count")
			sessions.append(model.flights.duplicate(true));model.advance(36)
			for id in ids:
				check(not model.evade_shot(id,model.generation),"Exact impact boundary refuses late evasion")
				var outcome: Dictionary=model.finish_shot(id,model.generation)
				check(outcome.projectile_outcome==("EVADED" if outcome.evasion_success else "HIT") and outcome.answer_correct,"Controlled success/failure affects physical result only")
		check(sessions[0]==sessions[1],"Dedicated evasion stream exactly reproducible")
		var wrong=preload("res://script/monte_carlo_session.gd").new();wrong.configure(source);wrong.analyze(learning.learning_rows())
		for q in source.questions:wrong.select_answer(int(q.contact_id),int(q.options.filter(func(d):return d!=q.correct_defense_id)[0]))
		wrong.request_fire(-1,0);wrong.begin_volley();var wrong_ids: Array=wrong.evade_all();wrong.advance(36)
		for id in wrong_ids:
			var result: Dictionary=wrong.finish_shot(id,wrong.generation)
			check(result.projectile_outcome=="MISS" and not result.answer_correct and wrong.physical_targets[result.physical_id].alive,"Wrong countermeasure remains MISS for both successful and failed evasion trials")
