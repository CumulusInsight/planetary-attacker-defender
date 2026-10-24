extends RefCounted
## Validates the complete dataset before any attacker receives configuration.

const REQUIRED_FIELDS = ["attack_id", "abbreviation", "description", "severity", "move_speed", "start_ring"]
const INTEGER_FIELDS = ["attack_id", "severity", "start_ring"]


static func load_attacks(path: String, expected_count: int = 3) -> Dictionary:
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
	if not parser.data is Array:
		return _failure(path, "root must be an array of attack records")
	if parser.data.size() != expected_count:
		return _failure(path, "expected exactly %d attack records, found %d" % [expected_count, parser.data.size()])
	var records: Array[Dictionary] = []
	var seen_ids: Dictionary = {}
	for index in range(parser.data.size()):
		var record = parser.data[index]
		var context := "record %d" % (index + 1)
		if not record is Dictionary:
			return _failure(path, "%s must be an object" % context)
		for field in REQUIRED_FIELDS:
			if not record.has(field):
				return _failure(path, "%s is missing required field '%s'" % [context, field])
		for field in ["abbreviation", "description"]:
			if not record[field] is String or record[field].strip_edges().is_empty():
				return _failure(path, "%s field '%s' must be a non-empty string" % [context, field])
		for field in INTEGER_FIELDS:
			var value = record[field]
			if not _is_number(value) or not is_finite(float(value)) or float(value) != floor(float(value)) or value < 0 or value > 2147483647:
				return _failure(path, "%s field '%s' must be a non-negative 32-bit integer" % [context, field])
		if record.start_ring > 2:
			return _failure(path, "%s field 'start_ring' must be 0, 1, or 2" % context)
		if not _is_number(record.move_speed) or not is_finite(float(record.move_speed)) or record.move_speed <= 0:
			return _failure(path, "%s field 'move_speed' must be a finite positive number" % context)
		var id := int(record.attack_id)
		if seen_ids.has(id):
			return _failure(path, "%s has duplicate attack_id %d" % [context, id])
		seen_ids[id] = true
		# Copy only the reusable interface fields, converting JSON numbers explicitly.
		records.append({
			"attack_id": id,
			"abbreviation": record.abbreviation,
			"description": record.description,
			"severity": int(record.severity),
			"move_speed": float(record.move_speed),
			"start_ring": int(record.start_ring),
		})
	return {"records": records, "error": ""}


static func _is_number(value: Variant) -> bool:
	return typeof(value) == TYPE_INT or typeof(value) == TYPE_FLOAT


static func _failure(path: String, detail: String) -> Dictionary:
	return {"records": [], "error": "Attack data '%s': %s. No attackers configured." % [path, detail]}
