extends RefCounted
## Public demonstration snapshot only. No fixture truth, clock, or scheduler.

static func demonstration(active_contact_id: int) -> Dictionary:
	return {"total": 8, "available": 5, "occupied": 3, "concern": 1,
		"awaiting_analysis": 1, "awaiting_decision": 1,
		"contacts": {active_contact_id: {"analysis_seconds": 765}}}

static func valid_count(value: Variant) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and value >= 0 and value == floor(value) and value <= 315360000

static func format_time(value: Variant) -> String:
	if not valid_count(value):
		return "Unavailable"
	var seconds := int(value)
	var days := seconds / 86400
	var clock := "%02d:%02d:%02d" % [(seconds % 86400) / 3600, (seconds % 3600) / 60, seconds % 60]
	return ("%d days " % days if days > 0 else "") + clock

static func present(data: Dictionary, contact_id: int) -> String:
	var header := "DEMO: static, not scheduled"
	for key in ["total", "available", "occupied", "concern", "awaiting_analysis", "awaiting_decision"]:
		if not valid_count(data.get(key)):
			return header + "\nResource values unavailable"
	if data.available + data.occupied != data.total or data.awaiting_analysis > data.concern or data.awaiting_decision > data.concern:
		return header + "\nResource values unavailable"
	var text := header + "\nIntelligence staff: %d total\nAvailable: %d | Occupied: %d" % [data.total, data.available, data.occupied]
	text += "\nObjects of concern: %d\nAwaiting analysis: %d\nReports awaiting decision: %d" % [data.concern, data.awaiting_analysis, data.awaiting_decision]
	var contacts: Variant = data.get("contacts", {})
	var contact: Dictionary = {}
	if contacts is Dictionary and contacts.get(contact_id) is Dictionary:
		contact = contacts[contact_id]
	text += "\nEst. analysis: " + format_time(contact.get("analysis_seconds"))
	return text
