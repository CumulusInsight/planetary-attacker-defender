extends RefCounted
## Registry of public contact metadata and references to authoritative tactical state.
## No private fixture fields are projected or used for ordering/attention.
const Clock = preload("res://script/command_status.gd")
const SEVERITY = ["Unassessed", "Low", "Moderate", "High"]
var centers: Array[Dictionary] = []
var contacts: Dictionary = {}

func register(center_id: String, definitions: Array, tactical: Node) -> void:
	centers.append({"center_id": center_id, "tactical": tactical})
	for contact in definitions:
		contacts[int(contact.contact_id)] = {"center_id": center_id, "metadata": contact.duplicate(true), "tactical": tactical}

func public_rows() -> Array[Dictionary]:
	var rows: Array[Dictionary] = []
	for id in contacts:
		var entry: Dictionary = contacts[id]
		var tactical = entry.tactical
		var active: bool = id == tactical.encounter.active_contact_id
		var assessment: Dictionary = tactical.encounter.assessment_summary() if active else entry.metadata
		var remaining: Variant = null
		if active and not tactical.encounter.resolved and tactical.encounter_error.is_empty():
			remaining = tactical.deadline.remaining(tactical.active_contact)
		var view: Dictionary = tactical.encounter.public_view(id)
		rows.append({"contact_id": id, "identifier": view.identifier, "center_id": entry.center_id,
			"assessment": assessment.assessment, "confidence": assessment.get("confidence"),
			"severity": int(entry.metadata.assessed_severity), "remaining": remaining,
			"status": view.status})
	return rows

func triage(mode: int) -> Array[Dictionary]:
	var rows := public_rows()
	rows.sort_custom(func(a, b):
		if mode == 1:
			if a.severity != b.severity:
				return a.severity > b.severity
		else:
			if (a.remaining == null) != (b.remaining == null):
				return a.remaining != null
			if a.remaining != null and not is_equal_approx(a.remaining, b.remaining):
				return a.remaining < b.remaining
		return a.contact_id < b.contact_id)
	return rows

func center_summary(center_id: String) -> Dictionary:
	var result := {"center_id": center_id, "count": 0, "active": 0, "highest": 0,
		"urgent_id": "None", "remaining": null, "attention": "MONITOR"}
	for row in public_rows():
		if row.center_id != center_id:
			continue
		result.count += 1
		result.highest = maxi(result.highest, row.severity)
		if row.status == "Deadline expired":
			result.attention = "ATTENTION: expired opportunity"
		if row.remaining != null:
			result.active += 1
			if result.remaining == null or row.remaining < result.remaining:
				result.remaining = row.remaining
				result.urgent_id = row.identifier
			if row.remaining <= 60.0:
				result.attention = "ATTENTION: deadline within 1 min"
	if result.attention == "MONITOR" and result.active > 0 and result.highest >= 3:
		result.attention = "REVIEW: high assessed severity"
	return result

static func time_text(seconds: Variant) -> String:
	return "Not applicable" if seconds == null else Clock.format_time(ceil(float(seconds)))
