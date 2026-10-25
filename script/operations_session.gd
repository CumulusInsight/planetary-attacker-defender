extends RefCounted
## Public command accountability only: no hidden fixture, mission ledger or scene access.
signal event_recorded(record: Dictionary)
var context_provider: Callable
var _stamps: Dictionary = {}
const Loader = preload("res://script/operations_data_loader.gd")
var now := 0.0
var revision := 0
var _config: Dictionary = {}
var _contacts: Dictionary = {}
var _jobs: Dictionary = {}
var _events: Array = []
var _requests: Dictionary = {}
var _sequence := 0
var _deliveries: Array = []

func configure(config: Dictionary, ids: Array) -> String:
	var error := Loader.validate(config, ids)
	if not error.is_empty(): return error
	_config = config.duplicate(true)
	now = 0.0
	revision = 0
	_contacts.clear()
	_jobs.clear()
	_events.clear()
	_requests.clear()
	_deliveries.clear()
	_sequence = 0
	_stamps.clear()
	for record in config.contacts:
		_contacts[int(record.contact_id)] = {"state":"MONITORED", "config":record.duplicate(true), "deadline_at":null, "tracking":false, "disposition":"", "consequence":{}, "escalation_evidence":{}, "reason":""}
	return ""

func _event(id: int, kind: String, details: Dictionary = {}) -> void:
	_sequence += 1
	_events.append({"event_id":_sequence, "time":now, "contact_id":id, "kind":kind, "details":details.duplicate(true)})
	var stamped: Dictionary = _events.back().duplicate(true)
	stamped.merge(preload("res://script/event_stamp.gd").capture())
	if context_provider.is_valid(): stamped.merge(context_provider.call(id))
	_stamps[_sequence] = stamped
	event_recorded.emit(stamped.duplicate(true))
	revision += 1

func _transition(id: int, action: String) -> void:
	var c: Dictionary = _contacts[id]
	var previous: String = c.state
	c.state = _config.transitions[previous][action]
	_event(id, "transition", {"from":previous,"to":c.state,"action":action})

func execute(id: int, action: String, request_id: String, reason: String = "", evidence: Dictionary = {}) -> Dictionary:
	if _requests.has(request_id): return _requests[request_id].duplicate(true)
	var error := ""
	if request_id.is_empty(): return {"ok":false,"error":"Command token is required."}
	if not _contacts.has(id): error = "Contact has no Prototype 9 operation."
	elif action == "review":
		if not _jobs.has(id) or _jobs[id].status != "complete" or _jobs[id].reviewed: error = "No unreviewed completed investigation."
	elif action in ["expire","investigation_complete"] or not _config.transitions[_contacts[id].state].has(action): error = "Command is invalid in the current operational state."
	elif action == "investigate" and _jobs.has(id): error = "The one authored investigation was already requested."
	elif action == "continue" and _contacts[id].tracking: error = "Continue tracking is already recorded for this escalation."
	elif action == "escalate" and (reason.strip_edges().length() < 3 or reason.length() > 300 or not evidence.has("assessment")): error = "Escalation needs confirmation, public evidence and a reason (3-300 characters)."
	if not error.is_empty():
		_event(id,"rejected",{"action":action,"reason":error,"acceptance":"COMMAND REJECTED","remaining":window_remaining(id)})
		_requests[request_id] = {"ok":false,"error":error}
		return _requests[request_id].duplicate(true)
	if action == "review":
		_jobs[id].reviewed = true
		_event(id,"reviewed")
	else:
		_transition(id,action)
		match action:
			"investigate":
				_event(id,"investigation_requested")
				_jobs[id] = {"status":"queued","requested":now,"order":_sequence,"started":null,"finish":null,"reviewed":false}
				_start_jobs()
			"escalate":
				var snapshot := {}
				for key in ["assessment","confidence","report_id","source_type","text"]:
					if evidence.has(key): snapshot[key] = evidence[key]
				_contacts[id].escalation_evidence = snapshot
				_contacts[id].reason = reason.strip_edges()
				_contacts[id].tracking = false
				if _contacts[id].deadline_at == null and _contacts[id].config.get("operational_deadline_seconds") != null:
					_contacts[id].deadline_at = now + _contacts[id].config.operational_deadline_seconds
				_event(id,"escalated",{"reason":reason.strip_edges(),"evidence":snapshot})
			"continue":
				_contacts[id].tracking = true
				_event(id,"tracking",{"observation":"Tracking continues. No defensive authorization issued."})
			"stand_down": _event(id,"deescalated",{"observation":"Returned to watchlist deliberately; no final disposition."})
			"intercept", "hold_fire", "release": _resolve(id,action)
	_requests[request_id] = {"ok":true,"error":""}
	advance(0.0) # Re-escalating an already elapsed configured window cannot permit a late action.
	return _requests[request_id].duplicate(true)

