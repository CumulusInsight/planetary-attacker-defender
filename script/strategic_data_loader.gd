extends RefCounted
## Atomic configuration validation; fixture keys are developer data, not UI fields.

static func load_centers(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"centers": [], "error": "Strategic data '%s': cannot open file." % path}
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK:
		return {"centers": [], "error": "Strategic data '%s': invalid JSON at line %d." % [path, parser.get_error_line()]}
	var error := validate(parser.data)
	return {"centers": parser.data.centers.duplicate(true) if error.is_empty() else [], "error": "Strategic data '%s': %s" % [path, error] if not error.is_empty() else ""}

static func whole(value: Variant) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and value >= 0 and value == floor(value)

static func validate(data: Variant) -> String:
	if not data is Dictionary or not data.get("centers") is Array or data.centers.is_empty():
		return "root requires a nonempty centers array"
	var center_ids := {}
	var contact_ids := {}
	for center in data.centers:
		if not center is Dictionary or not center.get("center_id") is String or center.center_id.strip_edges().is_empty():
			return "each center needs a nonempty center_id"
		if center_ids.has(center.center_id):
			return "duplicate center_id " + center.center_id
		center_ids[center.center_id] = true
		if not center.get("contacts") is Array or center.contacts.is_empty():
			return "center %s requires contacts" % center.center_id
		if not whole(center.get("active_contact_id")) or not ["H", "N", "N100"].has(center.get("developer_fixture")):
			return "center %s needs an active contact and valid developer fixture" % center.center_id
		var duration: Variant = center.get("decision_window_seconds", 300.0)
		if not (duration is int or duration is float) or not is_finite(float(duration)) or duration <= 0.0 or duration > 315360000.0:
			return "invalid decision window in " + center.center_id
		var has_active := false
		for contact in center.contacts:
			if not contact is Dictionary or not whole(contact.get("contact_id")) or contact.contact_id > 2147483647:
				return "invalid contact_id in " + center.center_id
			if contact_ids.has(contact.contact_id):
				return "duplicate contact_id %s" % str(contact.contact_id)
			contact_ids[contact.contact_id] = true
			has_active = has_active or contact.contact_id == center.active_contact_id
			if not whole(contact.get("assessed_severity")) or contact.assessed_severity > 3:
				return "assessed severity must be 0 (unassessed) through 3 (high)"
			if not contact.get("assessment") is String or contact.assessment.strip_edges().is_empty():
				return "contact requires public assessment"
			var confidence: Variant = contact.get("confidence")
			if confidence != null and (not whole(confidence) or confidence > 100):
				return "confidence must be absent/null or a percentage"
		if not has_active:
			return "active contact is not associated with " + center.center_id
	return ""
