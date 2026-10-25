extends RefCounted
const Intel = preload("res://script/intelligence_data_loader.gd")
const TRANSITIONS = {"MONITORED": {"watch":"WATCHLIST", "investigate":"INVESTIGATING", "escalate":"ESCALATED"}, "WATCHLIST": {"investigate":"INVESTIGATING", "escalate":"ESCALATED"}, "INVESTIGATING": {"investigation_complete":"WATCHLIST", "escalate":"ESCALATED"}, "ESCALATED": {"continue":"ESCALATED", "stand_down":"WATCHLIST", "intercept":"RESOLVED", "hold_fire":"RESOLVED", "release":"RESOLVED", "expire":"RESOLVED"}, "RESOLVED": {}}
static func load_data(path: String, ids: Array) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null: return {"data":{}, "error":"Operations configuration: cannot open '%s'." % path}
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK: return {"data":{}, "error":"Operations configuration: invalid JSON at line %d." % parser.get_error_line()}
	var error := validate(parser.data, ids)
	return {"data":parser.data.duplicate(true) if error.is_empty() else {}, "error":error}
static func validate(data: Variant, ids: Array) -> String:
	if not data is Dictionary: return "Operations configuration requires an object."
	var capacity: Variant = data.get("investigation_capacity")
	if not Intel.number(capacity) or capacity != floor(capacity) or capacity < 1 or capacity > 32: return "Operations capacity must be an integer from 1 to 32."
	if data.get("transitions") != TRANSITIONS: return "Unsupported or incomplete operational transition table."
	if not data.get("contacts") is Array or data.contacts.size() != ids.size(): return "Operations contacts must match configured elliptical traffic."
	var seen := {}
	var report_ids := {}
	for contact in data.contacts:
		if not contact is Dictionary or not Intel.number(contact.get("contact_id")) or contact.contact_id != floor(contact.contact_id) or not ids.has(int(contact.contact_id)) or seen.has(int(contact.contact_id)): return "Invalid or duplicate operations contact."
		seen[int(contact.contact_id)] = true
		if not Intel.number(contact.get("investigation_seconds")) or contact.investigation_seconds <= 0 or contact.investigation_seconds > 86400: return "Investigation duration must be positive and at most one day."
		var deadline: Variant = contact.get("operational_deadline_seconds")
		if deadline != null and (not Intel.number(deadline) or deadline <= 0 or deadline > 315360000): return "Invalid optional operational deadline."
		var report: Variant = contact.get("report")
		if not report is Dictionary or report.get("contact_id") != contact.contact_id or not Intel.text(report.get("report_id")) or report_ids.has(report.report_id) or not report.report_id.begins_with("P9-INV-"): return "Invalid or duplicate investigation report."
		report_ids[report.report_id] = true
		if report.get("source_type") != "Follow-up Analysis" or not Intel.text(report.get("text")) or not Intel.STATES.has(report.get("assessment")): return "Invalid investigation source/text/assessment."
		if not Intel.number(report.get("severity")) or report.severity != floor(report.severity) or report.severity < 0 or report.severity > 3: return "Invalid report severity."
		var confidence: Variant = report.get("confidence")
		if confidence != null and (not Intel.number(confidence) or confidence < 0 or confidence > 100): return "Invalid report confidence."
		if report.has("suspected_payload") and not Intel.text(report.suspected_payload): return "Invalid report payload."
		if report.has("recommendations"):
			if not report.recommendations is Array: return "Invalid recommendations."
			for recommendation in report.recommendations:
				if not Intel.text(recommendation): return "Invalid recommendation text."
	if not data.get("consequences") is Dictionary: return "Missing operational consequences."
	for action in ["intercept","hold_fire","release","expire"]:
		var effect: Variant = data.consequences.get(action)
		if not effect is Dictionary: return "Missing consequence branch."
		for key in ["issued","executed","observation"]:
			if not Intel.text(effect.get(key)): return "Incomplete consequence description."
	return ""
