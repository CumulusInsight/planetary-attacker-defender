extends "res://script/monte_carlo_session.gd"
## The current learning mode's only authoritative launch path.
const LAUNCH_SPACING:=15.0
const CLOCK_EPS:=0.00000001
var batch_index:=0
var launch_centers: Array=[]
var review_locked:=false
var closed_elapsed: Variant=null
var submitted_questions: Dictionary={}
func correct_answer(id: int,defense: int) -> bool:
	var q:=question(id)
	return not q.is_empty() and q.options.has(defense) and int(q.correct_defense_id)==defense and loader.mappings.has("%d/%d" % [q.attack_id,defense])
func record_incorrect(id: int,defense: int) -> void:
	if results.has(id):return
	var q:=question(id)
	var result: Dictionary={"learning_id":q.learning_id,"question_id":q.question_id,"round_number":round_index+1,"center_id":q.center_id,"contact_id":id,"physical_id":question_targets[q.learning_id],"hit":false,"answer_correct":false,"answer":defense,"correct_name":loader.defenses[int(q.correct_defense_id)].defense_name,"correct_id":int(q.correct_defense_id),"attack_name":loader.attacks[int(q.attack_id)].attack_name,"simulation_time":now,"late_practice":learning_remaining(id)!=null and learning_remaining(id)<=0,"learning_state":"ANSWERED_INCORRECT","projectile_outcome":"NOT LAUNCHED","evasion_attempted":false,"evasion_probability":null,"evasion_roll":null,"evasion_success":false}
	results[id]=result;all_results[q.learning_id]=result.duplicate(true)
func request_fire(_id: int,delay: int) -> Dictionary:
	if review_locked:return {"ok":false,"error":"Review is learning only; no missiles are launched."}
	if delay not in [0,60,300,600] or not pending.is_empty() or in_flight():return {"ok":false,"error":"A launch sequence is pending or airborne. Cancel or wait."}
	var ids:=eligible();ids.sort()
	if not analyzed or ids.is_empty():return {"ok":false,"error":"Select a countermeasure in Report first."}
	batch_index+=1;launch_centers.clear();var shots: Array=[];var wrong:=0
	for id in ids:
		var defense: int=answers[id]
		if not correct_answer(id,defense):record_incorrect(id,defense);wrong+=1;continue
		var q:=question(id)
		if q.center_id not in launch_centers:launch_centers.append(q.center_id)
		shots.append({"contact_id":id,"defense_id":defense,"generation":generation,"learning_id":q.learning_id,"physical_id":question_targets[q.learning_id],"requested_due_at":now+delay+LAUNCH_SPACING*shots.size(),"batch_id":batch_index})
	launch_centers.sort()
	if not shots.is_empty():pending={"shots":shots,"due_at":now+delay,"generation":generation}
	close_score_if_complete()
	return {"ok":true,"error":"","scheduled":shots.size(),"incorrect":wrong}
func begin_volley() -> Array:
	if review_locked or pending.is_empty() or now+CLOCK_EPS<float(pending.due_at):return []
	var shot: Dictionary=pending.shots.pop_front()
	var id: int=shot.contact_id
	# At most one actual launch per spacing interval, even after a large frame/clock jump.
	if pending.shots.is_empty():pending.clear()
	else:pending.due_at=maxf(float(pending.shots[0].requested_due_at),now+LAUNCH_SPACING)
	if int(shot.generation)!=generation or results.has(id) or not correct_answer(id,int(shot.defense_id)):
		if int(shot.generation)==generation and not results.has(id):record_incorrect(id,int(shot.defense_id))
		close_score_if_complete();return []
	shot.hit=true;shot.launched_at=now;shot.launch_claimed=false;shot.late_practice=learning_remaining(id)!=null and learning_remaining(id)<=0
	flights[id]=shot
	return [shot]
