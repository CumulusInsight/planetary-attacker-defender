extends "res://tests/prototype11_multicenter_test.gd"
func sim(delta: float) -> void:
	command.operations.session.advance(delta);await frames()
func choose(correct_count: int) -> void:
	for i in range(learning.loader.questions.size()):
		var q: Dictionary=learning.loader.questions[i]
		var answer: int=int(q.correct_defense_id) if i<correct_count else int(q.options.filter(func(d):return int(d)!=int(q.correct_defense_id))[0])
		learning.select_answer(int(q.contact_id),answer)
func projectile_rules() -> void:
	var actor:=Node2D.new();learning.add_child(actor);actor.position=Vector2(400,350)
	for correct in [true,false]:
		var p=preload("res://script/martian_projectile.gd").new();learning.add_child(p);p.setup(actor,Vector2(100,100),0,{"hit":correct,"contact_id":2,"generation":0})
		check(p.duration==18.0,"P12 duration is five times P11 flight")
		p.step(3.6);check(not p.impacted_already and p.head.distance_to(p.origin)>10,"Projectile travels during first fifth of flight")
		actor.position+=Vector2(30,20);p.step(17.999);check(not p.impacted_already,"No impact before 18 seconds")
		p.step(18.0);check(p.impacted_already and not p.evade(18.0),"Impact at 18; boundary evasion rejected")
		check(p.head.is_equal_approx(actor.global_position) if correct else p.head.distance_to(actor.global_position)>20,"Correct homing and incorrect miss preserved")
		check(p.effect_duration()==(1.95 if correct else 0.65) and p.impact_radius(1)==(180 if correct else 60),"Explosion radius/duration and miss effect unchanged")
		p.queue_free()
	var boundary=preload("res://script/martian_projectile.gd").new();learning.add_child(boundary);boundary.setup(actor,Vector2.ZERO,0,{"hit":true,"contact_id":2,"generation":0})
	check(not boundary.evade(18.0) and not boundary.impacted_already,"Evasion rejected at exact deadline even before impact callback is processed")
	check(boundary.evade(17.999) and not boundary.evade(17.999),"A valid pre-impact evasion accepts exactly once")
	boundary.queue_free();actor.queue_free();await frames()
