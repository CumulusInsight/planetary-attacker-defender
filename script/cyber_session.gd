extends RefCounted
## Private evaluator. The UI only receives public_view and observable evaluation results.
var _profiles := {}
var _defenses := {}
var _used := {}
var _requests := {}
var _results := {}
func configure(data: Dictionary) -> void:
	for row in data.catalog.defenses: _defenses[int(row.ID)] = row.duplicate(true)
	for row in data.scenarios: _profiles[int(row.contact_id)] = row.duplicate(true)
func has_contact(id: int) -> bool: return _profiles.has(id)
func public_view(id: int) -> Dictionary:
	if not has_contact(id): return {}
	var profile: Dictionary = _profiles[id]
	var choices := []
	for rule in profile.responses:
		var defense: Dictionary = _defenses[int(rule.defense_id)]
		choices.append({"defense_id":int(defense.ID),"name":defense.defense_name,"purpose":defense.definition,"used":_used.get(id,[]).has(int(defense.ID))})
	return {"contact_id":id,"assessment":profile.public_assessment,"confidence":profile.confidence,"sources":profile.sources.duplicate(true),"choices":choices,"result":_results.get(id,{}).duplicate(true)}
func evaluate(id: int, defense_id: int, token: String, escalated: bool) -> Dictionary:
	if _requests.has(token): return _requests[token].duplicate(true)
	var result := {"ok":false,"error":"Response requires an escalated cyber contact and a valid unused countermeasure."}
	if not token.is_empty() and has_contact(id) and escalated and not _used.get(id,[]).has(defense_id):
		var profile: Dictionary = _profiles[id]
		# Actual hidden attack selects the authored rule set. It is never returned to presentation.
		if int(profile.private_attack_id) > 0:
			for rule in profile.responses:
				if int(rule.defense_id) == defense_id and int(rule.against_attack_id) == int(profile.private_attack_id) and rule.requires.all(func(condition): return profile.conditions.has(condition)):
					result = {"ok":true,"error":"","defense_id":defense_id,"response":_defenses[defense_id].defense_name,"outcome":rule.outcome,"final":rule.final,"observation":rule.observation,"education":rule.education,"execution":"Cyber countermeasure executed against the observed test service; spacecraft movement unchanged."}
					if not _used.has(id): _used[id] = []
					_used[id].append(defense_id)
					_results[id] = result.duplicate(true)
	_requests[token] = result.duplicate(true)
	return result