func _resolve(id: int, action: String) -> void:
	var effect: Dictionary = _config.consequences[action].duplicate(true)
	_contacts[id].disposition = effect.issued
	_contacts[id].consequence = effect
	_event(id,"command_issued",{"action":action,"text":effect.issued,"acceptance":"DEADLINE EXPIRED" if action == "expire" else "COMMAND ACCEPTED","remaining":window_remaining(id)})
	_event(id,"action_executed",{"action":action,"text":effect.executed})
	_event(id,"outcome_observed",{"text":effect.observation})
	_event(id,"resolved",{"action":action,"disposition":effect.issued})
	if _jobs.has(id) and _jobs[id].status in ["queued","active"]:
		_jobs[id].status = "cancelled"
		_event(id,"investigation_cancelled",{"reason":"Final disposition before report completion."})
	_start_jobs()

func _start_jobs() -> void:
	var count: int = _jobs.values().filter(func(j): return j.status == "active").size()
	var queue: Array = _jobs.keys().filter(func(id): return _jobs[id].status == "queued")
	queue.sort_custom(func(a,b): return _jobs[a].order < _jobs[b].order if _jobs[a].order != _jobs[b].order else a < b)
	for id in queue:
		if count >= int(_config.investigation_capacity): break
		_jobs[id].status = "active"
		_jobs[id].started = now
		_jobs[id].finish = now + _contacts[id].config.investigation_seconds
		_event(id,"investigation_started",{"queue_delay":now-_jobs[id].requested})
		count += 1

func advance(delta: float, paused: bool = false) -> void:
	if paused or not is_finite(delta) or delta < 0 or _config.is_empty(): return
	var target := now + delta
	while true:
		var next := target + 1.0
		for job in _jobs.values():
			if job.status == "active": next = minf(next,job.finish)
		for c in _contacts.values():
			if c.state == "ESCALATED" and c.deadline_at != null: next = minf(next,maxf(now,c.deadline_at))
		if next > target: break
		now = next
		# Completion before expiry at equal simulation timestamps, then ascending ID.
		var ids: Array = _contacts.keys()
		ids.sort()
		for id in ids:
			if _jobs.has(id) and _jobs[id].status == "active" and _jobs[id].finish <= now:
				_jobs[id].status = "complete"
				_event(id,"investigation_completed")
				_deliveries.append(_contacts[id].config.report.duplicate(true))
				if _contacts[id].state == "INVESTIGATING": _transition(id,"investigation_complete")
		for id in ids:
			var c: Dictionary = _contacts[id]
			if c.state == "ESCALATED" and c.deadline_at != null and c.deadline_at <= now:
				_transition(id,"expire")
				_resolve(id,"expire")
		_start_jobs()
	now = target

func take_deliveries() -> Array:
	var result := _deliveries.duplicate(true)
	_deliveries.clear()
	return result
func events(timestamped: bool = false) -> Array:
	if not timestamped: return _events.duplicate(true) # Stable simulation projection retained for deterministic regression comparisons.
	var result := []
	for event in _events: result.append(_stamps[event.event_id].duplicate(true))
	return result