func run() -> void:
	learning=load("res://scene/martian_learning_command.tscn").instantiate();learning.session_seed=12345;game=learning;test_viewport.add_child(learning);await frames();command=learning.command;command.set_strategic_pause(true);pointer_at(Vector2(40,140))
	var official: Dictionary=command.mission.public_snapshot();var events: Array=command.operations.session.events();var cyber: Dictionary=command.cyber.session.public_view(10)
	await press(learning.nav.analyze);await press(learning.yes_button)
	check(learning.loader.rounds.map(func(r):return r.size())==[5,5,2] and not learning.next_round_button.visible,"Original 5/5/2 plan; NEXT hidden until eligible")
	check(learning.windows.report.get_global_rect().end.y<=840,"Expanded Report fits 1600 by 900")
	var id: int=learning.loader.questions[0].contact_id;var button: Button=learning.option_buttons[id][0]
	pointer_at(button.get_global_rect().get_center());await frames()
	check(learning.hover_explanation.get_theme_font_size("font_size")==34,"Catalog definition font doubled from 17 to 34")
	var style: StyleBoxFlat=learning.definition_box.get_theme_stylebox("panel")
	check(style.border_color.r>0.9 and style.border_color.g<0.4 and style.border_width_left==3,"Definition has visible red rectangular border")
	check(learning.definition_box.visible and learning.hover_explanation.autowrap_mode==TextServer.AUTOWRAP_WORD_SMART,"Definition wraps inside stable dark box")
	var defense: int=learning.session.public_rows()[0].choices[0].id
	check(learning.hover_explanation.text==learning.loader.defenses[defense].defense_name+": "+command.decision_pages.words(learning.loader.defenses[defense].definition,23),"Definition wording remains exact existing catalog projection")
	check(learning.session.answers.is_empty() and learning.session.results.is_empty() and not learning.hover_explanation.text.contains("Correct countermeasure"),"Hover does not select or reveal answer")
	check(learning.definition_box.get_global_rect().end.y<learning.restart_button.get_global_rect().position.y,"Enlarged definition does not cover controls")
	await capture("p12_definition")
	pointer_at(Vector2(40,140));await frames();check(not learning.definition_box.visible,"Definition clears on mouse exit")
	for q in learning.loader.questions:
		for i in range(4):
			var d: int=int(q.options[i]);learning.show_explanation(learning.option_buttons[int(q.contact_id)][i],d);await frames(1)
			check(learning.hover_explanation.get_line_count()*learning.hover_explanation.get_theme_font("font").get_height(34)<=learning.hover_explanation.size.y,"Large current-round definitions fit without clipping")
	learning.clear_explanation()
	await projectile_rules();choose(3)
	learning.close_page();await press(learning.nav.decide);command.set_learning_mode(false);await press(learning.fire_buttons[0]);await create_timer(0.5).timeout
	check(learning.projectiles.size()==5 and learning.martian.incoming().size()==5 and learning.orbital_display.centers.size()==3,"Five simultaneous shots across three centers")
	check(learning.martian.visible and learning.martian.warning.visible and learning.martian.warning.text=="WARNING! WARNING! WARNING!","Automatic visible launch warning")
	check(learning.martian.alarm.playing and learning.martian.alarm.stream is AudioStreamWAV,"Single self-contained audible alarm starts")
	check(learning.martian.get_global_rect().position.x>learning.orbital_display.area.end.x,"Defense panel does not cover orbital plots")
	check(learning.martian.selector.item_count==5,"Each target and data center selectable")
	await capture("p12_multiple_incoming")
	var initial_alpha: float=learning.martian.warning.modulate.a
	var target_phase: float=0.75 if learning.martian.flash_on else 1.25
	await sim(target_phase-fmod(learning.session.now,1.0))
	check(learning.martian.warning.modulate.a!=initial_alpha and learning.martian.warning.visible,"Warning visibly alternates brightness during active simulation")
	var audio: AudioStreamWAV=learning.martian.alarm.stream
	check(audio.data.size()==22050 and audio.data.count(0)<audio.data.size() and audio.loop_mode==AudioStreamWAV.LOOP_FORWARD,"Alarm contains non-silent 16-bit generated audio and one looping buffer")
	command.set_learning_mode(true);command.set_strategic_pause(true);await frames()
	var p=learning.projectiles[0];var before: float=p.elapsed;var head: Vector2=p.head;var flash: bool=learning.martian.flash_on
	await create_timer(0.3).timeout
	check(p.elapsed==before and p.head==head and learning.martian.flash_on==flash and learning.martian.alarm.stream_paused,"Strategic pause holds flight, flash and alarm")
	await press(learning.martian.mute_button);check(learning.martian.muted and not learning.martian.alarm.playing and learning.martian.warning.visible,"MUTE silences alarm without hiding warning")
	await press(learning.martian.mute_button);check(not learning.martian.muted and learning.martian.alarm.stream_paused,"Unmute respects current pause")
	var phase: bool=learning.martian.flash_on;await sim(0.51)
	check(learning.martian.flash_on!=phase,"Warning flashes from simulation clock")
	await capture("p12_warning")
	var evaded_id: int=learning.loader.questions[0].contact_id
	var index: int=0
	# OptionButton metadata is sorted by contact, never visual row identity.
	for i in range(learning.martian.selector.item_count):
		if int(learning.martian.selector.get_item_metadata(i))==evaded_id:index=i
	learning.martian.selector.select(index);learning.martian.selector.item_selected.emit(index)
	await press(learning.martian.evade_button)
	check(p.evaded and not p.hit and learning.session.flights[evaded_id].hit,"Evasion changes trajectory, never designated answer correctness")
	check(learning.projectiles.filter(func(shot):return shot.evaded).size()==1,"One evasion affects only selected shot")
	check(learning.martian.evade_button.disabled and not learning.session.evade_shot(evaded_id,learning.session.generation),"Repeated evasion rejected")
	await capture("p12_evade")
	var first_fired: float=p.fired_at
	for shot in learning.projectiles:check(shot.fired_at==first_fired and shot.duration==18,"Volley shares launch time and slow duration")
	var remaining: float=first_fired+18-learning.session.now
	await sim(remaining-0.01);check(learning.session.results.is_empty() and learning.martian.incoming().size()==5,"No score or resolved warning before passage")
	await sim(0.02)
	check(learning.session.results.size()==5 and learning.session.metrics().correct==3 and learning.session.metrics().incorrect==2 and learning.session.metrics().percentage==60,"Cybersecurity score remains 3/2 independent of evasion")
	check(learning.session.results[evaded_id].answer_correct and learning.session.results[evaded_id].hit and learning.session.results[evaded_id].projectile_outcome=="EVADED","Correct answer plus EVADED recorded separately")
	check(learning.actor_for(evaded_id).visible and learning.orbital_display.markers[evaded_id].visible and learning.deadline_text(evaded_id)!="00:00","Evaded target survives and learning deadline remains active")
	var hits: Array=learning.session.results.values().filter(func(r):return r.projectile_outcome=="HIT")
	var misses: Array=learning.session.results.values().filter(func(r):return r.projectile_outcome=="MISS")
	check(hits.size()==2 and misses.size()==2,"Other shots retain independent hits and incorrect misses")
	for result in hits:check(learning.deadline_text(result.contact_id)=="00:00" and not learning.orbital_display.markers[result.contact_id].visible,"Only actual correct hit neutralizes learning target/time")
	check(not learning.martian.alarm.playing and not learning.martian.warning.visible and learning.martian.result_label.text.contains("EVADED"),"Warning and alarm stop after evaded projectile passes")
	for result in misses:check(learning.martian.shot_list.text.contains("Incorrect; use "+result.correct_name),"Every incorrect result retains immediate educational correct-answer feedback")
	check(learning.martian.get_children().filter(func(child):return child is AudioStreamPlayer).size()==1,"Multiple incoming shots never create overlapping alarm players")
	check(not learning.next_round_button.visible and learning.animations_active(),"NEXT remains hidden during impact effects")
	check(learning.reset_view_button.text=="RESET TO 1 DATA CENTER" and learning.reset_view_button.visible,"New reset label fits and appears for multi-center view")
	await sim(0.9);await capture("p12_explosion")
	learning.reset_view();check(learning.orbital_display.centers.size()==3 and not learning.queued_reset_center.is_empty(),"Reset request defers while effects remain")
	await sim(1.1)
	check(learning.orbital_display.centers.size()==1 and not learning.reset_view_button.visible,"Reset returns to one after all effects")
	await capture("p12_reset_single")
	await press(learning.nav.report)
	check(learning.next_round_button.visible and learning.session.round_index==0,"NEXT appears only after completed round and effects")
	await capture("p12_next_round")
	var first_results: Dictionary=learning.session.all_results.duplicate(true);var elapsed: float=learning.session.metrics().elapsed
	await press(learning.nav.analyze);await press(learning.yes_button)
	check(learning.session.round_index==0 and learning.session.all_results==first_results and learning.next_round_button.visible,"A YES cannot silently advance completed round")
	await press(learning.next_round_button)
	check(learning.session.round_index==1 and learning.loader.questions.size()==5 and learning.page=="report" and learning.session.all_results==first_results,"NEXT archives round and analyzes next five")
	check(learning.session.round_history[0].results[evaded_id].projectile_outcome=="EVADED" and learning.session.metrics().elapsed>=elapsed,"History retains separate physical outcome and cumulative time")
	learning.select_report_round(1);await frames()
	check(learning.result_cells[evaded_id].tooltip_text.contains("Projectile: EVADED"),"Historical Report exposes physical outcome without changing CORRECT grade")
	learning.show_result_details(evaded_id);check(learning.hover_explanation.text.contains("EVADED"),"Post-evaluation explanation retains evasion history")
	learning.select_report_round(0);await frames()
	# Complete second/final rounds using deterministic authoritative-clock fixtures.
	for round_index in [1,2]:
		choose(learning.loader.questions.size());learning.close_page();learning.request_fire(0);await frames()
		check(learning.martian.incoming().size()==[5,2][round_index-1],"Next-round incoming queue matches its own contacts")
		await sim(18.01);await sim(2.0);learning.show_page("report");await frames()
		check(learning.session.round_complete(),"Round completion waits for individual impact evaluation")
		if round_index==1:
			check(learning.next_round_button.visible,"Second round offers NEXT")
			await press(learning.next_round_button);check(learning.loader.questions.size()==2 and learning.session.round_index==2,"Final round has exactly two unused questions")
		else:check(not learning.next_round_button.visible and learning.session.session_complete(),"No fourth round or NEXT after final question")
	check(learning.session.all_results.size()==12 and learning.session.metrics().correct==10 and learning.session.metrics().incorrect==2,"All 12 answers retained with cumulative score")
	check(learning.report_status.text.contains("Session complete") and not learning.report_status.text.contains("A / YES"),"Final summary replaces NEXT and old footer advice")
	await capture("p12_session_complete")
	check(command.mission.public_snapshot()==official and command.operations.session.events()==events and command.cyber.session.public_view(10)==cyber,"P10 scoring, private truth/evaluator and canonical events unchanged")
	await close_game()
	await single_incoming()
	print("PROTOTYPE 12 MARTIAN DEFENSE: ","PASS" if failures==0 else "FAIL"," (",failures," failures; ",checks," checks)")
	quit(0 if failures==0 else 1)

