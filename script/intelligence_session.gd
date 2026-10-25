extends RefCounted
## Per-contact movement-derived release schedule. Public reports never contain truth.
signal report_received(report: Dictionary)
var capture_timestamps := false
var clock_provider: Callable
var _report_sequence := 0
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
				history.append(_capture(report,elapsed))
				changed = true
			else: break # Authored order is authoritative, even for mixed triggers.
	if changed: revision += 1
	return changed
static func _public_report(report: Dictionary) -> Dictionary:
	var view := {}
	for key in ["report_id", "contact_id", "source_type", "text", "assessment", "confidence", "severity", "suspected_payload", "recommendations", "supersedes", "local_datetime", "timezone", "wall_unix", "simulation_elapsed", "contact_elapsed", "observation_datetime", "report_event_id"]:
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


func append_operational_report(report: Dictionary) -> bool:
	# Trusted validated report, appended at actual completion; never rewrites timed feed.
	var id: int = int(report.contact_id)
	if not _history.has(id): return false
	for prior in _history[id]:
		if prior.report_id == report.report_id: return false
	var record := report.duplicate(true)
	var previous := latest(id)
	record.supersedes = previous.get("report_id", "")
	_history[id].append(_capture(record))
	revision += 1
	return true

func _capture(report: Dictionary, elapsed: float = -1.0) -> Dictionary:
	var public := _public_report(report)
	if capture_timestamps:
		public.merge(preload("res://script/event_stamp.gd").capture(),true)
		public.simulation_elapsed = clock_provider.call() if clock_provider.is_valid() else 0.0
		if elapsed >= 0: public.contact_elapsed = elapsed
		_report_sequence += 1
		public.report_event_id = _report_sequence
		report_received.emit(public.duplicate(true))
	return public
