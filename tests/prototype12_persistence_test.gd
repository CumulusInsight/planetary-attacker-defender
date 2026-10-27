extends "res://tests/prototype12_test.gd"
func assert_environment(dead: Array,survivors: Array) -> void:
	for identity in dead:check(not learning.session.physical_targets[identity].alive,"Destroyed physical identity remains destroyed: "+identity)
	for identity in survivors:check(learning.session.physical_targets[identity].alive,"Surviving physical identity retained: "+identity)
	for slot in learning.orbital_display.markers:
		var marker=learning.orbital_display.markers[slot]
		var identity: String=marker.get_meta("physical_id","")
		if not identity.is_empty():check(marker.visible==(learning.session.physical_targets[identity].alive and learning.session.physical_targets[identity].center_id in learning.orbital_display.centers),"Visible projection matches physical registry")
func run() -> void:
	learning=load("res://scene/martian_learning_command.tscn").instantiate();learning.session_seed=12345;game=learning;test_viewport.add_child(learning);await frames();command=learning.command;command.set_strategic_pause(true);pointer_at(Vector2(40,140));await open_report()
	var official: Dictionary=command.mission.public_snapshot();var events: Array=command.operations.session.events()
	check(learning.session.physical_targets.size()==18,"Initial physical environment includes all 18 canonical slots without changing them")
	var initial_ids: Array=learning.session.physical_targets.keys()
	learning.close_page();await frames();await capture("p12_persistent_round1_before");learning.show_page("report");await frames()
	var attack: Button=learning.report_grid.get_child(11)
	var first: Dictionary=learning.loader.questions.filter(func(q):return q.learning_id==learning.report_order[0])[0]
	pointer_at(attack.get_global_rect().get_center());await frames()
	var expected: String=learning.loader.attacks[int(first.attack_id)].attack_name+"\n"+learning.loader.attacks[int(first.attack_id)].definition
	check(learning.hover_explanation.text==expected,"Attack hover shows exact catalog definition field, not a fabricated expansion")
	check(learning.hover_explanation.get_theme_font_size("font_size")==34 and learning.definition_box.visible,"Attack uses shared 34-pixel red-bordered box")
	check(learning.session.answers.is_empty() and learning.session.results.is_empty() and not expected.contains("Correct countermeasure"),"Attack explanation never selects or discloses the answer key")
	await capture("p12_attack_definition")
	pointer_at(Vector2(40,140));await frames();check(not learning.definition_box.visible,"Attack hover clears on exit")
	await press(attack);check(learning.hover_explanation.text==expected,"Attack click also opens authoritative description")
	var id: int=first.contact_id;var control: Button=learning.option_buttons[id][0];pointer_at(control.get_global_rect().get_center());await frames()
	check(learning.hover_explanation.text.contains(learning.loader.defenses[int(first.options[0])].defense_name),"Countermeasure hover still uses existing defense source")
	await capture("p12_countermeasure_definition")
	# Validate every available catalog definition and the missing-field fallback without modifying the catalog.
	for key in learning.loader.attacks:
		learning.show_attack_explanation(attack,int(key))
		check(learning.hover_explanation.text==learning.loader.attacks[key].attack_name+"\n"+learning.loader.attacks[key].definition,"All catalog attack definitions preserve exact wording")
	learning.show_attack_explanation(attack,-1);check(learning.hover_explanation.text.contains("No description available in the current catalog."),"Missing attack definition has neutral fallback")
	learning.clear_explanation();choose(3);learning.close_page();learning.request_fire(0);await frames()
	var evaded: int=learning.loader.questions[0].contact_id
	check(learning.session.evade_shot(evaded,learning.session.generation) and learning.projectiles[0].evade(learning.session.now),"Independent evasion keeps correct cybersecurity grading")
	await sim(18.01);await sim(2.0)
	var dead: Array=[];var survivors: Array=[]
	for result in learning.session.results.values():
		check(not result.physical_id.is_empty() and learning.session.question_targets[result.learning_id]==result.physical_id,"Result binds question identity to captured physical identity")
		if result.projectile_outcome=="HIT":dead.append(result.physical_id)
		else:survivors.append(result.physical_id)
	check(dead.size()==2 and survivors.size()==3,"Mixed HIT/MISS/EVADED physical outcomes retained independently")
	assert_environment(dead,survivors);await capture("p12_persistent_round1_after")
	var archived_registry: Dictionary=learning.session.physical_targets.duplicate(true)
	learning.show_page("report");await press(learning.next_round_button);learning.close_page();await frames()
	assert_environment(dead,survivors)
	for q in learning.loader.questions:check(learning.session.physical_targets[learning.session.question_targets[q.learning_id]].alive,"Every new-round question has a live physical target")
	check(learning.session.round_index==1 and learning.session.metrics().correct==3 and learning.session.metrics().incorrect==2,"Round two preserves cumulative mixed results")
	learning.orbital_display.layout_centers(["DC-01","DC-02","DC-03"]);await frames();await capture("p12_persistent_round2")
	for centers in [["DC-01"],["DC-01","DC-02"],["DC-01","DC-02","DC-03"]]:
		learning.orbital_display.layout_centers(centers);await frames();assert_environment(dead,survivors)
	learning.explicit_center="DC-02";learning.reset_view();await frames();check(learning.orbital_display.centers==["DC-02"],"Manual reset changes presentation only");assert_environment(dead,survivors)
	var before: Dictionary=learning.session.physical_targets.duplicate(true)
	learning.select_report_round(1);learning.show_page("report");await frames();check(learning.session.physical_targets==before,"Historical Report never modifies physical state")
	learning.select_report_round(0);learning.close_page();choose(5);learning.request_fire(0);await frames();await sim(18.01);await sim(2.0)
	for result in learning.session.results.values():dead.append(result.physical_id)
	learning.show_page("report");await press(learning.next_round_button);learning.close_page();await frames();check(learning.orbital_display.centers==["DC-01","DC-02","DC-03"],"Later-round layout retains previously participating centers and their survivors")
	# Previously surviving targets can legitimately be hit by a later question; no earlier HIT can revive.
	assert_environment(dead,[]);check(learning.session.round_index==2 and learning.loader.questions.size()==2,"Round three retains accumulated physical state and 5/5/2 progression")
	await capture("p12_persistent_round3")
	check(command.mission.public_snapshot()==official and command.operations.session.events()==events,"Physical registry does not alter P10 official scoring or canonical events")
	learning.restart_learning();await frames();check(learning.session.physical_targets.keys()==initial_ids and learning.session.physical_targets.values().all(func(t):return t.alive and t.outcome=="UNANSWERED"),"Explicit restart alone restores initial physical environment")
	await close_game()
	await forced_slot_reuse()
	print("PROTOTYPE 12 PERSISTENCE: ","PASS" if failures==0 else "FAIL"," (",failures," failures; ",checks," checks)");quit(0 if failures==0 else 1)
