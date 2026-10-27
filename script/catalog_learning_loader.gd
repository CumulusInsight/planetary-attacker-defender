extends "res://script/learning_question_loader.gd"
## Catalog-only question generation; original fixture banks are never written.
var excluded: Dictionary={}
func generate(seed_number: int,contacts: Array) -> String:
	excluded.clear();seed_value=seed_number
	var rng:=RandomNumberGenerator.new();rng.seed=seed_number
	var pool: Array=[];var attack_ids: Array=attacks.keys();attack_ids.sort();var defense_ids: Array=defenses.keys();defense_ids.sort()
	for id in attack_ids:
		var valid: Array=defense_ids.filter(func(d):return mappings.has("%d/%d" % [id,d]))
		var invalid: Array=defense_ids.filter(func(d):return not mappings.has("%d/%d" % [id,d]))
		var reason: String="No mapped defense" if valid.is_empty() else "Fewer than three distinct unmapped distractors" if invalid.size()<3 else "Missing catalog attack definition" if str(attacks[id].get("definition","")).is_empty() else ""
		if not reason.is_empty():excluded[id]=reason;continue
		var correct: int=valid[rng.randi_range(0,valid.size()-1)]
		var choices: Array=shuffled(invalid,rng).slice(0,3);choices.append(correct)
		pool.append({"question_id":"P12-CATALOG-%03d" % id,"attack_id":id,"correct_defense_id":correct,"options":shuffled(choices,rng),"learning_deadline_seconds":300+30*(int(id)%8)})
	var problem:=validate_bank({"schema_version":1,"session_size":5,"questions":pool})
	if not problem.is_empty():return problem
	bank_size=pool.size()
	if pool.size()<22:return "Catalog has fewer than 22 eligible attacks"
	pool=shuffled(pool,rng).slice(0,22);rounds.clear()
	for offset in range(0,22,5):
		var group: Array=[]
		for index in range(offset,mini(offset+5,22)):
			var q: Dictionary=pool[index];var center: String="DC-%02d" % [index%6+1]
			var slots: Array=contacts.filter(func(c):return c.center_id==center and not int(c.contact_id) in [1,4,7])
			var slot: Dictionary=slots[(index/6)%slots.size()]
			q.contact_id=int(slot.contact_id);q.center_id=center;q.learning_authored=true;group.append(q)
		rounds.append(tag_round(group,rounds.size()))
	activate_round(0);return ""
