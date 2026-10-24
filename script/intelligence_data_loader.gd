extends RefCounted
## Atomic validation before any traffic or reports are installed.
const SOURCES = ["SIGINT", "Platform Profile", "Trajectory Assessment", "Follow-up Analysis"]
const STATES = ["Suspected hostile", "Uncertain", "Assessed nonhostile", "Assessment revised"]
static func number(value: Variant) -> bool:
	return (value is int or value is float) and is_finite(float(value))
static func text(value: Variant) -> bool:
	return value is String and not value.strip_edges().is_empty()
static func load_data(path: String, centers: Array) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null: return {"data": {}, "error": "Intelligence data '%s': cannot open file." % path}
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK:
		return {"data": {}, "error": "Intelligence data '%s': invalid JSON at line %d." % [path, parser.get_error_line()]}
	var error := validate(parser.data, centers)
	return {"data": parser.data.duplicate(true) if error.is_empty() else {}, "error": "Intelligence data '%s': %s" % [path, error] if not error.is_empty() else ""}
static func validate(data: Variant, centers: Array) -> String:
	if not data is Dictionary or not data.get("traffic") is Array or not data.get("reports") is Array or not data.get("private_fixtures") is Dictionary:
		return "traffic, reports and private_fixtures are required"
	var ids := {}
	var active := {}
	var center_ids := {}
	for center in centers:
		center_ids[center.center_id] = true
		active[int(center.active_contact_id)] = true
		for contact in center.contacts: ids[int(contact.contact_id)] = true
	var extra_ids := {}
	for contact in data.traffic:
		if not contact is Dictionary or not center_ids.has(contact.get("center_id")) or not number(contact.get("contact_id")) or contact.contact_id < 0 or contact.contact_id > 2147483647 or contact.contact_id != floor(contact.contact_id) or ids.has(int(contact.contact_id)):
			return "invalid, duplicate or unassociated traffic contact"
		ids[int(contact.contact_id)] = true
		extra_ids[str(int(contact.contact_id))] = true
		if not text(contact.get("assessment")) or not number(contact.get("assessed_severity")) or contact.assessed_severity != floor(contact.assessed_severity) or contact.assessed_severity < 0 or contact.assessed_severity > 3:
			return "traffic requires an assessment and severity 0..3"
		var confidence: Variant = contact.get("confidence")
		if confidence != null and (not number(confidence) or confidence < 0 or confidence > 100): return "invalid traffic confidence"
		var p: Variant = contact.get("path")
		if not p is Dictionary: return "traffic path is required"
		for key in ["horizontal_radius", "vertical_radius", "orientation", "initial_phase", "direction", "angular_rate"]:
			if not number(p.get(key)): return "path requires finite " + key
		if p.horizontal_radius <= 0 or p.vertical_radius <= 0 or p.angular_rate <= 0 or (p.direction != -1 and p.direction != 1): return "invalid trajectory dimensions, direction or rate"
		# Rotated ellipse extrema, plus 38px for symbol/identifier/hit area.
		var x := sqrt(pow(p.horizontal_radius * cos(p.orientation),2) + pow(p.vertical_radius * sin(p.orientation),2))
		var y := sqrt(pow(p.horizontal_radius * sin(p.orientation),2) + pow(p.vertical_radius * cos(p.orientation),2))
		if x > 430 or y > 360: return "trajectory enters essential UI or viewport margin"
	var reports := {}
	for report in data.reports:
		if not report is Dictionary or not text(report.get("report_id")) or reports.has(report.report_id) or not number(report.get("contact_id")) or (report.contact_id != floor(report.contact_id) or not ids.has(int(report.contact_id))) or not SOURCES.has(report.get("source_type")) or not text(report.get("text")) or not STATES.has(report.get("assessment")):
			return "invalid report identity, contact, source, text or assessment"
		if not number(report.get("severity")) or report.severity != floor(report.severity) or report.severity < 0 or report.severity > 3: return "invalid report severity"
		var confidence: Variant = report.get("confidence")
		if confidence != null and (not number(confidence) or confidence < 0 or confidence > 100): return "invalid report confidence"
		var release: Variant = report.get("release")
		if not release is Dictionary or not ["elapsed", "investigation"].has(release.get("type")): return "unsupported release condition"
		if release.type == "elapsed" and (not number(release.get("seconds")) or release.seconds < 0): return "invalid release time"
		if release.type == "investigation" and not active.has(int(report.contact_id)): return "investigation requires an existing active encounter"
		var previous: Variant = report.get("supersedes", "")
		if not previous is String or (not previous.is_empty() and (not reports.has(previous) or reports[previous] != report.contact_id)): return "superseded report must precede this report for the same contact"
		if report.has("suspected_payload") and not text(report.suspected_payload): return "invalid optional payload"
		if report.has("recommendations"):
			if not report.recommendations is Array: return "recommendations must be an array"
			for option in report.recommendations:
				if not text(option): return "recommendations must be nonempty text"
		reports[report.report_id] = report.contact_id
	for id in data.private_fixtures:
		if not extra_ids.has(id) or not data.private_fixtures[id] is Dictionary or not text(data.private_fixtures[id].get("identity")) or not data.private_fixtures[id].get("hostile") is bool:
			return "private fixtures must belong to new passive traffic"
	return ""
