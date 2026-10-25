extends RefCounted
var contacts := {}
var attacks := {}
var defenses := {}
var mappings := {}
var error := ""
func load_data(registry: Dictionary, path: String = "res://data/decision_assessments.json") -> String:
	var verified: Dictionary = preload("res://script/cyber_data.gd").load_data()
	if not verified.error.is_empty(): return verified.error
	var source := {"data":verified.catalog}
	for row in source.data.attacks: attacks[int(row.ID)] = row
	for row in source.data.defenses: defenses[int(row.ID)] = row
	for row in source.data.attack_defenses:
		if not mappings.has(int(row.attack_id)): mappings[int(row.attack_id)] = []
		mappings[int(row.attack_id)].append(int(row.defense_id))
	var result: Dictionary = preload("res://script/cyber_data.gd").read_json(path)
	if not result.error.is_empty(): return result.error
	error = validate(result.data,registry)
	if error.is_empty():
		for row in result.data.contacts: contacts[int(row.contact_id)] = row.duplicate(true)
	return error
func confidence(value: Variant) -> bool:
	return value == null or ((value is float or value is int) and is_finite(float(value)) and value >= 0 and value <= 100)
func validate(data: Dictionary, registry: Dictionary) -> String:
	if data.get("schema_version") != 1 or not data.get("contacts") is Array or data.contacts.size() != registry.size(): return "Decision assessments must cover the monitored registry."
	var seen := {}
	for row in data.contacts:
		if not row is Dictionary or not preload("res://script/cyber_data.gd").integer(row.get("contact_id")) or not registry.has(int(row.contact_id)) or seen.has(int(row.contact_id)): return "Invalid/duplicate assessment contact."
		var id: int = row.contact_id
		seen[id] = true
		if row.get("center_id") != registry[id].center_id: return "Assessment center mismatch."
		if not row.get("physical") is Dictionary or row.physical.get("state") not in ["Suspected physical weapon","No physical weapon currently suspected","Unknown / insufficient evidence"] or not confidence(row.physical.get("confidence")) or not row.physical.get("evidence") is String: return "Invalid physical assessment."
		if not row.get("recommendation") is Dictionary or not confidence(row.recommendation.get("confidence")): return "Invalid recommendation."
		for key in ["text","rationale"]:
			if not row.recommendation.get(key) is String or row.recommendation[key].is_empty(): return "Missing recommendation text."
		if not row.get("cyber") is Array or row.cyber.size() != 3: return "Three public cyber hypotheses required."
		var attack_ids := {}
		for hypothesis in row.cyber:
			if not hypothesis is Dictionary or not preload("res://script/cyber_data.gd").integer(hypothesis.get("attack_id")) or not attacks.has(int(hypothesis.attack_id)) or attack_ids.has(int(hypothesis.attack_id)) or not confidence(hypothesis.get("likelihood")): return "Invalid public attack hypothesis."
			attack_ids[int(hypothesis.attack_id)] = true
			for key in ["evidence","asset_at_risk","estimate_source"]:
				if not hypothesis.get(key) is String or hypothesis[key].is_empty(): return "Missing hypothesis evidence/source."
	return ""
func view(id: int) -> Dictionary: return contacts.get(id,{}).duplicate(true)
func options(attack_id: int, executable: Array) -> Array:
	var result := []
	for defense_id in mappings.get(attack_id,[]):
		var row: Dictionary = defenses[defense_id]
		result.append({"defense_id":defense_id,"name":row.defense_name,"purpose":row.definition,"executable":executable.has(defense_id),"attack":attacks[attack_id].attack_name,"limitations":"Applicability is not guaranteed effectiveness. Only previously validated scenario responses can execute."})
	return result
static func percent(value: Variant) -> String: return "Unknown" if value == null else str(value)+"%"
