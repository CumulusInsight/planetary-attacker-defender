extends "res://tests/prototype4_test.gd"
const Ops = preload("res://script/operations_session.gd")
const OpsLoader = preload("res://script/operations_data_loader.gd")
var config: Dictionary
var command: Node
var host: Node
var ui: CanvasLayer
var serial := 0
var all_ids: Array = [10,11,12,13,14,15,16,17,18]
func run() -> void:
	config = OpsLoader.load_data("res://data/contact_operations.json",all_ids).data
	validate_data()
	validate_transitions()
	validate_scheduler()
	validate_consequences()
	await integration()
	await invalid_startup()
	await spawn_game()
	check(game.get_node("EnemyContainer").get_child_count() == 3, "Standalone tactical still starts")
	await close_game()
	print("PROTOTYPE 9 TEST: ","PASS" if failures==0 else "FAIL"," (",failures," failures; ",checks," checks)")
	quit(0 if failures==0 else 1)
func fresh(data: Dictionary = config) -> RefCounted:
	var session = Ops.new()
	check(session.configure(data,all_ids).is_empty(),"Valid operation configuration")
	return session
func act(session: RefCounted, id: int, action: String) -> Dictionary:
	serial += 1
	return session.execute(id,action,"TEST-%d" % serial,"Review evidence",{"assessment":"Uncertain","confidence":50,"report_id":"PUBLIC-1","source_type":"SIGINT","text":"Unattributed transmission."})
func validate_data() -> void:
	check(OpsLoader.validate(config,all_ids).is_empty(),"Configuration valid")
	for mutation in ["capacity","contacts","duplicate","duration","deadline","transitions","report","confidence","consequence"]:
		var data := config.duplicate(true)
		match mutation:
			"capacity": data.investigation_capacity = 0
			"contacts": data.contacts.pop_back()
			"duplicate": data.contacts[1].contact_id = 10
			"duration": data.contacts[0].investigation_seconds = -1
			"deadline": data.contacts[0].operational_deadline_seconds = -1
			"transitions": data.transitions.MONITORED.watch = "ESCALATED"
			"report": data.contacts[0].report.source_type = "Truth oracle"
			"confidence": data.contacts[0].report.confidence = 101
			"consequence": data.consequences.erase("intercept")
		check(not OpsLoader.validate(data,all_ids).is_empty(),"Reject invalid configuration: "+mutation)
	check(not OpsLoader.load_data("user://missing_operations.json",all_ids).error.is_empty(),"Missing configuration diagnostic")
	var file := FileAccess.open("user://bad_operations.json",FileAccess.WRITE)
	file.store_string("[invalid")
	file.close()
	check(not OpsLoader.load_data("user://bad_operations.json",all_ids).error.is_empty(),"Malformed JSON diagnostic")
	DirAccess.remove_absolute("user://bad_operations.json")
func prepare(session: RefCounted, state: String) -> void:
	match state:
		"WATCHLIST": act(session,10,"watch")
		"INVESTIGATING": act(session,10,"investigate")
		"ESCALATED": act(session,10,"escalate")
		"RESOLVED":
			act(session,10,"escalate")
			act(session,10,"intercept")
func validate_transitions() -> void:
	for state in config.transitions:
		for action in ["watch","investigate","escalate","continue","stand_down","intercept","hold_fire","release","review","expire","investigation_complete","unknown"]:
			var s := fresh()
			prepare(s,state)
			var valid: bool = config.transitions[state].has(action) and action not in ["expire","investigation_complete"]
			var result := act(s,10,action)
			check(result.ok == valid,"Transition validity: "+state+" / "+action)
			check(s.view(10).state == (config.transitions[state][action] if valid else state),"Transition target: "+state+" / "+action)
	var s := fresh()
	for id in all_ids:
		check(s.view(id).state=="MONITORED" and s.view(id).remaining==null,"All nine begin monitored with no fabricated deadlines")
	s.advance(100)
	check(s.statistics().contacts_escalated==0,"Elapsed time cannot automatically escalate")
	check(not s.execute(10,"escalate","unconfirmed").ok,"Escalation requires reason and evidence")
	act(s,11,"escalate")
	check(s.view(11).state=="ESCALATED" and s.view(10).state=="MONITORED","Player may escalate peaceful contact while leaving hostile one monitored")
	act(s,11,"continue")
	var tracking_count: int = s.events().size()
	check(not act(s,11,"continue").ok and s.events().size()==tracking_count+1,"Repeated tracking rejected rather than duplicating success")
	act(s,11,"stand_down")
	check(s.view(11).state=="WATCHLIST" and s.view(11).disposition.is_empty(),"De-escalation is not final resolution")
	act(s,11,"escalate")
	var first: Dictionary = s.execute(11,"intercept","SAME-COMMAND")
	var ledger: Array = s.events()
	check(s.execute(11,"intercept","SAME-COMMAND")==first and s.events()==ledger,"Repeated event delivery is idempotent")
	check(not act(s,11,"intercept").ok and s.statistics().contacts_resolved==1,"Final disposition exactly once")
	check(s.statistics().contacts_escalated==1 and s.statistics().contacts_deescalated==1,"Unique contact counts do not farm from re-escalation")
