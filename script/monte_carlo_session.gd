extends "res://script/martian_learning_session.gd"
var evasion_rng:=RandomNumberGenerator.new()
var evasion_seed:=0
func configure(source: RefCounted) -> void:
	super.configure(source);evasion_seed=int(source.seed_value)^0x45564144;evasion_rng.seed=evasion_seed
func reset() -> void:
	super.reset();evasion_rng.seed=evasion_seed
func evade_shot(id: int,token: int) -> bool:
	if token!=generation or not flights.has(id) or results.has(id) or flights[id].get("evasion_attempted",false) or now>=float(flights[id].get("launched_at",now))+36.0:return false
	var roll:=evasion_rng.randf()
	flights[id].merge({"evasion_attempted":true,"evasion_probability":0.5,"evasion_roll":roll,"evasion_success":roll<0.5,"evaded":roll<0.5 and bool(flights[id].hit)},true)
	return true
func evade_all() -> Array:
	var ids: Array=flights.keys();ids.sort();var accepted: Array=[]
	for id in ids:
		if evade_shot(int(id),generation):accepted.append(id)
	return accepted
func finish_shot(id: int,token: int) -> Dictionary:
	var shot: Dictionary=flights.get(id,{}).duplicate(true)
	var result:=super.finish_shot(id,token)
	if result.is_empty():return result
	for key in ["evasion_attempted","evasion_probability","evasion_roll","evasion_success"]:result[key]=shot.get(key,false if key in ["evasion_attempted","evasion_success"] else null)
	results[id]=result.duplicate(true);all_results[result.learning_id]=result.duplicate(true)
	return result

func begin_volley() -> Array:
	var shots:=super.begin_volley()
	for shot in shots:shot.launched_at=now;flights[int(shot.contact_id)].launched_at=now
	return shots