func record_cyber(id: int, result: Dictionary, token: String) -> void:
	var key := "cyber/" + token
	if _requests.has(key): return
	_requests[key] = result.duplicate(true)
	if not result.ok:
		_event(id,"rejected",{"action":"cyber response","acceptance":"COMMAND REJECTED","reason":result.error,"remaining":window_remaining(id)})
		return
	_event(id,"cyber_response",result.merged({"acceptance":"COMMAND ACCEPTED","remaining":window_remaining(id)}))
	if result.final and _contacts[id].state == "ESCALATED":
		_contacts[id].state = "RESOLVED"
		_contacts[id].disposition = "Observed cyber containment; spacecraft remains in orbit."
		_contacts[id].consequence = {"issued":result.response,"executed":result.execution,"observation":result.observation}
		_event(id,"resolved",{"action":"cyber","disposition":_contacts[id].disposition})
		if _jobs.has(id) and _jobs[id].status in ["queued","active"]:
			_jobs[id].status = "cancelled"
			_event(id,"investigation_cancelled",{"reason":"Final observable cyber containment."})
		_start_jobs()
func ids() -> Array: return _contacts.keys()
func has_contact(id: int) -> bool: return _contacts.has(id)
func view(id: int) -> Dictionary:
	if not _contacts.has(id): return {}
	var c: Dictionary = _contacts[id]
	var job: Dictionary = _jobs.get(id,{})
	var status: String = job.get("status","not requested")
	var eta: Variant = null
	if status == "active": eta = maxf(0,job.finish-now)
	elif status == "queued":
		var slots: Array = []
		for j in _jobs.values():
			if j.status == "active": slots.append(j.finish)
		while slots.size() < int(_config.investigation_capacity): slots.append(now)
		var queue: Array = _jobs.keys().filter(func(key): return _jobs[key].status == "queued")
		queue.sort_custom(func(a,b): return _jobs[a].order < _jobs[b].order)
		for key in queue:
			slots.sort()
			slots[0] += _contacts[key].config.investigation_seconds
			if key == id: eta = slots[0]-now; break
	return {"contact_id":id,"state":c.state,"investigation":status,"eta":eta,"awaiting_review":status=="complete" and not job.reviewed,
		"remaining":maxf(0,c.deadline_at-now) if c.deadline_at != null and c.state=="ESCALATED" else null,
		"disposition":c.disposition,"consequence":c.consequence.duplicate(true),"reason":c.reason,"escalation_evidence":c.escalation_evidence.duplicate(true)}
func can(id: int, action: String) -> bool:
	if not _contacts.has(id): return false
	var c: Dictionary = _contacts[id]
	if action == "review": return _jobs.has(id) and _jobs[id].status == "complete" and not _jobs[id].reviewed
	if not _config.transitions[c.state].has(action) or action in ["expire","investigation_complete"]: return false
	if action == "investigate": return not _jobs.has(id)
	if action == "continue": return not c.tracking
	return true
func statistics() -> Dictionary:
	var result := {"contacts_investigated":0,"investigations_completed":0,"contacts_escalated":0,"contacts_deescalated":0,"interceptors_deployed":0,"hold_fire_decisions":0,"contacts_resolved":0,"unresolved_escalations":0,"queue_delay_seconds":0.0,"rejected_commands":0,"active":0,"queued":0,"awaiting_review":0}
	var unique_escalated := {}
	var unique_deescalated := {}
	for event in _events:
		match event.kind:
			"investigation_requested": result.contacts_investigated += 1
			"investigation_completed": result.investigations_completed += 1
			"escalated": unique_escalated[event.contact_id] = true
			"deescalated": unique_deescalated[event.contact_id] = true
			"investigation_started": result.queue_delay_seconds += event.details.queue_delay
			"rejected": result.rejected_commands += 1
			"resolved":
				result.contacts_resolved += 1
				if event.details.action == "intercept": result.interceptors_deployed += 1
				if event.details.action == "hold_fire": result.hold_fire_decisions += 1
	result.contacts_escalated = unique_escalated.size()
	result.contacts_deescalated = unique_deescalated.size()
	for id in ids():
		var v := view(id)
		if v.state == "ESCALATED": result.unresolved_escalations += 1
		if v.investigation == "active": result.active += 1
		if v.investigation == "queued": result.queued += 1
		if v.awaiting_review: result.awaiting_review += 1
	return result

func capacity() -> int: return int(_config.get("investigation_capacity",0))

func window_remaining(id: int) -> Variant:
	if not _contacts.has(id) or _contacts[id].deadline_at == null: return null
	return maxf(0.0,_contacts[id].deadline_at-now)
