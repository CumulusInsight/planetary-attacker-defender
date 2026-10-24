extends RefCounted
## Local authored fixtures. Validation is atomic; no unrelated fallback scenario.

static func load_fixtures(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return _failure(path, "cannot open file (%s)" % error_string(FileAccess.get_open_error()))
	var source := file.get_as_text()
	var read_error := file.get_error()
	file.close()
	if read_error != OK and read_error != ERR_FILE_EOF:
		return _failure(path, "cannot read file (%s)" % error_string(read_error))
	var parser := JSON.new()
	if parser.parse(source) != OK:
		return _failure(path, "JSON syntax error at line %d: %s" % [parser.get_error_line(), parser.get_error_message()])
	if not parser.data is Dictionary or not parser.data.get("fixtures") is Dictionary:
		return _failure(path, "root must contain a fixtures object")
	var fixtures: Dictionary = parser.data.fixtures
	if fixtures.size() != 3:
		return _failure(path, "expected exactly fixtures H, N, and N100")
	for id in ["H", "N", "N100"]:
		var error := validate_fixture(fixtures.get(id))
		if not error.is_empty():
			return _failure(path, "fixture %s: %s" % [id, error])
		var expected_intent := "hostile" if id == "H" else "peaceful"
		if fixtures[id].private_truth.intent != expected_intent:
			return _failure(path, "fixture %s must retain its authored %s intent" % [id, expected_intent])
	if fixtures.N.private_truth != fixtures.N100.private_truth:
		return _failure(path, "N100 must preserve N's peaceful private truth")
	if fixtures.N.outcomes != fixtures.N100.outcomes:
		return _failure(path, "N100 must preserve N's deterministic outcomes")
	if fixtures.N100.reports.intelligence.confidence != 100:
		return _failure(path, "N100 must report analyst confidence 100")
	return {"fixtures": fixtures.duplicate(true), "error": ""}


static func validate_fixture(value: Variant) -> String:
	if not value is Dictionary:
		return "must be an object"
	for key in ["private_truth", "reports", "outcomes"]:
		if not value.get(key) is Dictionary:
			return "'%s' must be an object" % key
	var truth: Dictionary = value.private_truth
	if not _text(truth.get("identity")) or not _text(truth.get("objective")):
		return "private identity and objective must be non-empty text"
	if truth.get("intent") not in ["hostile", "peaceful"]:
		return "private intent must be hostile or peaceful"
	if not truth.get("capabilities") is Array or not truth.get("attempted_attack") is String:
		return "private capabilities must be an array and attempted_attack must be text"
	var unique: Dictionary = {}
	for capability in truth.capabilities:
		if not _text(capability) or unique.has(capability):
			return "private capabilities must be unique non-empty text"
		unique[capability] = true
	if truth.intent == "hostile":
		if truth.capabilities.size() != 3 or truth.attempted_attack not in truth.capabilities:
			return "hostile profile requires three capabilities and an attempted_attack from that profile"
	elif not truth.capabilities.is_empty() or not truth.attempted_attack.is_empty():
		return "peaceful contact cannot have hostile capabilities or an attempted attack"
	for section in ["intelligence", "sigint"]:
		var report = value.reports.get(section)
		if not report is Dictionary:
			return "reports.%s must be an object" % section
		var middle := "assessment" if section == "intelligence" else "interpretation"
		for key in ["observation", middle, "limitation"]:
			if not _text(report.get(key)):
				return "reports.%s.%s must be non-empty text" % [section, key]
	var confidence = value.reports.intelligence.get("confidence")
	if typeof(confidence) not in [TYPE_INT, TYPE_FLOAT]:
		return "analyst confidence must be a number from 0 to 100"
	if not is_finite(float(confidence)) or confidence < 0 or confidence > 100:
		return "analyst confidence must be a finite number from 0 to 100"
	if not _text(value.reports.get("capability_estimate")) or not _text(value.get("follow_up")):
		return "capability estimate and follow_up must be non-empty text"
	for action in ["deploy", "hold_fire"]:
		var outcome = value.outcomes.get(action)
		if not outcome is Dictionary:
			return "outcomes.%s must be an object" % action
		for key in ["actual_result", "observation", "uncertainty"]:
			if not _text(outcome.get(key)):
				return "outcomes.%s.%s must be non-empty text" % [action, key]
		var expected: String
		if truth.intent == "hostile":
			expected = "interference_blocked" if action == "deploy" else "interference_allowed"
		else:
			expected = "probe_interfered" if action == "deploy" else "legitimate_passage"
		if outcome.actual_result != expected:
			return "outcomes.%s.actual_result must match the authored %s branch" % [action, truth.intent]
	return ""


static func _text(value: Variant) -> bool:
	return value is String and not value.strip_edges().is_empty()


static func _failure(path: String, detail: String) -> Dictionary:
	return {"fixtures": {}, "error": "Encounter data '%s': %s. Encounter unavailable." % [path, detail]}
