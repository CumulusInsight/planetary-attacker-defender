extends SceneTree
var checks:=0
var failures:=0
func check(value: bool,message: String) -> void:
	checks+=1
	if not value:failures+=1;push_error(message)
func _initialize() -> void:call_deferred("run")
func run() -> void:
	var loader=preload("res://script/rich_learning_loader.gd").new();check(loader.load_questions(null).is_empty(),"Validated rich catalog")
	var contacts: Array=[]
	for center in range(1,7):
		for slot in range(1,7):contacts.append({"center_id":"DC-%02d" % center,"contact_id":center*100+slot})
	check(loader.generate(331,contacts).is_empty(),"Seeded validated question generation")
	# Isolated fixture: five existing DC-01 slots exercise multiple arrivals per center.
	for group in loader.rounds:
		for i in range(group.size()):group[i].center_id="DC-01";group[i].contact_id=101+i
	loader.activate_round(0)
	var session=preload("res://script/player_fire_session.gd").new();session.configure(loader);session.analyze(contacts)
	# Select a controlled RNG seed with multiple successes and at least one failure.
	var seed_value:=0;var probe:=RandomNumberGenerator.new()
	for candidate in range(100):
		probe.seed=candidate;var success:=0
		for i in range(5):
			if probe.randf()<0.5:success+=1
		if success>=2 and success<5:seed_value=candidate;break
	session.evasion_rng.seed=seed_value
	for q in loader.questions:session.select_answer(q.contact_id,q.correct_defense_id)
	check(session.submit_answers().ok,"Five correct authorizations")
	var flights: Array=[]
	for i in range(5):
		session.advance(i*15);var shots: Array=session.begin_volley();check(shots.size()==1 and session.claim_launch(shots[0]),"Existing stagger/claim authority")
		check(session.evade_shot(shots[0].contact_id,session.generation),"Existing Bernoulli evasion order")
		flights.append(shots[0].contact_id)
	check(session.internal_threats.is_empty(),"No record for attempt or airborne success roll")
	session.advance(96);var evaded:=0
	for id in flights:
		var result: Dictionary=session.finish_shot(id,session.generation)
		if result.projectile_outcome=="EVADED":
			evaded+=1;check(session.internal_threats.has(result.physical_id),"Confirmed EVADED registry entry")
			var row: Dictionary=session.internal_threats[result.physical_id]
			check(row.center_id=="DC-01" and row.source_outcome=="EVADED" and row.state=="ARRIVED_INTERNAL" and not row.compromise_confirmed,"Explicit arrival-only state contract")
			check(loader.attacks.has(row.learning_attack_id) and loader.attacks[row.learning_attack_id].attack_name==row.learning_attack_name,"Catalog identity retained as learning provenance")
		else:check(not session.internal_threats.has(result.physical_id),"No HIT entry")
	check(evaded>=2 and session.internal_for_center("DC-01").size()==evaded,"Multiple independent arrivals in same center")
	var saved: Dictionary=session.internal_threats.duplicate(true)
	var copy: Array=session.internal_for_center("DC-01");copy[0].center_id="DC-99"
	check(session.internal_threats==saved,"Query returns defensive copies")
	for id in flights:check(session.finish_shot(id,session.generation).is_empty(),"No duplicate outcome")
	check(session.metrics().correct==5 and session.metrics().incorrect==0,"Arrival flags do not change grades")
	session.set_firing_mode("PLAYER FIRE");session.set_firing_mode("AUTO-FIRE");session.advance_round(contacts)
	check(session.internal_threats==saved,"Round and mode changes preserve stable identities")
	session.public_rows(0);check(session.internal_threats==saved,"Historical projection cannot mutate arrivals")
	var survivor: Dictionary=saved.values()[0];var survivor_id: int=survivor.contact_id
	session.select_answer(survivor_id,session.question(survivor_id).correct_defense_id)
	check(session.submit_answers().ok,"Reused surviving contact can answer a new question")
	var repeat: Array=session.begin_volley();check(repeat.size()==1 and session.claim_launch(repeat[0]),"Existing survivor launch authority")
	for candidate in range(100):
		probe.seed=candidate
		if probe.randf()<0.5:session.evasion_rng.seed=candidate;break
	session.evade_shot(survivor_id,session.generation);session.advance(session.now+36)
	check(session.finish_shot(survivor_id,session.generation).projectile_outcome=="EVADED","Second authoritative evasion by same physical target")
	check(session.internal_threats==saved,"Repeated evasion retains immutable first arrival, never duplicates identity")
	session.reset();check(session.internal_threats.is_empty(),"Explicit reset lifecycle")
	print("INTERNAL ARRIVAL: ","PASS" if failures==0 else "FAIL"," (",failures," failures; ",checks," checks)");quit(0 if failures==0 else 1)
