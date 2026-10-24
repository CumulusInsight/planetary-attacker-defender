extends RefCounted
## Per-contact movement-derived release schedule. Public reports never contain truth.
var _reports: Array = []
var _truth: Dictionary = {}
var _history: Dictionary = {}
var _origins: Dictionary = {}
var _last_travel: Dictionary = {}
var revision := 0
func configure(reports: Array, truth: Dictionary, contacts: Array) -> void:
	_history.clear()
	_origins.clear()
	_last_travel.clear()
	revision = 0
	_reports = reports.duplicate(true)
	_truth = truth.duplicate(true)
	for contact in contacts:
		_origins[contact.attack_id] = contact.total_orbit_travel
		_last_travel[contact.attack_id] = contact.total_orbit_travel
		_history[contact.attack_id] = []
func advance(contacts: Array, investigated_id: int = -1, paused: bool = false) -> bool:
	var changed := false
	for contact in contacts:
		var id: int = contact.attack_id
		if paused:
			_origins[id] += maxf(0.0, contact.total_orbit_travel - _last_travel[id])
		_last_travel[id] = contact.total_orbit_travel
		if paused: continue
		var elapsed: float = maxf(0.0, contact.total_orbit_travel - _origins[id]) / contact.move_speed
		var history: Array = _history[id]
		var seen: Array = history.map(func(r): return r.report_id)
		for report in _reports:
			if report.contact_id != id or seen.has(report.report_id): continue
			var release: Dictionary = report.release
			if (release.type == "elapsed" and elapsed + 0.000001 >= release.seconds) or (release.type == "investigation" and investigated_id == id):
				history.append(_public_report(report))
				changed = true
			else: break # Authored order is authoritative, even for mixed triggers.
	if changed: revision += 1
	return changed
static func _public_report(report: Dictionary) -> Dictionary:
	var view := {}
	for key in ["report_id", "contact_id", "source_type", "text", "assessment", "confidence", "severity", "suspected_payload", "recommendations", "supersedes"]:
		if report.has(key): view[key] = report[key].duplicate(true) if report[key] is Array else report[key]
	return view
func history(id: int) -> Array:
	return _history.get(id, []).duplicate(true)
func latest(id: int) -> Dictionary:
	var records := history(id)
	return records.back() if not records.is_empty() else {}
func reset_contact(contact: Node) -> void:
	_origins[contact.attack_id] = contact.total_orbit_travel
	_last_travel[contact.attack_id] = contact.total_orbit_travel
	_history[contact.attack_id] = []
	revision += 1
func debug_truth(id: int) -> Dictionary:
	return _truth.get(str(id), {}).duplicate(true) if OS.is_debug_build() else {}
