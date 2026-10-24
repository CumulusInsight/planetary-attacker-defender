extends RefCounted
## Mission scoring parameters only; never changes scenario truth or movement.
const DEFENDER = ["asset_protection", "threat_resolution", "decision_quality", "resource_management", "command_effectiveness"]
const ATTACKER = ["mission_objectives_achieved", "target_impact_or_control", "stealth_and_deception", "resource_efficiency", "operational_coordination"]
const OBJECTIVES = ["protect_assets", "resolve_encounters", "avoid_unnecessary_engagement", "timely_decisions", "operational_effectiveness"]

static func load_mission(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"data": {}, "error": "Mission data '%s': cannot open file." % path}
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK:
		return {"data": {}, "error": "Mission data '%s': invalid JSON at line %d." % [path, parser.get_error_line()]}
	var error := validate(parser.data)
	return {"data": parser.data.duplicate(true) if error.is_empty() else {}, "error": "Mission data '%s': %s" % [path, error] if not error.is_empty() else ""}

static func positive_integer(value: Variant) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and value > 0 and value == floor(value) and value <= 1000000

static func weights_valid(value: Variant, keys: Array, maximum: Variant) -> bool:
	if not value is Dictionary or not positive_integer(maximum) or value.size() != keys.size():
		return false
	var sum := 0.0
	for key in keys:
		if not positive_integer(value.get(key)):
			return false
		sum += value[key]
	return sum == maximum

static func text(value: Variant) -> bool:
	return value is String and not value.strip_edges().is_empty()

static func validate(data: Variant) -> String:
	if not data is Dictionary or not text(data.get("mission_id")) or not text(data.get("title")):
		return "root requires mission_id and title"
	if data.get("scope") != "configured_active_encounters" or data.get("replay_policy") != "first_resolution_official_then_practice":
		return "unsupported scope or replay policy"
	if not weights_valid(data.get("defender_weights"), DEFENDER, data.get("maximum_points")):
		return "positive defender category weights must sum to maximum_points"
	if not data.get("objectives") is Array or data.objectives.size() != OBJECTIVES.size():
		return "all five defender objectives are required"
	var ids := {}
	for objective in data.objectives:
		if not objective is Dictionary or not OBJECTIVES.has(objective.get("objective_id")) or not text(objective.get("text")) or not text(objective.get("short_text")) or objective.short_text.length() > 32 or ids.has(objective.objective_id):
			return "invalid or duplicate objective"
		ids[objective.objective_id] = true
	if not data.get("unassessed_reasons") is Dictionary:
		return "unassessed reasons are required"
	for category in ["asset_protection", "decision_quality", "resource_management"]:
		if not text(data.unassessed_reasons.get(category)):
			return "missing unassessed category explanation"
	if not data.get("public_evidence_rules") is Array or data.public_evidence_rules.is_empty():
		return "public evidence rules are required"
	var observations := {}
	for rule in data.public_evidence_rules:
		if not rule is Dictionary or not rule.has("resolution_fraction") or not text(rule.get("observation")) or observations.has(rule.observation) or not text(rule.get("explanation")):
			return "invalid or duplicate public observation rule"
		observations[rule.observation] = true
		if not ["blocked_attempt", "access_disturbance", "passage_without_interference", "effects_uncertain"].has(rule.get("effect")):
			return "unknown public evidence effect"
		var fraction: Variant = rule.get("resolution_fraction")
		if fraction != null and (not (fraction is int or fraction is float) or not is_finite(float(fraction)) or fraction < 0.0 or fraction > 1.0):
			return "resolution fraction must be null or a number from 0 to 1"
		if rule.effect == "effects_uncertain" and fraction != null:
			return "uncertain effects cannot award confirmed resolution points"
	var future: Variant = data.get("attacker_future")
	if not future is Dictionary or future.get("implemented") != false or not weights_valid(future.get("weights"), ATTACKER, future.get("maximum_points")):
		return "future attacker model must be separate, disabled, and consistently weighted"
	if not future.get("objectives") is Array or future.objectives.size() != 5:
		return "five future attacker objectives required"
	for objective in future.objectives:
		if not text(objective):
			return "invalid future attacker objective"
	return ""
