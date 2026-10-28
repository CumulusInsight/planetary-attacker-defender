extends SceneTree
var checks:=0
var failures:=0
func check(value: bool,message: String) -> void:
	checks+=1
	if not value:failures+=1;push_error(message)
func _initialize() -> void:call_deferred("run")
func run() -> void:
	var loader=preload("res://script/rich_learning_loader.gd").new();check(loader.load_questions(null).is_empty(),"Existing rich catalog valid")
	var contacts: Array=[]
	for center in range(1,7):
		for slot in range(1,7):contacts.append({"center_id":"DC-%02d" % center,"contact_id":center*100+slot})
	loader.generate(9911,contacts)
	for delay in [0,60,300,600]:
		var model=preload("res://script/player_fire_session.gd").new();model.configure(loader);model.analyze(contacts)
		for q in loader.questions:model.select_answer(q.contact_id,q.correct_defense_id)
		check(model.submit_answers(delay).ok,"Existing authority accepts five correct answers")
		var queue: Dictionary=model.pending.duplicate(true);var rng: int=model.evasion_rng.state;var answers: Dictionary=model.answers.duplicate(true)
		check(model.set_firing_mode("PLAYER FIRE") and model.pending==queue,"AUTO to PLAYER preserves every pending field")
		check(model.begin_volley().is_empty(),"Manual mode cannot automatically drain queue")
		if delay>0:
			model.advance(delay-0.001);model.set_firing_mode("AUTO-FIRE");check(model.begin_volley().is_empty(),"Switch cannot bypass WAIT")
		model.advance(delay);model.set_firing_mode("AUTO-FIRE")
		var first: Array=model.begin_volley();check(first.size()==1 and model.claim_launch(first[0]),"One automatic launch at readiness")
		var id: int=first[0].contact_id
		check(model.evade_all().size()==1,"Existing evasion order accepted")
		rng=model.evasion_rng.state
		var flight: Dictionary=model.flights[id].duplicate(true)
		check(model.set_firing_mode("PLAYER FIRE") and model.flights[id]==flight,"Airborne shot unchanged during switch")
		check(model.authorized_targets().size()==4,"All remaining authorizations transferred")
		model.advance(delay+14.999);model.set_firing_mode("AUTO-FIRE");check(model.begin_volley().is_empty(),"No premature launch at 14.999 seconds")
		model.advance(delay+15);var second: Array=model.begin_volley();check(second.size()==1 and model.claim_launch(second[0]),"15-second automatic spacing after manual interval")
		model.set_firing_mode("PLAYER FIRE");model.advance(delay+100)
		var next: int=model.authorized_targets()[0].contact_id;var manual: Array=model.fire_authorized(next);check(manual.size()==1 and model.claim_launch(manual[0]),"Overdue manual authorization consumed once")
		model.set_firing_mode("AUTO-FIRE");check(model.begin_volley().is_empty(),"Overdue AUTO transition cannot launch alongside manual shot")
		model.advance(delay+115);var fourth: Array=model.begin_volley();check(fourth.size()==1 and model.claim_launch(fourth[0]),"Overdue queue resumes 15 seconds after actual launch")
		model.advance(delay+130);var fifth: Array=model.begin_volley();check(fifth.size()==1 and model.claim_launch(fifth[0]),"Final authorization retained")
		check(model.pending.is_empty() and model.begin_volley().is_empty() and model.flights.size()==5,"No lost or duplicate missile")
		check(model.answers==answers and model.evasion_rng.state==rng,"Mode transitions cannot change answers or evasion RNG")
		model.advance(delay+166)
		for key in model.flights.keys():model.finish_shot(key,model.generation)
		check(model.metrics().correct==5 and model.metrics().incorrect==0,"Exactly five correct grades")
	print("MODE TRANSFER: ","PASS" if failures==0 else "FAIL"," (",failures," failures; ",checks," checks)");quit(0 if failures==0 else 1)
