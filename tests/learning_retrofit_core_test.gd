extends SceneTree
var checks:=0
var failures:=0
func check(value: bool,message: String) -> void:
	checks+=1
	if not value:failures+=1;push_error(message)
func _initialize() -> void:call_deferred("run")
func run() -> void:
	var loader=preload("res://script/rich_learning_loader.gd").new()
	check(loader.load_questions(null,"res://deliberately_missing_fixture.json").is_empty(),"Full-mode loader does not use abbreviated fixture banks")
	check(loader.rich_attacks.size()==100 and loader.rich_defenses.size()==185 and loader.rich_mappings.size()==211,"Complete rich content counts")
	check(loader.rich_attacks[1].draft_attack_id==8 and loader.rich_attacks[21].draft_attack_id==20,"Canonical IDs cannot be joined to draft numeric IDs")
	var bundle: Dictionary=loader.content.duplicate(true);var fingerprint: String=bundle.canonical_source_sha256
	check(not loader.accept_content(bundle,fingerprint,false).is_empty(),"Owner-unaccepted content blocked in production mode")
	check(loader.accept_content(bundle,fingerprint,true).is_empty(),"Review build explicitly accepts editorial candidate")
	var contacts: Array=[]
	for center in range(1,7):
		for slot in range(1,7):contacts.append({"center_id":"DC-%02d" % center,"contact_id":center*100+slot})
	check(loader.generate(20261027,contacts).is_empty() and loader.bank_size==100,"All 100 canonical attacks eligible")
	var rounds: Array=loader.rounds.duplicate(true);check(rounds.map(func(r):return r.size())==[5,5,5,5,2],"Existing 22-question five-round progression")
	loader.generate(20261027,contacts);check(rounds==loader.rounds,"Fixed seed produces identical questions and option positions")
	var covered: Dictionary={}
	for seed_number in range(40):
		check(loader.generate(seed_number,contacts).is_empty(),"Seeded selection remains valid")
		for group in loader.rounds:
			for q in group:
				covered[int(q.attack_id)]=true
				check(q.options.size()==4 and q.options.count(int(q.correct_defense_id))==1,"Exactly four distinct selected options")
				check(q.options.filter(func(d):return loader.mappings.has("%d/%d" % [q.attack_id,d])).size()==1,"No alternate valid mapped defense graded incorrect")
	check(covered.size()==100,"All 100 attacks reached across deterministic session samples")
	for mode in ["duplicate","unmapped","missing","wrong_id"]:
		var bad: Dictionary=bundle.duplicate(true)
		if mode=="duplicate":bad.attacks[0].option_defense_ids[1]=bad.attacks[0].option_defense_ids[0]
		elif mode=="unmapped":bad.attacks[0].correct_defense_id=999999
		elif mode=="missing":bad.defenses[0].limitations=""
		else:bad.reconciliation.attacks[0].canonical_id=bad.reconciliation.attacks[1].canonical_id
		check(not loader.accept_content(bad,fingerprint,true).is_empty(),"Invalid runtime content rejected: "+mode)
	loader.accept_content(bundle,fingerprint,true);loader.generate(20261027,contacts)
	var model=preload("res://script/rich_learning_session.gd").new();model.configure(loader);model.analyze(contacts)
	for q in loader.questions:model.select_answer(int(q.contact_id),int(q.options.filter(func(d):return d!=q.correct_defense_id)[0]))
	model.request_fire(-1,0)
	check(model.pending.is_empty() and model.metrics().incorrect==5,"Original correct-only grade and zero-launch behavior")
	for id in model.results:
		var status: String=model.live_status(id)
		check(status=="INCORRECT ANSWER — MISSILE NOT LAUNCHED" and not status.contains("MISSILE LAUNCHED"),"Consistent incorrect-result wording without contradictory launch")
	var target:=Node2D.new();root.add_child(target)
	for escape in [false,true]:
		for start in [0.0,30.1,1000.35]:
			var p=preload("res://script/pursuit_projectile.gd").new();root.add_child(p);target.position=Vector2(350,220)
			p.setup(target,Vector2(100,220),start,{"hit":true,"contact_id":10,"generation":0,"visual_bounds":Rect2(0,0,800,600)})
			check(p.duration==36,"Authoritative flight duration preserved")
			var impacts: Array=[];p.impacted.connect(func(id,token):impacts.append([id,token]))
			var before: Vector2=p.head
			for frame in range(1,145):
				var elapsed: float=frame*0.25;target.position=Vector2(350+elapsed*4,220)
				if escape and frame==20:p.order_evasion(start+elapsed,true)
				p.step(start+elapsed)
				check(p.head.distance_to(before)<28,"Smooth continuous missile travel; no teleport")
				check(Rect2(0,0,800,600).has_point(p.head),"Projectile stays within owning display bounds")
				if frame<144:check(not p.impacted_already,"No early physical completion")
				before=p.head
				var sample_count: int=p.samples.size();p.step(start+elapsed);check(p.samples.size()==sample_count and p.head==before,"Pause holds pursuit and fading-trail clock")
			check(impacts.size()==1 and p.impacted_already,"Exactly one completion callback")
			check(p.head.distance_to(target.global_position)>20 if escape else p.head.is_equal_approx(target.global_position),"Escape gap or successful visual contact matches assigned outcome")
			check(p.samples.size()>2,"Visible time-stamped trail samples")
			p.step(start+36.1);check(impacts.size()==1,"No repeated impact")
			p.step(start+39);check(p.samples.is_empty() and p.is_queued_for_deletion(),"Trail and effect cleanup deterministic")
	target.queue_free();await process_frame
	print("LEARNING RETROFIT CORE: ","PASS" if failures==0 else "FAIL"," (",failures," failures; ",checks," checks)");quit(0 if failures==0 else 1)