func single_incoming() -> void:
	learning=load("res://scene/martian_learning_command.tscn").instantiate();learning.session_seed=12345;learning.participating_center_limit=1;game=learning;test_viewport.add_child(learning);await frames();command=learning.command;command.set_strategic_pause(true);learning.analyze();learning.close_page();await frames()
	var q: Dictionary=learning.loader.questions[0];var id: int=q.contact_id
	learning.select_answer(id,int(q.correct_defense_id))
	for delay in [60,300,600]:
		learning.request_fire(delay)
		check(learning.session.pending.due_at==learning.session.now+delay and learning.session.pending.shots.size()==1,"P12 preserves exact scheduled wait and immutable target snapshot")
		check(learning.session.cancel(),"P12 scheduled launch cancels without alarm")
	learning.request_fire(60);await sim(59.99)
	check(learning.martian.incoming().is_empty() and not learning.martian.visible and not learning.martian.alarm.playing,"No warning before real scheduled launch")
	await sim(0.02)
	check(learning.martian.incoming()==[id] and learning.orbital_display.centers.size()==1,"One-target incoming interface in one-center layout")
	await press(learning.martian.evade_button);await sim(18.01)
	check(learning.session.results[id].hit and learning.session.results[id].projectile_outcome=="EVADED" and learning.session.metrics().correct==1,"Single-target evasion preserves correct knowledge score")
	var scored: Dictionary=learning.session.metrics()
	check(learning.session.finish_shot(id,learning.session.generation).is_empty() and learning.session.metrics()==scored,"Duplicate callbacks cannot duplicate scores or physical outcomes")
	await sim(0.7);learning.show_page("report");await press(learning.restart_button)
	check(learning.session.all_results.is_empty() and learning.martian.records.is_empty() and not learning.martian.alarm.playing,"Restart clears learning and warning state together")
	learning.select_answer(id,int(q.correct_defense_id));learning.close_page();learning.request_fire(0);await frames()
	await press(command.decision_pages.top_buttons.threat)
	check(not learning.learning_context and not learning.martian.visible and command.decision_pages.opened.threat,"Original detailed P10 view is not covered by Martian panel")
	await press(learning.nav.decide);await press(learning.closes.decide)
	check(learning.learning_context and learning.martian.visible and learning.martian.incoming()==[id],"Returning to learning restores same incoming shot without timer reset")
	await close_game()
