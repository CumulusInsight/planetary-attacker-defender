extends RefCounted
## Catalog IDs are owner-database IDs. Public choices are authored, never generated from hidden truth.
static func read_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path): return {"error":"Missing cyber data: " + path,"data":{}}
	var parser := JSON.new()
	if parser.parse(FileAccess.get_file_as_string(path)) != OK or not parser.data is Dictionary:
		return {"error":"Malformed cyber JSON: " + path,"data":{}}
	return {"error":"","data":parser.data}
static func load_data(catalog_path: String = "res://data/cyber_catalog.json", scenario_path: String = "res://data/cyber_scenarios.json") -> Dictionary:
	var catalog := read_json(catalog_path)
	if not catalog.error.is_empty(): return catalog
	var scenarios := read_json(scenario_path)
	if not scenarios.error.is_empty(): return scenarios
	var error := validate(catalog.data,scenarios.data)
	return {"error":error,"catalog":catalog.data,"scenarios":scenarios.data.get("scenarios",[])}
static func integer(value: Variant) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and float(value) == floor(float(value)) and value > 0
static func validate(c: Dictionary, s: Dictionary) -> String:
	if c.get("schema_version") != 1 or s.get("schema_version") != 1: return "Unsupported cyber schema version."
	if not c.get("source_sha256") is String or c.source_sha256.length() != 64: return "Missing source catalog fingerprint."
	var indexes := {}
	for spec in [["attacks",100,["attack_name","definition","difficulty","severity"]],["defenses",185,["defense_name","definition"]],["attack_defenses",211,[]]]:
		if not c.get(spec[0]) is Array or c[spec[0]].size() != spec[1]: return "Cyber catalog: invalid " + spec[0] + " count/type."
		var ids := {}
		for row in c[spec[0]]:
			if not row is Dictionary or not integer(row.get("ID")) or ids.has(int(row.ID)): return "Cyber catalog: invalid/duplicate ID."
			for field in spec[2]:
				if not row.get(field) is String or row[field].strip_edges().is_empty(): return "Cyber catalog: missing " + field
			ids[int(row.ID)] = row
		indexes[spec[0]] = ids
	var pairs := {}
	var mapped := {}
	for row in c.attack_defenses:
		if not integer(row.get("attack_id")) or not integer(row.get("defense_id")): return "Malformed cyber mapping."
		if not indexes.attacks.has(int(row.attack_id)) or not indexes.defenses.has(int(row.defense_id)): return "Broken cyber mapping."
		var pair := "%d/%d" % [row.attack_id,row.defense_id]
		if pairs.has(pair): return "Duplicate cyber mapping."
		pairs[pair] = true
		mapped[int(row.attack_id)] = true
	if mapped.size() != 100: return "Attack without defense mappings."
	if not s.get("scenarios") is Array or s.scenarios.size() != 5: return "Exactly five authored cyber scenarios required."
	var contacts := {}
	var scenarios := {}
	for profile in s.scenarios:
		if not profile is Dictionary: return "Malformed cyber scenario."
		if not integer(profile.get("contact_id")) or int(profile.contact_id) not in range(10,19) or contacts.has(int(profile.contact_id)): return "Invalid cyber contact reference."
		if not profile.get("scenario_id") is String or scenarios.has(profile.scenario_id): return "Invalid cyber scenario ID."
		contacts[int(profile.contact_id)] = true
		scenarios[profile.scenario_id] = true
		if not integer(profile.get("private_attack_id")) or not indexes.attacks.has(int(profile.private_attack_id)): return "Missing scenario attack."
		if not profile.get("public_assessment") is String or profile.public_assessment.is_empty(): return "Missing public cyber assessment."
		if not (profile.get("confidence") is float or profile.get("confidence") is int) or not is_finite(float(profile.confidence)) or profile.confidence < 0 or profile.confidence > 100: return "Invalid cyber confidence."
		if not profile.get("conditions") is Array or not profile.get("required_conditions") is Array: return "Missing cyber conditions."
		for condition in profile.required_conditions:
			if not condition is String or not profile.conditions.has(condition): return "Unsupported cyber condition."
		if not profile.get("sources") is Array or profile.sources.size() != 3: return "Missing cyber observations."
		for source in profile.sources:
			if not source is Dictionary or not source.get("source") is String or not source.get("text") is String: return "Malformed cyber source."
		if not profile.get("responses") is Array or profile.responses.size() != 3: return "Three cyber choices required."
		var choices := {}
		var mapped_choice := false
		for response in profile.responses:
			if not response is Dictionary or not integer(response.get("defense_id")) or not indexes.defenses.has(int(response.defense_id)) or choices.has(int(response.defense_id)): return "Missing/duplicate scenario defense."
			if not integer(response.get("against_attack_id")) or int(response.against_attack_id) != int(profile.private_attack_id): return "Effectiveness rule references a different attack."
			if not response.get("requires") is Array: return "Effectiveness rule missing conditions."
			for condition in response.requires:
				if not profile.conditions.has(condition): return "Effectiveness condition unavailable."
			choices[int(response.defense_id)] = true
			mapped_choice = mapped_choice or pairs.has("%d/%d" % [profile.private_attack_id,response.defense_id])
			if response.get("outcome") not in ["contained","partial","ineffective","unverified","disruption"] or not response.get("final") is bool: return "Invalid cyber effectiveness rule."
			if response.final != (response.outcome == "contained"): return "Only observed containment closes these authored encounters."
			for key in ["observation","education"]:
				if not response.get(key) is String or response[key].is_empty(): return "Missing cyber explanation."
		if not mapped_choice: return "Scenario has no mapped applicable defense."
	return ""