func claim_launch(shot: Dictionary) -> bool:
	var id: int=shot.get("contact_id",-1)
	if review_locked or not flights.has(id) or int(shot.get("generation",-1))!=generation:return false
	var flight: Dictionary=flights[id]
	if not bool(flight.get("hit",false)) or not bool(shot.get("hit",false)) or flight.get("launch_claimed",false) or not correct_answer(id,int(shot.get("defense_id",-1))) or int(flight.defense_id)!=int(shot.defense_id):return false
	if shot.get("physical_id","")!=flight.physical_id or not physical_targets.get(flight.physical_id,{}).get("alive",false):return false
	flight.launch_claimed=true;return true
func finish_shot(id: int,token: int) -> Dictionary:
	if not flights.has(id) or not correct_answer(id,int(flights[id].defense_id)) or not flights[id].get("launch_claimed",false) or now+CLOCK_EPS<float(flights[id].launched_at)+36.0:return {}
	var result:=super.finish_shot(id,token);close_score_if_complete();return result
func close_score_if_complete() -> void:
	if session_complete() and pending.is_empty() and flights.is_empty() and closed_elapsed==null:closed_elapsed=maxf(0,now-float(started_at))
func metrics() -> Dictionary:
	var values:=super.metrics()
	if closed_elapsed!=null:values.elapsed=closed_elapsed
	return values
func start_review() -> RefCounted:
	if review_locked or not session_complete() or not pending.is_empty() or in_flight() or metrics().incorrect==0:return null
	review_locked=true
	var review=preload("res://script/missed_question_review.gd").new();review.configure(loader,all_results,metrics());return review
func reset() -> void:
	super.reset();batch_index=0;launch_centers.clear();review_locked=false;closed_elapsed=null;submitted_questions.clear()

func select_answer(id: int,defense: int) -> bool:
	if review_locked or is_pending(id) or submitted_questions.has(question(id).get("learning_id","")):return false
	return super.select_answer(id,defense)

func evade_shot(id: int,token: int) -> bool:
	if flights.has(id) and now+CLOCK_EPS>=float(flights[id].launched_at)+36.0:return false
	return super.evade_shot(id,token)

## Complete-round Report submission delegates to the same authoritative D/WAIT path.
func missing_answers() -> Array:
	var missing: Array=[]
	for q in loader.questions:
		var id: int=q.contact_id
		if not results.has(id) and not flights.has(id) and not is_pending(id) and not answers.has(id):missing.append("C-%03d" % id)
	return missing
func report_submittable() -> bool:
	return analyzed and not review_locked and not eligible().is_empty() and pending.is_empty() and not in_flight() and not loader.questions.any(func(q):return submitted_questions.has(q.learning_id))
func submit_answers(delay: int=0) -> Dictionary:
	var missing:=missing_answers()
	if not missing.is_empty():return {"ok":false,"error":"Select answers for: "+", ".join(missing)}
	if not report_submittable():return {"ok":false,"error":"This round is submitted, historical, or not ready."}
	var ids:=eligible()
	var response:=request_fire(focused,delay)
	if response.ok:
		for id in ids:submitted_questions[question(id).learning_id]=true
	return response
func live_status(id: int) -> String:
	if results.has(id):
		var result: Dictionary=results[id]
		if not result.get("answer_correct",false):return "ANSWER INCORRECT — MISSILE NOT LAUNCHED"
		if result.get("projectile_outcome","")=="HIT":return "CORRECT ANSWER — MISSILE LAUNCHED — THREAT DISABLED"
		if result.get("projectile_outcome","")=="EVADED":return "CORRECT ANSWER — MISSILE LAUNCHED — THREAT EVADED MISSILE"
	if flights.has(id) and flights[id].get("launch_claimed",false):return "CORRECT ANSWER — MISSILE LAUNCHED"
	if is_pending(id):return "CORRECT ANSWER — MISSILE PENDING LAUNCH"
	return ""