func validate_scheduler() -> void:
	var s := fresh()
	for id in [10,11,12,13]: act(s,id,"investigate")
	check(s.statistics().active==2 and s.statistics().queued==2,"Two capacity slots and FIFO queue")
	check(s.view(12).eta==22 and s.view(13).eta==30,"Queued estimated completion includes wait and duration")
	var now: float = s.now
	s.advance(100,true)
	check(s.now==now and s.view(10).eta==12,"Learning pause holds authoritative scheduler")
	s.advance(12)
	check(s.view(10).investigation=="complete" and s.view(10).state=="WATCHLIST" and s.view(12).investigation=="active" and s.view(13).investigation=="queued","Completion starts FIFO head")
	check(s.view(10).awaiting_review,"Completed report awaits explicit review")
	act(s,10,"review")
	check(not s.view(10).awaiting_review and not act(s,10,"review").ok,"Review recorded once")
	s.advance(18)
	check(s.statistics().investigations_completed==4 and s.statistics().queue_delay_seconds==30,"Exact queue delays and deterministic completions")
	check(s.take_deliveries().map(func(r): return int(r.contact_id))==[10,11,12,13],"Deterministic completion order")
	check(s.take_deliveries().is_empty(),"Delivery drained once")
	var a := fresh()
	var b := fresh()
	for id in [10,11,12,13]:
		act(a,id,"investigate")
		act(b,id,"investigate")
	a.advance(30)
	for i in range(60): b.advance(0.5)
	check(a.events()==b.events() and a.statistics()==b.statistics(),"Frame partition invariant scheduling")
	var cancel := fresh()
	for id in [10,11,12]: act(cancel,id,"investigate")
	act(cancel,10,"escalate")
	act(cancel,10,"release")
	check(cancel.view(10).investigation=="cancelled" and cancel.view(12).investigation=="active","Final resolution cancels unfinished work and releases capacity")
	cancel.advance(100)
	check(not cancel.take_deliveries().any(func(r): return r.contact_id==10),"Cancelled job cannot deliver a report")
func validate_consequences() -> void:
	for action in ["intercept","hold_fire","release"]:
		var s := fresh()
		act(s,10,"escalate")
		act(s,10,action)
		var view: Dictionary = s.view(10)
		check(view.state=="RESOLVED" and not view.disposition.is_empty(),"Explicit disposition: "+action)
		check(s.events().filter(func(e): return e.kind=="command_issued").size()==1 and s.events().filter(func(e): return e.kind=="action_executed").size()==1 and s.events().filter(func(e): return e.kind=="outcome_observed").size()==1,"Command/execution/observation separately auditable")
		check(not JSON.stringify(view).contains("neutralized") and not JSON.stringify(view).contains("private_truth"),"No invented neutralization or truth")
	var data := config.duplicate(true)
	data.contacts[0].operational_deadline_seconds = 20
	var timed := fresh(data)
	act(timed,10,"escalate")
	timed.advance(5)
	act(timed,10,"stand_down")
	timed.advance(10)
	act(timed,10,"escalate")
	check(timed.view(10).remaining==5,"Re-escalation does not extend configured deadline")
	timed.advance(5)
	check(timed.view(10).disposition=="Encounter expired" and timed.statistics().hold_fire_decisions==0,"Configured expiry distinct from deliberate hold fire")
	check(timed.view(11).remaining==null,"Optional window never fabricated for other contacts")
	var overdue := fresh(data)
	act(overdue,10,"escalate")
	act(overdue,10,"stand_down")
	overdue.advance(21)
	act(overdue,10,"escalate")
	check(overdue.view(10).disposition=="Encounter expired" and not act(overdue,10,"intercept").ok,"Overdue re-escalation expires atomically without allowing a late response")
