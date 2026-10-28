extends SceneTree
var checks:=0
var failures:=0
func check(value: bool,message: String) -> void:
	checks+=1
	if not value:failures+=1;push_error(message)
func _initialize() -> void:call_deferred("run")
func wrong(q: Dictionary) -> int:return q.options.filter(func(d):return d!=q.correct_defense_id)[0]
func run() -> void:
	var loader=preload("res://script/rich_learning_loader.gd").new();check(loader.load_questions(null).is_empty(),"Validated existing lessons")
	var contacts: Array=[]
	for center in range(1,7):
		for slot in range(1,7):contacts.append({"center_id":"DC-%02d" % center,"contact_id":center*100+slot})
	check(loader.generate(8801,contacts).is_empty(),"Seeded 22-question session")
	# Fixture exercises several distinct physical threats assigned to the same center.
	for i in range(3):loader.rounds[0][i].center_id="DC-01";loader.rounds[0][i].contact_id=101+i
	loader.activate_round(0)
	var model=preload("res://script/player_fire_session.gd").new();model.configure(loader);model.analyze(contacts)
	check(model.internal_threats.is_empty(),"Unanswered questions create no arrivals")
	for i in range(2):model.select_answer(loader.questions[i].contact_id,wrong(loader.questions[i]))
	var rng: int=model.evasion_rng.state;var response: Dictionary=model.submit_answers()
	check(response.ok and response.incorrect==2 and response.scheduled==0,"Two wrong selections evaluated without missiles")
	check(model.pending.is_empty() and model.flights.is_empty() and model.evasion_rng.state==rng,"No queue, airborne shot or RNG draw")
	check(model.internal_for_center("DC-01").size()==2,"Independent same-center unopposed arrivals")
	for r in model.results.values():
		var entry: Dictionary=model.internal_threats[r.physical_id]
		check(entry.arrival_cause=="UNOPPOSED_ARRIVAL" and entry.source_outcome=="NOT LAUNCHED" and entry.center_id==r.center_id and not entry.compromise_confirmed,"Unopposed cause with original provenance and no compromise")
	var saved: Dictionary=model.internal_threats.duplicate(true)
	for r in model.results.values():model.record_incorrect(r.contact_id,r.answer)
	check(model.internal_threats==saved and model.metrics().incorrect==2,"Repeated callbacks cannot replace first arrival or double grade")
	var pending: Dictionary=loader.questions[2];model.select_answer(pending.contact_id,pending.correct_defense_id);model.set_firing_mode("PLAYER FIRE");check(model.submit_answers(60).ok,"Correct manual WAIT authorization")
	var key: String=model.question_targets[pending.learning_id]
	check(not model.internal_threats.has(key),"Correct pending authorization creates no arrival")
	model.advance(60);var shot: Array=model.fire_authorized(pending.contact_id);check(shot.size()==1 and model.claim_launch(shot[0]),"Same launch authority and WAIT readiness")
	check(not model.internal_threats.has(key),"Airborne missile creates no arrival")
	model.advance(96);var hit: Dictionary=model.finish_shot(pending.contact_id,model.generation)
	check(hit.projectile_outcome=="HIT" and not model.internal_threats.has(key),"HIT creates no arrival")
	for q in loader.questions:
		if not model.results.has(q.contact_id):model.select_answer(q.contact_id,wrong(q))
	check(model.submit_answers().ok,"Remaining partial submission")
	check(model.internal_threats.values().any(func(r):return r.center_id!="DC-01"),"Correct separate centers for additional arrivals")
	for round_number in range(1,5):
		var before: Dictionary=model.internal_threats.duplicate(true)
		check(model.advance_round(contacts),"Round progression unchanged")
		for identity in before:check(model.internal_threats[identity]==before[identity],"First arrivals survive next round")
		for q in loader.questions:model.select_answer(q.contact_id,wrong(q))
		check(model.submit_answers().ok and model.pending.is_empty() and model.flights.is_empty(),"Incorrect-only round remains non-firing")
	check(model.session_complete() and model.all_results.size()==22 and model.metrics().correct==1 and model.metrics().incorrect==21,"All 22 evaluated with original scores")
	var unique_wrong_targets: Dictionary={}
	for result in model.all_results.values():
		if not result.answer_correct:unique_wrong_targets[result.physical_id]=true
	check(model.internal_threats.size()==unique_wrong_targets.size() and model.evasion_rng.state==rng,"Unique physical arrivals persist to completion without evasion draws")
	saved=model.internal_threats.duplicate(true);var original: Dictionary=model.metrics().duplicate(true);var history: Dictionary=model.all_results.duplicate(true)
	model.set_firing_mode("AUTO-FIRE");model.set_firing_mode("PLAYER FIRE");model.public_rows(0)
	var review=model.start_review();check(review!=null,"Existing noncombat review available")
	for q in review.questions:check(review.evaluate(q.learning_id,wrong(q)),"Review accepts incorrect retry without combat")
	check(model.internal_threats==saved and model.all_results==history and model.metrics()==original and model.pending.is_empty() and model.flights.is_empty(),"Review, modes and history cannot create arrivals or change original score")
	var evader=preload("res://script/player_fire_session.gd").new();evader.configure(loader);evader.analyze(contacts)
	var q: Dictionary=loader.questions[0];evader.select_answer(q.contact_id,q.correct_defense_id);evader.submit_answers()
	var launch: Array=evader.begin_volley();check(launch.size()==1 and evader.claim_launch(launch[0]),"Evasion case uses existing launch authority")
	var probe:=RandomNumberGenerator.new()
	for seed_number in range(100):
		probe.seed=seed_number
		if probe.randf()<0.5:evader.evasion_rng.seed=seed_number;break
	evader.evade_shot(q.contact_id,evader.generation);check(evader.internal_threats.is_empty(),"Successful airborne evasion roll is not yet an arrival")
	evader.advance(36);var outcome: Dictionary=evader.finish_shot(q.contact_id,evader.generation)
	var arrival: Dictionary=evader.internal_threats[outcome.physical_id].duplicate(true)
	check(arrival.arrival_cause=="EVADED_INTERCEPTION" and arrival.source_outcome=="EVADED","Preserved evasion path has distinct cause")
	evader.record_incorrect(q.contact_id,wrong(q));check(evader.internal_threats[outcome.physical_id]==arrival and evader.metrics().correct==1 and evader.metrics().incorrect==0,"Late repeated incorrect callback cannot overwrite first arrival or original grade")
	print("UNOPPOSED ARRIVAL: ","PASS" if failures==0 else "FAIL"," (",failures," failures; ",checks," checks)");quit(0 if failures==0 else 1)