func forced_slot_reuse() -> void:
	learning=load("res://scene/martian_learning_command.tscn").instantiate();learning.session_seed=12345;learning.participating_center_limit=1;game=learning;test_viewport.add_child(learning);await frames();command=learning.command;command.set_strategic_pause(true);learning.analyze();learning.close_page();choose(2);learning.request_fire(0);await frames();await sim(18.01);await sim(2.0)
	var old_slots: Dictionary=learning.session.physical_slots.duplicate(true)
	var previous: Dictionary=learning.session.results.duplicate(true)
	learning.next_round();learning.close_page();await frames()
	for slot in previous:
		var old_id: String=old_slots[slot];var new_id: String=learning.session.physical_slots[slot]
		if previous[slot].projectile_outcome=="HIT":
			check(old_id!=new_id and not learning.session.physical_targets[old_id].alive and learning.session.physical_targets[new_id].alive,"Reused destroyed slot introduces a new stable physical target; old identity never resurrects")
			check(learning.orbital_display.markers[slot].get_meta("physical_id")==new_id,"New visible marker identifies replacement, not destroyed identity")
		else:check(old_id==new_id and learning.session.physical_targets[old_id].outcome=="MISS","Slot reuse keeps survivor identity and its physical survival history")
	check(learning.session.physical_targets.size()==20,"Exactly two replacements introduced; survivors were not deleted")
	check(learning.session.round_history[0].results==previous,"Archived question results retain original physical identities")
	await close_game()
