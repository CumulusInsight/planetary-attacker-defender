extends "res://script/learning_session.gd"
## Cybersecurity correctness is retained in `hit`; physical outcome is separate.
func evade_shot(id: int,token: int) -> bool:
	if token!=generation or not flights.has(id) or results.has(id) or flights[id].get("evaded",false):return false
	flights[id].evaded=true
	return true
func finish_shot(id: int,token: int) -> Dictionary:
	var physical_id: String=flights.get(id,{}).get("physical_id",physical_slots.get(id,""))
	var evaded: bool=flights.get(id,{}).get("evaded",false)
	var result:=super.finish_shot(id,token)
	if result.is_empty():return result
	result.physical_id=physical_id
	result.answer_correct=result.hit
	result.projectile_outcome="EVADED" if evaded else "HIT" if result.hit else "MISS"
	result.learning_state="NEUTRALIZED" if result.projectile_outcome=="HIT" else "ANSWERED_EVADED" if evaded else "ANSWERED_INCORRECT"
	if physical_targets.has(physical_id):
		physical_targets[physical_id].outcome=result.projectile_outcome
		if result.projectile_outcome=="HIT":physical_targets[physical_id].alive=false
	results[id]=result.duplicate(true);all_results[result.learning_id]=result.duplicate(true)
	return result

# Persistent physical identities are independent of reused question/contact slots.
var physical_targets: Dictionary={}
var physical_slots: Dictionary={}
var question_targets: Dictionary={}
var physical_public: Array=[]
func initialize_physical(public_contacts: Array) -> void:
	if physical_public.is_empty():physical_public=public_contacts.duplicate(true)
	if physical_targets.is_empty():
		for row in physical_public:introduce_target(int(row.contact_id),row.center_id)
func introduce_target(slot: int,center: String) -> String:
	var version:=1
	while physical_targets.has("%s/C-%03d/P%02d" % [center,slot,version]):version+=1
	var identity: String="%s/C-%03d/P%02d" % [center,slot,version]
	physical_targets[identity]={"physical_id":identity,"contact_id":slot,"center_id":center,"version":version,"alive":true,"outcome":"UNANSWERED"}
	physical_slots[slot]=identity
	return identity
func bind_physical_questions() -> void:
	for q in loader.questions:
		if question_targets.has(q.get("learning_id",q.question_id)):continue
		var slot: int=q.contact_id
		var identity: String=physical_slots.get(slot,"")
		if identity.is_empty() or not physical_targets[identity].alive:identity=introduce_target(slot,q.center_id)
		question_targets[q.get("learning_id",q.question_id)]=identity
func analyze(public_rows: Array) -> bool:
	if not super.analyze(public_rows):return false
	initialize_physical(public_rows)
	# Reopening analysis must never replace a destroyed target in the same question.
	for q in loader.questions:
		if not question_targets.has(q.get("learning_id",q.question_id)):
			bind_physical_questions();break
	return true
func request_fire(id: int,delay: int) -> Dictionary:
	var response:=super.request_fire(id,delay)
	if response.ok:
		for shot in pending.shots:shot.physical_id=question_targets.get(shot.learning_id,"")
	return response
func begin_volley() -> Array:
	var shots:=super.begin_volley()
	for shot in shots:
		shot.physical_id=shot.get("physical_id",question_targets.get(shot.learning_id,""))
		flights[int(shot.contact_id)].physical_id=shot.physical_id
	return shots
func advance_round(public_contacts: Array,display_times: Dictionary={}) -> bool:
	if not super.advance_round(public_contacts,display_times):return false
	initialize_physical(public_contacts);bind_physical_questions()
	return true
func reset() -> void:
	super.reset()
	physical_targets.clear();physical_slots.clear();question_targets.clear()
	if not physical_public.is_empty():initialize_physical(physical_public);bind_physical_questions()