func check_private() -> void:
	var source: String = JSON.stringify(host.session.events()) + JSON.stringify(host.session.statistics()) + ui.detail.text
	for secret in ["covert_relay","peaceful_survey_probe","private_fixtures","actual_result","quality_penalty_pending"]:
		check(not source.contains(secret),"Public operation excludes "+secret)
func integration() -> void:
	command = load("res://scene/operational_command.tscn").instantiate()
	game = command
	test_viewport.add_child(command)
	pointer_at(Vector2(10,880))
	await frames()
	host = command.operations
	ui = host.ui
	check(host.error.is_empty() and command.registry.contacts.size()==18,"Main P9 startup with preserved population")
	var official: Dictionary = command.mission.public_snapshot()
	command.focus_center("DC-01",10)
	await frames()
	check(ui.local_panel.visible and ui.local_status.text.contains("MONITORED"),"Tactical state and command entry")
	await capture("p9_tactical")
	await click_at(ui.local_button.get_global_rect().get_center())
	check(ui.modal.visible and ui.selected==10,"Actual command-console input")
	await click_at(ui.actions.watch.get_global_rect().get_center())
	check(host.session.view(10).state=="WATCHLIST","Watchlist click")
	await click_at(ui.actions.investigate.get_global_rect().get_center())
	check(host.session.view(10).investigation=="active","Investigation click")
	await click_at(ui.close_button.get_global_rect().get_center())
	var moving = command.tactical_centers["DC-01"].get_node("EnemyContainer").get_child(3)
	pointer_at(moving.position)
	await frames()
	var travel: float = moving.total_orbit_travel
	var eta: float = host.session.view(10).eta
	await create_timer(0.15).timeout
	check(moving.is_hovered and moving.total_orbit_travel==travel,"P9 retains tactical contact hover-freeze")
	check(host.session.view(10).eta < eta,"Analyst work continues independently of contact hover")
	pointer_at(Vector2(10,880))
	await frames()
	await click_at(ui.local_button.get_global_rect().get_center())
	await click_at(ui.actions.escalate.get_global_rect().get_center())
	check(ui.confirmation.visible and host.session.view(10).state=="INVESTIGATING" and ui.confirm_button.disabled,"Escalation waits for explicit confirmation")
	check(ui.confirm_text.text.contains("C-010") and ui.confirm_text.text.contains("Confidence") and ui.confirm_text.text.contains("responses"),"Confirmation shows public contact/evidence/options")
	ui.reason_input.text = "Repeated concerning transmission pattern"
	ui.reason_input.text_changed.emit(ui.reason_input.text)
	await capture("p9_confirmation")
	await click_at(ui.confirm_button.get_global_rect().get_center())
	check(host.session.view(10).state=="ESCALATED" and host.session.view(10).escalation_evidence.assessment==ui.pending_evidence.assessment,"Confirmation records displayed evidence snapshot")
	var truth: Dictionary = command.registry.contacts[11].tactical.intelligence.debug_truth(11)
	host.execute(11,"investigate")
	host.execute(12,"investigate")
	check(host.session.statistics().active==2 and host.session.statistics().queued==1,"Network requests share capacity")
	command.set_learning_mode(true)
	command.set_strategic_pause(true)
	var frozen: float = host.session.now
	host._process(30)
	check(host.session.now==frozen,"Actual shared pause holds scheduler")
	command.set_learning_mode(false)
	command.show_overview()
	var realtime: float = host.session.now
	await create_timer(0.12).timeout
	check(host.session.now-realtime > 0.05 and host.session.now-realtime < 0.4,"Actual Challenge frames advance network scheduler once while offscreen")
	host._process(19)
	check(host.session.view(11).investigation=="complete" and host.session.view(12).investigation=="active","Challenge progresses offscreen and starts queued work")
	check(command.registry.contacts[11].tactical.intelligence.latest(11).assessment=="Assessed nonhostile","Investigation can decrease suspicion")
	check(command.registry.contacts[10].tactical.intelligence.latest(10).assessment=="Suspected hostile","Investigation can increase concern")
	check(host.session.view(10).state=="ESCALATED","Report revision does not undo escalation")
	check(command.registry.contacts[11].tactical.intelligence.debug_truth(11)==truth,"Peaceful private truth unchanged")
	check(command.registry.contacts[11].tactical.intelligence.history(11).back().supersedes.begins_with("R-011"),"Append retains prior chronology and supersession")
	var retained: Array = command.registry.contacts[11].tactical.intelligence.history(11)
	check(not command.registry.contacts[11].tactical.intelligence.append_operational_report(config.contacts[1].report) and command.registry.contacts[11].tactical.intelligence.history(11)==retained,"Duplicate delivery cannot append or rewrite report history")
	host._process(12)
	check(command.registry.contacts[12].tactical.intelligence.latest(12).confidence==100 and command.registry.contacts[12].tactical.intelligence.debug_truth(12).hostile,"Confident false negative remains possible")
	host.execute(13,"investigate")
	host._process(13)
	check(command.registry.contacts[13].tactical.intelligence.latest(13).assessment=="Uncertain","Investigation may remain ambiguous")
	var progress: float = host.session.now
	command.focus_center("DC-03",16)
	command.show_overview()
	command.focus_center("DC-01",10)
	check(host.session.now==progress,"Navigation cannot tick scheduler twice")
	ui.open_console(10)
	await frames()
	ui.filter.select(1)
	check(ui.filtered_ids()==[10],"Dedicated escalation filter")
	ui.filter.select(0)
	check(ui.filtered_ids()[0]==10,"Operational-priority sorting")
	ui.sorting.select(1)
	check(ui.filtered_ids()==all_ids,"Contact ID sorting")
	await capture("p9_operations")
	check_private()
	await click_at(ui.actions.intercept.get_global_rect().get_center())
	check(host.session.view(10).state=="RESOLVED" and host.session.statistics().interceptors_deployed==1,"Abstract deployment resolves once")
	check(ui.detail.text.contains("COMMAND:") and ui.detail.text.contains("EXECUTED:") and ui.detail.text.contains("OBSERVED:"),"Visible consequence stages")
	await capture("p9_resolution")
	check(command.mission.public_snapshot()==official,"P9 operations leave original official points/participants invariant")
	var operations_events: Array = host.session.events()
	command.focus_center("DC-01",1)
	command.tactical_centers["DC-01"]._on_command_requested("hold_fire")
	command.tactical_centers["DC-01"]._on_replay_requested()
	check(host.session.events()==operations_events,"Original encounter replay does not reset or farm operations")
	await click_at(ui.close_button.get_global_rect().get_center())
	check(not ui.modal.visible,"Return to tactical")
	command.focus_center("DC-01",10)
	await frames()
	check(command.queue_rows[10].get_text(6)=="RESOLVED","Strategic triage shows separate operational state")
	for node in [ui.local_button,ui.close_button,ui.filter,ui.sorting]+ui.actions.values():
		check(Rect2(0,0,1600,900).encloses(node.get_global_rect()),"Operational controls inside reference viewport")
	# Actual queue input focuses its associated center and retains elapsed state.
	ui.open_console(11)
	ui.filter.select(0)
	ui.sorting.select(1)
	await frames()
	var item: TreeItem = ui.queue.get_root().get_first_child().get_next().get_next().get_next()
	var before_navigation: float = host.session.now
	await click_at(ui.queue.global_position + ui.queue.get_item_area_rect(item).get_center())
	check(ui.selected==13 and command.focused_center=="DC-02" and command.tactical_centers["DC-02"].selected_attack_id==13,"Operational queue actual click navigates and highlights contact")
	check(host.session.now-before_navigation < 0.4,"Queue navigation adds only elapsed frames, not duplicate simulation time")
	ui.filter.select(6)
	check(ui.filtered_ids().size()==4,"Awaiting-review filter")
	await click_at(ui.actions.review.get_global_rect().get_center())
	check(not host.session.view(13).awaiting_review,"Rendered mark-reviewed command")
	await click_at(ui.close_button.get_global_rect().get_center())
	await click_at(command.mission_ui.scorecard_button.get_global_rect().get_center())
	check(command.scorecard_open and not ui.opener.visible,"Official mission scorecard remains accessible without operational overlay interference")
	await click_at(command.mission_ui.close_button.get_global_rect().get_center())
	check(not command.scorecard_open,"Original scorecard return still works")
	check(not paused,"No SceneTree pause")
	check(ui.summary.get_minimum_size().y <= ui.summary.size.y,"Operational summary fits above queue controls")
	check(ui.local_status.get_minimum_size().y <= ui.local_status.size.y,"Tactical operational status fits local panel")
	check_private()
	await close_game()
func invalid_startup() -> void:
	command = load("res://scene/operational_command.tscn").instantiate()
	command.operations_data_path = "user://missing_operations.json"
	game = command
	test_viewport.add_child(command)
	await frames()
	check(not command.operations.error.is_empty() and command.registry.contacts.size()==18,"Invalid operation config preserves accepted surveillance")
	command.operations.ui.open_console()
	await frames()
	check(command.operations.ui.summary.text.contains("UNAVAILABLE"),"Visible configuration error")
	await close_game()
