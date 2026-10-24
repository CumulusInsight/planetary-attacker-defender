extends RefCounted
## First actual resolution per participant is official. Replay is practice, never score farming.
## Actual-result adjudication is private. Public points depend only on observable evidence and disposition.
const Loader = preload("res://script/mission_data_loader.gd")
const LABELS = {"asset_protection": "Asset protection", "threat_resolution": "Threat resolution", "decision_quality": "Decision quality", "resource_management": "Resource management", "command_effectiveness": "Command effectiveness"}
var _definition: Dictionary = {}
var _participants: Dictionary = {}
var _records: Dictionary = {}

func configure(definition: Dictionary, participants: Dictionary) -> String:
	_definition = {}
	_participants = {}
	_records = {}
	var error := Loader.validate(definition)
	if not error.is_empty():
		return error
	if participants.is_empty():
		return "mission requires active encounter participants"
	var ids := {}
	for center in participants:
		if not center is String or center.is_empty() or not (participants[center] is int) or participants[center] < 0 or ids.has(participants[center]):
			return "invalid or duplicate mission participant"
		ids[participants[center]] = true
	_definition = definition.duplicate(true)
	_participants = participants.duplicate(true)
	return ""

func record_resolution(center: String, event: Dictionary) -> Dictionary:
	if not _participants.has(center) or event.get("contact_id") != _participants[center]:
		return {"ok": false, "recorded": false, "error": "Resolution does not belong to this mission participant."}
	var action: Variant = event.get("decision")
	var actual: Variant = event.get("actual_result")
	var allowed := {"interference_blocked": ["deploy"], "interference_allowed": ["hold_fire", "expired"], "probe_interfered": ["deploy"], "legitimate_passage": ["hold_fire", "expired"]}
	if not allowed.has(actual) or not allowed[actual].has(action) or not Loader.text(event.get("observation")) or not Loader.text(event.get("uncertainty")):
		return {"ok": false, "recorded": false, "error": "Invalid deterministic resolution event."}
	if _records.has(center):
		return {"ok": true, "recorded": false, "error": ""}
	var evidence: Dictionary = {"effect": "unverified_effect", "resolution_fraction": null, "explanation": "Observable effects do not match a reviewed evidence rule; resolution remains unassessed."}
	for rule in _definition.public_evidence_rules:
		if rule.observation == event.observation:
			evidence = rule.duplicate(true)
			break
	# A quiet passage after expiry is not credit for an intentional, timely decision.
	if action == "expired":
		evidence.resolution_fraction = 0.0
		evidence.explanation = "The opportunity expired without a timely decision; a favorable observation is not credited as deliberate restraint."
	var correct: bool = (actual == "interference_blocked" and action == "deploy") or (actual == "legitimate_passage" and action == "hold_fire")
	_records[center] = {"contact_id": event.contact_id, "decision": action,
		"observation": event.observation, "uncertainty": event.uncertainty,
		"public_evidence": evidence,
		"private_review": {"actual_result": actual, "correct_decision": correct,
			"unnecessary_engagement": actual == "probe_interfered",
			"quality_points_pending": float(_definition.defender_weights.decision_quality) / _participants.size() if correct else 0.0,
			"quality_penalty_pending": float(_definition.defender_weights.decision_quality) / _participants.size() if actual == "probe_interfered" else 0.0}}
	return {"ok": true, "recorded": true, "error": ""}

func public_snapshot(center: String = "") -> Dictionary:
	if _definition.is_empty():
		return {}
	var selected: Array = _participants.keys() if center.is_empty() else ([center] if _participants.has(center) else [])
	var divisor := float(_participants.size())
	var records: Array[Dictionary] = []
	var timely := 0
	var expired := 0
	var known_resolution := 0
	var resolution_sum := 0.0
	var outcomes: Array[Dictionary] = []
	for id in selected:
		if not _records.has(id):
			continue
		var record: Dictionary = _records[id]
		records.append(record)
		if record.decision == "expired": expired += 1
		else: timely += 1
		if record.public_evidence.resolution_fraction != null:
			known_resolution += 1
			resolution_sum += record.public_evidence.resolution_fraction
		outcomes.append({"center_id": id, "contact_id": record.contact_id, "decision": record.decision,
			"observation": record.observation, "uncertainty": record.uncertainty,
			"explanation": record.public_evidence.explanation})
	var categories: Array[Dictionary] = []
	var confirmed := 0.0
	var assessed := 0.0
	for key in Loader.DEFENDER:
		var weight := float(_definition.defender_weights[key])
		var category := {"id": key, "label": LABELS[key], "maximum": weight * selected.size() / divisor,
			"points": null, "assessed_maximum": 0.0, "status": "Unassessed", "reason": ""}
		if key == "threat_resolution":
			if known_resolution > 0:
				category.points = weight * resolution_sum / divisor
				category.assessed_maximum = weight * known_resolution / divisor
			category.reason = "Observed effects from timely dispositions; unknown effects remain unassessed. Expiration earns no timely-resolution credit."
		elif key == "command_effectiveness":
			if not records.is_empty():
				category.points = weight * timely / divisor
				category.assessed_maximum = weight * records.size() / divisor
			category.reason = "Confirmed timely disposition versus recorded expiry only; this is not a correctness or defense-success endorsement."
		else:
			category.reason = _definition.unassessed_reasons[key]
		if category.points != null:
			confirmed += category.points
			assessed += category.assessed_maximum
			category.status = "Assessed" if is_equal_approx(category.assessed_maximum, category.maximum) else "Partially assessed"
		categories.append(category)
	var objectives: Array[Dictionary] = []
	var statuses := {"protect_assets": "Unassessed: operational health/damage not verified.",
		"resolve_encounters": "%d/%d official dispositions; effects require evidence, not a hostile label." % [records.size(), selected.size()],
		"avoid_unnecessary_engagement": "Unassessed: engagement necessity not independently verified.",
		"timely_decisions": "%d timely / %d expired / %d pending." % [timely, expired, selected.size() - records.size()],
		"operational_effectiveness": "Confirmed performance only; identity and resource efficiency unassessed."}
	for objective in _definition.objectives:
		objectives.append({"id": objective.objective_id, "text": objective.text, "short_text": objective.short_text, "status": statuses[objective.objective_id]})
	var maximum := float(_definition.maximum_points) * selected.size() / divisor
	return {"mission_id": _definition.mission_id, "title": _definition.title,
		"complete": _records.size() == _participants.size(), "participants": selected.size(),
		"resolved": records.size(), "timely": timely, "expired": expired,
		"confirmed_points": confirmed if assessed > 0.0 else null, "assessed_maximum": assessed,
		"maximum": maximum, "unassessed_maximum": maximum - assessed,
		"categories": categories, "objectives": objectives, "outcomes": outcomes,
		"replay_policy": "First resolution is official; subsequent replay is practice and cannot alter mission points."}

func debug_review(center: String) -> Dictionary:
	return _records.get(center, {}).get("private_review", {}).duplicate(true) if OS.is_debug_build() else {}
