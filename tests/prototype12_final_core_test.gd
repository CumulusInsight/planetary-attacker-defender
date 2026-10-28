extends SceneTree
var checks:=0
var failures:=0
func check(value: bool,message: String) -> void:
	checks+=1
	if not value:failures+=1;push_error(message)
func _initialize() -> void:call_deferred("run")
func run() -> void:
	var loader=preload("res://script/rich_learning_loader.gd").new();check(loader.load_questions(null).is_empty(),"Catalog rich data load")
	var contacts: Array=[]
	for center in range(1,7):
		for slot in range(1,7):contacts.append({"center_id":"DC-%02d" % center,"contact_id":center*100+slot})
	loader.generate(20261028,contacts)
	for delay in [0,60,300,600]:
		var model=preload("res://script/player_fire_session.gd").new();model.configure(loader)
		check(model.firing_mode=="AUTO-FIRE" and model.set_firing_mode("PLAYER FIRE"),"AUTO default and safe initial mode switch")
		model.analyze(contacts)
		for i in range(5):
			var q: Dictionary=loader.questions[i];model.select_answer(q.contact_id,int(q.correct_defense_id) if i<3 else int(q.options.filter(func(d):return d!=q.correct_defense_id)[0]))
		var rng_state: int=model.evasion_rng.state;var response: Dictionary=model.submit_answers(delay)
		check(response.ok and response.scheduled==3 and response.incorrect==2 and model.authorized_targets().size()==3,"Only correct responses authorize manual missiles")
		check(model.results.size()==2 and model.flights.is_empty() and model.evasion_rng.state==rng_state,"Authorization does not fire, grade correct answers or draw RNG")
		check(model.set_firing_mode("AUTO-FIRE") and model.set_firing_mode("PLAYER FIRE") and not model.submit_answers().ok,"Switch modes without duplicating an active authorization batch")
		var ids: Array=model.authorized_targets().map(func(s):return int(s.contact_id))
		check(model.fire_authorized(999999).is_empty(),"Cannot redirect to unrelated target")
		if delay>0:
			model.advance(delay-0.001);check(model.fire_authorized(ids[0]).is_empty(),"WAIT cannot be bypassed manually")
		model.advance(delay+100);check(model.begin_volley().is_empty() and model.flights.is_empty(),"No silent automatic firing even when overdue")
		var shots: Array=model.fire_authorized(ids[0]);check(shots.size()==1 and shots[0].contact_id==ids[0] and model.claim_launch(shots[0]),"Explicit player action drains exactly one validated slot")
		check(model.fire_authorized(ids[0]).is_empty() and not model.claim_launch(shots[0]),"No duplicate firing or claim")
		check(model.fire_authorized(ids[1]).is_empty(),"Actual-launch 15-second spacing remains enforced")
		model.advance(delay+114.999);check(model.fire_authorized(ids[1]).is_empty(),"No early next launch")
		model.advance(delay+115);var second: Array=model.fire_authorized(ids[1]);check(second.size()==1 and model.claim_launch(second[0]),"Second manual missile at earliest 15-second boundary")
		model.advance(delay+130);var third: Array=model.fire_authorized(ids[2]);check(third.size()==1 and model.claim_launch(third[0]) and model.authorized_targets().is_empty(),"Independent final authorization consumed once")
		check(model.mode_switch_allowed() and not model.advance_round(contacts),"Flight permits mode switch but blocks round progression")
		check(model.finish_shot(ids[0],model.generation).is_empty(),"No result before 36-second flight")
		model.advance(delay+136);check(not model.finish_shot(ids[0],model.generation).is_empty(),"First manual shot grades at 36 seconds")
		model.advance(delay+151);model.finish_shot(ids[1],model.generation);model.advance(delay+166);model.finish_shot(ids[2],model.generation)
		check(model.metrics().correct==3 and model.metrics().incorrect==2 and model.round_complete(),"Manual firing preserves grading and physical authority")
		check(model.set_firing_mode("AUTO-FIRE"),"Mode switch allowed at completed idle boundary")
		model.reset();check(model.pending.is_empty() and model.flights.is_empty() and model.authorized_targets().is_empty(),"Restart clears authorization safely")
	var full=preload("res://script/player_fire_session.gd").new();full.configure(loader);full.set_firing_mode("PLAYER FIRE");full.analyze(contacts)
	var first_physical: String=""
	for round_number in range(5):
		for q in loader.questions:full.select_answer(int(q.contact_id),int(q.correct_defense_id))
		check(full.submit_answers().ok,"Manual round accepts correct selected subset")
		while not full.pending.is_empty():
			var shot_id: int=full.authorized_targets()[0].contact_id;full.advance(maxf(full.now,float(full.ready_at(shot_id))))
			check(full.begin_volley().is_empty(),"All manual rounds remain nonautomatic")
			var shots: Array=full.fire_authorized(shot_id);check(shots.size()==1 and full.claim_launch(shots[0]),"Manual authorization consumed through inherited authority")
		full.advance(full.now+36)
		for shot_id in full.flights.keys():full.finish_shot(shot_id,full.generation)
		if round_number==0:first_physical=full.all_results.values()[0].physical_id
		check(not full.physical_targets[first_physical].alive,"HIT physical target remains removed in later manual rounds")
		if round_number<4:check(full.advance_round(contacts),"Manual completed round advances without resetting score")
	check(full.all_results.size()==22 and full.metrics().correct==22 and full.session_complete(),"Full manual 5/5/5/5/2 session preserves cumulative grading and completion")
	var projectile=preload("res://script/pursuit_projectile.gd").new();var target:=Node2D.new();root.add_child(target);root.add_child(projectile);target.position=Vector2(400,200)
	projectile.setup(target,Vector2(100,200),0,{"hit":true,"contact_id":1,"generation":0})
	for i in range(1,81):projectile.step(i*0.25)
	check(projectile.TRAIL_SECONDS==40 and projectile.samples[0].time<5,"Trail retention increased fivefold from eight seconds")
	var head: Vector2=projectile.head;var pulse: float=projectile.trail_pulse();projectile.step(20)
	check(projectile.head==head and projectile.trail_pulse()==pulse,"Pause holds trail and pulse simulation phase")
	projectile.step(20.1);check(not is_equal_approx(projectile.trail_pulse(),pulse),"Trail pulse visibly varies as simulation advances")
	projectile.step(36);projectile.step(39);check(projectile.samples.is_empty(),"Extended trail cleans up after impact")
	target.queue_free();await process_frame
	print("FINAL ENHANCEMENTS CORE: ","PASS" if failures==0 else "FAIL"," (",failures," failures; ",checks," checks)");quit(0 if failures==0 else 1)
