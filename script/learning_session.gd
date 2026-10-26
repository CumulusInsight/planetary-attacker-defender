extends RefCounted
## Isolated learning session. No scene, operational evaluator, scoring or private-fixture access.
var loader: RefCounted
var analyzed:=false
var focused:=-1
var answers:={}
var results:={}
var pending:={}
var flights:={}
# Single-shot compatibility view for existing regression clients.
var _flight: Dictionary:
	get:return flights.values()[0] if flights.size()==1 else {}
var started_at: Variant=null
var now:=0.0
var generation:=0
var learning_deadlines:={}
var all_results:={}
var round_history: Array=[]
var round_index:=0
func configure(source: RefCounted) -> void:
	loader=source;round_index=0
	if not loader.rounds.is_empty():loader.activate_round(0)
func analyze(public_rows: Array) -> bool:
	for q in loader.questions:
		if not public_rows.any(func(r):return int(r.contact_id)==int(q.contact_id) and r.center_id==q.center_id):return false
	if not analyzed:
		started_at=now;capture_learning_deadlines()
	analyzed=true
	if focused<0:focused=int(loader.questions[0].contact_id)
	return true
func question(id: int) -> Dictionary:
	for q in loader.questions:
		if int(q.contact_id)==id:return q
	return {}
func select_answer(id: int,defense: int) -> bool:
	var q:=question(id)
	if not analyzed or q.is_empty() or results.has(id) or not q.options.any(func(n):return int(n)==defense):return false
	if flights.has(id):return false
	answers[id]=defense;focused=id;return true
func eligible() -> Array:
	var ids: Array=[]
	for q in loader.questions:
		var id: int=q.contact_id
		if answers.has(id) and not results.has(id) and not flights.has(id) and not is_pending(id):ids.append(id)
	return ids
func is_pending(id: int) -> bool:
	return not pending.is_empty() and pending.shots.any(func(s):return s.contact_id==id)
func request_fire(_id: int,delay: int) -> Dictionary:
	var ids:=eligible()
	if not analyzed or ids.is_empty():return {"ok":false,"error":"Select a countermeasure in Report first."}
	if delay not in [0,60,300,600] or not pending.is_empty() or in_flight():return {"ok":false,"error":"A volley is pending or in flight. Cancel or wait for its results."}
	var shots: Array=[]
	for id in ids:shots.append({"contact_id":id,"defense_id":answers[id],"generation":generation,"learning_id":question(id).get("learning_id",question(id).question_id),"late_practice":learning_remaining(id)!=null and learning_remaining(id)<=0})
	pending={"shots":shots,"due_at":now+delay,"generation":generation}
	# Preserve the single-target countdown wording/API.
	if shots.size()==1:pending.merge(shots[0])
	return {"ok":true,"error":""}
func advance(clock: float) -> void:
	if is_finite(clock) and clock>=now:now=clock
func countdown() -> Variant:return null if pending.is_empty() else maxf(0,pending.due_at-now)
func cancel() -> bool:
	if pending.is_empty():return false
	pending.clear();return true
func begin_volley() -> Array:
	if pending.is_empty() or now<pending.due_at:return []
	var shots: Array=pending.shots.duplicate(true);pending.clear()
	for shot in shots:
		shot.late_practice=learning_remaining(int(shot.contact_id))!=null and learning_remaining(int(shot.contact_id))<=0
		shot.hit=int(shot.defense_id)==int(question(int(shot.contact_id)).correct_defense_id)
		flights[int(shot.contact_id)]=shot
	if shots.size()==1:focused=int(shots[0].contact_id)
	return shots
func begin_due() -> Dictionary:
	var shots:=begin_volley()
	return {} if shots.is_empty() else shots[0]
func in_flight() -> bool:return not flights.is_empty()
func finish_shot(id: int,token: int) -> Dictionary:
	if not flights.has(id) or token!=generation or results.has(id):return {}
	var shot: Dictionary=flights[id]
	var q:=question(id)
	var result: Dictionary={"learning_id":q.get("learning_id",q.question_id),"question_id":q.question_id,"round_number":round_index+1,"center_id":q.center_id,"contact_id":id,"hit":shot.hit,"answer":shot.defense_id,"correct_name":loader.defenses[int(q.correct_defense_id)].defense_name,"correct_id":int(q.correct_defense_id),"attack_name":loader.attacks[int(q.attack_id)].attack_name,"simulation_time":now,"late_practice":shot.get("late_practice",false)}
	result.learning_state="NEUTRALIZED" if shot.hit else "ANSWERED_INCORRECT"
	results[id]=result;all_results[result.learning_id]=result.duplicate(true);answers[id]=int(shot.defense_id);flights.erase(id);return result.duplicate(true)
func reset() -> void:
	generation+=1;answers.clear();results.clear();all_results.clear();round_history.clear();round_index=0
	if not loader.rounds.is_empty():loader.activate_round(0)
	pending.clear();flights.clear();started_at=now if analyzed else null
	focused=int(loader.questions[0].contact_id) if analyzed else -1
	if analyzed:capture_learning_deadlines()
func metrics() -> Dictionary:
	var correct:=0
	for r in all_results.values():
		if r.hit:correct+=1
	return {"correct":correct,"incorrect":all_results.size()-correct,"percentage":0.0 if all_results.is_empty() else 100.0*correct/all_results.size(),"elapsed":0.0 if started_at==null else maxf(0,now-started_at)}
func round_complete() -> bool:
	return analyzed and not loader.questions.is_empty() and results.size()==loader.questions.size()
func has_next_round() -> bool:return round_index+1<loader.rounds.size()
func session_complete() -> bool:return round_complete() and not has_next_round()
func advance_round(public_contacts: Array,display_times: Dictionary={}) -> bool:
	if not round_complete() or not has_next_round() or in_flight() or not pending.is_empty():return false
	var next: Array=loader.rounds[round_index+1]
	for q in next:
		if not public_contacts.any(func(r):return int(r.contact_id)==int(q.contact_id) and r.center_id==q.center_id):return false
	round_history.append({"round_number":round_index+1,"questions":loader.questions.duplicate(true),"answers":answers.duplicate(true),"results":results.duplicate(true),"times":display_times.duplicate(true)})
	round_index+=1;generation+=1;loader.activate_round(round_index);answers.clear();results.clear();focused=int(loader.questions[0].contact_id);capture_learning_deadlines()
	return true
func public_rows(history_index: int=-1) -> Array:
	var rows: Array=[]
	if not analyzed:return rows
	var data: Dictionary=round_history[history_index] if history_index>=0 and history_index<round_history.size() else {"questions":loader.questions,"answers":answers,"results":results,"times":{}}
	for q in data.questions:
		var id: int=q.contact_id
		var choices: Array=[]
		for d in q.options:choices.append({"id":int(d),"name":loader.defenses[int(d)].defense_name})
		rows.append({"learning_id":q.get("learning_id",q.question_id),"contact_id":id,"center_id":q.center_id,"attack":loader.attacks[int(q.attack_id)].attack_name,"choices":choices,"selected":data.answers.get(id),"answered":data.results.has(id),"result":data.results.get(id,{}),"recorded_time":data.times.get(id,"Time unavailable")})
	return rows

func capture_learning_deadlines() -> void:
	learning_deadlines.clear()
	for q in loader.questions:
		learning_deadlines[int(q.contact_id)]=now+float(q.get("learning_deadline_seconds",300.0))
func learning_remaining(id: int) -> Variant:
	return null if not learning_deadlines.has(id) else maxf(0,learning_deadlines[id]-now)
