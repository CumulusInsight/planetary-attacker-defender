extends "res://script/rich_learning_session.gd"
## Queue authorization is shared with AUTO; manual input only drains an authorized slot.
var firing_mode:="AUTO-FIRE"
func mode_switch_allowed() -> bool:
	# Modes select the queue consumer; neither pending records nor flights are rebuilt.
	return true
func set_firing_mode(value: String) -> bool:
	if value not in ["AUTO-FIRE","PLAYER FIRE"] or not mode_switch_allowed():return false
	firing_mode=value;return true
func begin_volley() -> Array:
	return [] if firing_mode=="PLAYER FIRE" else super.begin_volley()
func authorized_targets() -> Array:
	return pending.get("shots",[]).duplicate(true) if firing_mode=="PLAYER FIRE" else []
func fire_authorized(id: int) -> Array:
	if firing_mode!="PLAYER FIRE" or review_locked or pending.is_empty():return []
	var index: int=pending.shots.find_custom(func(s):return int(s.contact_id)==id)
	if index<0:return []
	var shot: Dictionary=pending.shots[index]
	if now+CLOCK_EPS<maxf(float(pending.due_at),float(shot.requested_due_at)):return []
	if not correct_answer(id,int(shot.defense_id)) or int(shot.generation)!=generation or not physical_targets.get(shot.physical_id,{}).get("alive",false):return []
	pending.shots.remove_at(index);pending.shots.push_front(shot)
	return super.begin_volley()
func ready_at(id: int) -> Variant:
	for shot in authorized_targets():
		if int(shot.contact_id)==id:return maxf(float(pending.due_at),float(shot.requested_due_at))
	return null
func live_status(id: int) -> String:
	if firing_mode=="PLAYER FIRE" and is_pending(id):return "CORRECT ANSWER — MISSILE AUTHORIZED — AWAITING PLAYER FIRE"
	return super.live_status(id)

## Session-local arrival facts, not a network compromise or an operational score.
## Key: persistent physical_id. Cleared only by explicit learning-session reset.
var internal_threats: Dictionary={}
func finish_shot(id: int,token: int) -> Dictionary:
	var result:=super.finish_shot(id,token)
	if result.get("projectile_outcome","")=="EVADED":_record_internal_arrival(result,"EVADED_INTERCEPTION")
	return result
func record_incorrect(id: int,defense: int) -> void:
	if review_locked:return
	var already_evaluated:=results.has(id)
	super.record_incorrect(id,defense)
	if not already_evaluated:_record_internal_arrival(results.get(id,{}),"UNOPPOSED_ARRIVAL")
func _record_internal_arrival(result: Dictionary,cause: String) -> void:
	# Only authoritative combat results enter this first-arrival registry.
	if result.is_empty() or review_locked:return
	var outcome: String=result.get("projectile_outcome","")
	if cause=="EVADED_INTERCEPTION" and outcome!="EVADED":return
	if cause=="UNOPPOSED_ARRIVAL" and (outcome!="NOT LAUNCHED" or result.get("answer_correct",true)):return
	if cause not in ["EVADED_INTERCEPTION","UNOPPOSED_ARRIVAL"]:return
	var identity: String=result.get("physical_id","")
	if identity.is_empty() or internal_threats.has(identity):return
	var id: int=result.contact_id
	internal_threats[identity]={"physical_id":identity,"contact_id":id,"center_id":result.center_id,"learning_id":result.learning_id,"learning_attack_name":result.attack_name,"learning_attack_id":int(question(id).attack_id),"source_outcome":outcome,"arrival_cause":cause,"simulation_time":now,"state":"ARRIVED_INTERNAL","compromise_confirmed":false}
func internal_for_center(center: String) -> Array:
	var ids: Array=internal_threats.keys();ids.sort();var rows: Array=[]
	for id in ids:
		if internal_threats[id].center_id==center:rows.append(internal_threats[id].duplicate(true))
	return rows
func reset() -> void:
	super.reset();internal_threats.clear()
