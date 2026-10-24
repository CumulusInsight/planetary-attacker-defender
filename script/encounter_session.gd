extends RefCounted
## Decision state and authored resolution, independent of nodes, movement, and UI.

signal resolution_recorded(event: Dictionary)

const Loader = preload("res://script/encounter_data_loader.gd")
const ACTION_LABELS = {"investigate": "Investigate further", "deploy": "Deploy defense", "hold_fire": "Hold fire", "expired": "Deadline expired (no timely intervention)"}

var active_contact_id: int = -1
var investigated: bool = false
var resolved: bool = false
var _fixture: Dictionary = {}
var _decision: String = ""
var _outcome: Dictionary = {}


func configure(fixture: Dictionary, contact_id: int) -> String:
	var error := Loader.validate_fixture(fixture)
	if not error.is_empty() or contact_id < 0:
		_fixture = {}
		active_contact_id = -1
		_clear_progress()
		return error if not error.is_empty() else "Active contact ID must be non-negative"
	_fixture = fixture.duplicate(true)
	active_contact_id = contact_id
	_clear_progress()
	return ""


func act(contact_id: int, action: String) -> Dictionary:
	if _fixture.is_empty() or contact_id != active_contact_id:
		return {"ok": false, "error": "No encounter is assigned to this contact."}
	if resolved:
		return {"ok": false, "error": "Decision already recorded. Replay the encounter to decide again."}
	if action == "expired" or not ACTION_LABELS.has(action):
		return {"ok": false, "error": "Unknown command."}
	if action == "investigate":
		if investigated:
			return {"ok": false, "error": "The single follow-up report has already been requested."}
		investigated = true
	else:
		_decision = action
		_outcome = _fixture.outcomes[action].duplicate(true)
		resolved = true
		_emit_resolution()
	return {"ok": true, "error": ""}


func expire() -> bool:
	if _fixture.is_empty() or resolved:
		return false
	_decision = "expired"
	_outcome = _fixture.outcomes.hold_fire.duplicate(true)
	resolved = true
	_emit_resolution()
	return true


func reset(contact_id: int) -> bool:
	if _fixture.is_empty() or contact_id != active_contact_id:
		return false
	_clear_progress()
	return true


func _clear_progress() -> void:
	investigated = false
	resolved = false
	_decision = ""
	_outcome = {}


static func contact_label(contact_id: int) -> String:
	return "C-%03d" % contact_id


func public_view(contact_id: int) -> Dictionary:
	# Explicit allowlist: never hand the fixture or private outcome to the console.
	var view := {
		"contact_id": contact_id, "identifier": contact_label(contact_id),
		"title": "Background contact", "status": "No encounter assigned",
		"intelligence": "No investigation is assigned to this background contact. Identity and intent are unknown.",
		"sigint": "No attributed signal report is available.", "capabilities": "Not assessed.",
		"follow_up": "", "decision": "No decision recorded.", "observation": "", "uncertainty": "",
		"can_investigate": false, "can_deploy": false, "can_hold_fire": false, "can_reset": false,
	}
	if _fixture.is_empty() or contact_id != active_contact_id:
		return view
	var intel: Dictionary = _fixture.reports.intelligence
	var sigint: Dictionary = _fixture.reports.sigint
	view.title = "Unidentified contact"
	view.status = "Deadline expired" if _decision == "expired" else "Decision recorded" if resolved else ("Follow-up received" if investigated else "Assessment pending")
	view.intelligence = "Observed: %s\nAssessment: %s\nOfficer confidence: %s%% — expressed certainty, NOT verified fact.\n%s" % [intel.observation, intel.assessment, str(intel.confidence), intel.limitation]
	view.sigint = "Detected: %s\nInterpretation: %s\n%s" % [sigint.observation, sigint.interpretation, sigint.limitation]
	view.capabilities = _fixture.reports.capability_estimate
	view.follow_up = _fixture.follow_up if investigated else ""
	view.decision = ACTION_LABELS[_decision] if resolved else "No defense decision recorded."
	view.observation = _outcome.observation if resolved else ""
	view.uncertainty = _outcome.uncertainty if resolved else "Identity, intent, and capabilities are not independently verified. Analyst confidence is not defense effectiveness."
	view.can_investigate = not resolved and not investigated
	view.can_deploy = not resolved
	view.can_hold_fire = not resolved
	view.can_reset = investigated or resolved
	return view


func debug_state() -> Dictionary:
	# Inspection for developer tests only; never called by presentation code.
	if not OS.is_debug_build():
		return {}
	return {"truth": _fixture.get("private_truth", {}).duplicate(true), "actual_result": _outcome.get("actual_result", ""), "decision": _decision}


func assessment_summary() -> Dictionary:
	if _fixture.is_empty():
		return {"assessment": "Assessment unavailable", "confidence": null}
	var intel: Dictionary = _fixture.reports.intelligence
	return {"assessment": intel.assessment, "confidence": intel.confidence}


func _emit_resolution() -> void:
	# Trusted internal event. UI must consume only MissionLedger.public_snapshot().
	resolution_recorded.emit({"contact_id": active_contact_id, "decision": _decision,
		"actual_result": _outcome.actual_result, "observation": _outcome.observation,
		"uncertainty": _outcome.uncertainty})
