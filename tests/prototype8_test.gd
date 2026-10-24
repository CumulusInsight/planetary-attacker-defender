extends "res://tests/prototype4_test.gd"
const IntelLoader = preload("res://script/intelligence_data_loader.gd")
const IntelSession = preload("res://script/intelligence_session.gd")
const Traffic = preload("res://script/surveillance_contact.gd")
var command: Node
var config: Dictionary
var centers: Array

func run() -> void:
	centers = JSON.parse_string(FileAccess.get_file_as_string("res://data/strategic_centers.json")).centers
	config = IntelLoader.load_data("res://data/orbital_intelligence.json", centers).data
	validate_config()
	validate_models()
	await integration()
	await invalid_startup()
	await spawn_game()
	check(game.get_node("EnemyContainer").get_child_count() == 3 and game.intelligence == null, "Standalone tactical keeps accepted three-contact behavior")
	await close_game()
	print("PROTOTYPE 8 TEST: ", "PASS" if failures == 0 else "FAIL", " (", failures, " failures; ", checks, " checks)")
	quit(0 if failures == 0 else 1)

func validate_config() -> void:
	check(IntelLoader.validate(config, centers).is_empty(), "Valid intelligence configuration")
	for mutation in ["root", "duplicate", "center", "path", "direction", "rate", "bounds", "source", "release", "confidence", "optional", "history", "trigger", "truth", "fractional_id"]:
		var d: Variant = config.duplicate(true)
		match mutation:
			"root": d = []
			"duplicate": d.traffic[0].contact_id = 1
			"center": d.traffic[0].center_id = "missing"
			"path": d.traffic[0].path.erase("orientation")
			"direction": d.traffic[0].path.direction = 0.5
			"rate": d.traffic[0].path.angular_rate = -1
			"bounds": d.traffic[0].path.horizontal_radius = 800
			"source": d.reports[0].source_type = "Unknown"
			"release": d.reports[0].release.seconds = -1
			"confidence": d.reports[0].confidence = 101
			"optional": d.reports[0].recommendations = 5
			"history": d.reports[0].supersedes = "missing"
			"trigger": d.reports[0].release = {"type": "investigation"}
			"truth": d.private_fixtures["1"] = {"identity": "not allowed"}
			"fractional_id": d.reports[0].contact_id = 10.5
		check(not IntelLoader.validate(d, centers).is_empty(), "Reject invalid config: " + mutation)
	var minimal := config.duplicate(true)
	minimal.reports[0].erase("confidence")
	minimal.reports[0].erase("recommendations")
	minimal.reports[0].erase("supersedes")
	check(IntelLoader.validate(minimal, centers).is_empty(), "Optional information may be absent")
	check(not IntelLoader.load_data("user://missing_intelligence.json", centers).error.is_empty(), "Missing intelligence diagnostic")
	var file := FileAccess.open("user://bad_intelligence.json", FileAccess.WRITE)
	file.store_string("[invalid")
	file.close()
	check(not IntelLoader.load_data("user://bad_intelligence.json", centers).error.is_empty(), "Invalid syntax diagnostic")
	DirAccess.remove_absolute("user://bad_intelligence.json")

func validate_models() -> void:
	var contacts: Array = []
	for record in config.traffic:
		var a = Traffic.new()
		a.configure(int(record.contact_id), record.path)
		contacts.append(a)
		var other = Traffic.new()
		other.configure(int(record.contact_id), record.path)
		# Partition-invariant deterministic elapsed-phase evaluation.
		check(a.position_at(1.5).is_equal_approx(other.position_at(1.5)), "Deterministic ellipse")
		var p: Dictionary = record.path
		var phase: float = p.initial_phase + p.direction * p.angular_rate * 2.0
		var expected := Vector2(800,450) + Vector2(p.horizontal_radius*cos(phase), p.vertical_radius*sin(phase)).rotated(p.orientation)
		check(a.position_at(2.0).is_equal_approx(expected), "All path parameters applied")
		for step in range(180):
			var position: Vector2 = a.position_at(TAU / p.angular_rate * step / 180.0)
			check(position.x - 38 > 316 and position.x + 38 < 1280 and position.y - 38 > 48 and position.y + 38 < 900, "Full trajectory avoids essential interface")
		other.free()
	var session = IntelSession.new()
	session.configure(config.reports, config.private_fixtures, contacts)
	session.advance(contacts)
	check(session.latest(10).assessment == "Suspected hostile" and session.debug_truth(10).hostile, "Case A initial assessment matches private fixture")
	check(session.latest(11).confidence == 100 and not session.debug_truth(11).hostile, "Case B confident false positive")
	check(session.latest(12).assessment == "Assessed nonhostile" and session.debug_truth(12).hostile, "Case C false negative")
	var original_truth := session.debug_truth(12)
	for a in contacts: a.total_orbit_travel = a.move_speed * 16
	session.advance(contacts)
	check(session.latest(12).assessment == "Suspected hostile", "False negative reassessed with increasing concern")
	check(session.history(12).size() == 3, "Original reports retained in ordered history")
	for a in contacts: a.total_orbit_travel = a.move_speed * 46
	session.advance(contacts)
	check(session.latest(11).assessment == "Assessed nonhostile", "False positive revised")
	check(session.latest(12).confidence == 100 and session.latest(12).assessment == "Assessed nonhostile" and session.debug_truth(12) == original_truth, "Latest confident assessment can still be wrong; truth unchanged")
	check(session.latest(13).assessment == "Uncertain", "Case D ambiguity retained")
	check(session.latest(10).assessment == "Suspected hostile", "Case A supported by subsequent evidence")
	var copy := session.history(12)
	copy[0].text = "modified"
	check(session.history(12)[0].text != "modified", "Public copies cannot rewrite history")
	var repeat = IntelSession.new()
	for a in contacts: a.total_orbit_travel = 0
	repeat.configure(config.reports, config.private_fixtures, contacts)
	repeat.advance(contacts)
	for a in contacts: a.total_orbit_travel = a.move_speed * 46
	repeat.advance(contacts)
	check(repeat.history(12) == session.history(12), "Deterministic delivery independent of frame partition")
	var altered_truth: Dictionary = config.private_fixtures.duplicate(true)
	altered_truth["12"].hostile = false
	altered_truth["12"].identity = "different_private_identity"
	var alternate = IntelSession.new()
	for a in contacts: a.total_orbit_travel = 0
	alternate.configure(config.reports, altered_truth, contacts)
	for a in contacts: a.total_orbit_travel = a.move_speed * 46
	alternate.advance(contacts)
	check(alternate.history(12) == repeat.history(12), "Changing private truth cannot change public reports or metadata")
	for a in contacts: a.free()

func spawn_command() -> void:
	command = load("res://scene/orbital_command.tscn").instantiate()
	game = command
	test_viewport.add_child(command)
	pointer_at(Vector2(10,880))
	await frames()

func integration() -> void:
	await spawn_command()
	check(command.data_error.is_empty() and command.intelligence_error.is_empty(), "Prototype 8 startup")
	check(command.registry.contacts.size() == 18 and command.registry.centers.size() == 3, "Eighteen unique contacts at three centers")
	check(command.queue_rows.size() == 18, "Scrollable triage includes every contact")
	check(command.mission.public_snapshot().participants == 3, "Mission participant count remains three")
	var rows: Array = command.registry.public_rows()
	check(rows.filter(func(r): return r.remaining != null).size() == 3, "Exactly three active deadlines")
	for id in command.tactical_centers:
		var tactical = command.tactical_centers[id]
		check(tactical.get_node("EnemyContainer").get_child_count() == 6 and command.registry.center_summary(id).count == 6, "Six visible contacts per center")
		var signatures := {}
		for record in config.traffic:
			if record.center_id == id: signatures[JSON.stringify(record.path)] = true
		check(signatures.size() == 3, "Three distinct configured trajectories per center")
	for row in rows:
		if row.contact_id >= 10:
			var record: Dictionary = config.traffic[row.contact_id - 10]
			check(row.center_id == record.center_id and row.remaining == null and row.kind == "Passive surveillance", "Stable passive association without deadline")
	check(command.registry.triage(0).slice(0,3).map(func(r): return r.contact_id) == [7,1,4], "Deadline sorting retains only real deadlines first")
	var severity_rows: Array = command.registry.triage(1)
	for index in range(1,severity_rows.size()):
		check(severity_rows[index-1].severity >= severity_rows[index].severity, "Expanded severity queue uses public assessment")
	await capture("p8_overview")
	var last: TreeItem = command.queue_rows[18]
	command.queue.scroll_to_item(last)
	await frames()
	await click_at(command.queue.global_position + command.queue.get_item_area_rect(last).get_center())
	check(command.focused_center == "DC-03" and command.tactical_centers["DC-03"].selected_attack_id == 18, "Scrolled triage navigation")
	command.focus_center("DC-01", 10)
	var first = command.tactical_centers["DC-01"]
	panel = first.get_node("HUD/AttackInfoPanel")
	check(panel.deploy_button.disabled and panel.investigate_button.disabled and panel.replay_button.disabled, "Passive selection has no encounter controls")
	check(panel.get_node("Content/Countdown").text == "--:--:--", "Passive selection has no borrowed clock")
	var untouched: Dictionary = command.mission.public_snapshot()
	first._on_command_requested("deploy")
	first._on_command_requested("investigate")
	first._on_replay_requested()
	check(command.mission.public_snapshot() == untouched and not first.encounter.resolved and not first.encounter.investigated, "Passive commands and replay cannot affect active encounter or score")
	var traffic = first.get_node("EnemyContainer").get_child(3)
	# Place the contact at a known clear point of its configured ellipse.
	traffic.elapsed = 0
	traffic._update_position()
	pointer_at(traffic.position)
	await frames()
	var travel: float = traffic.total_orbit_travel
	var clock: float = first.deadline.remaining(first.active_contact)
	await create_timer(0.15).timeout
	check(traffic.is_hovered and traffic.total_orbit_travel == travel, "New hover freezes only that contact")
	check(first.deadline.remaining(first.active_contact) < clock, "Other contact deadline continues")
	var adjacent = first.get_node("EnemyContainer").get_child(4)
	adjacent.set_process(false)
	var adjacent_position: Vector2 = adjacent.position
	adjacent.position = traffic.position
	await frames()
	await click_at(traffic.position)
	check(traffic.is_hovered and not adjacent.is_hovered, "Held hover retains input priority when trajectories overlap")
	adjacent.position = adjacent_position
	adjacent.set_process(true)
	check(traffic.is_selected and first.selected_attack_id == 10, "Actual viewport click selects elliptical symbol")
	pointer_at(Vector2(10,880))
	await frames()
	await create_timer(0.1).timeout
	check(not traffic.is_hovered and traffic.total_orbit_travel > travel and traffic.total_orbit_travel - travel < 0.15, "Exit resumes without catch-up")
	command.set_learning_mode(true)
	command.set_strategic_pause(true)
	var history: Array = first.intelligence.history(10)
	var held: float = first.deadline.remaining(first.active_contact)
	traffic._process(40)
	first._process(0)
	check(first.intelligence.history(10) == history and first.deadline.remaining(first.active_contact) == held, "Shared pause prevents delivery while passive movement continues")
	command.set_strategic_pause(false)
	first._process(0)
	check(first.intelligence.history(10) == history, "No report catch-up after strategic pause")
	# Hover likewise freezes the movement-derived source schedule.
	traffic._on_area_2d_mouse_entered()
	traffic._process(20)
	first._process(0)
	check(first.intelligence.history(10) == history, "Hover also holds report progression")
	traffic._on_area_2d_mouse_exited()
	command.set_learning_mode(false)
	traffic._process(46)
	first._process(0)
	check(first.intelligence.history(10).size() == 4, "Challenge movement delivers timed reports")
	# Challenge release continues offscreen; navigation does not recapture time.
	command.show_overview()
	var third = command.tactical_centers["DC-03"]
	var offscreen = third.get_node("EnemyContainer").get_child(3)
	offscreen._process(17)
	third._process(0)
	check(third.intelligence.history(16).size() == 3, "Challenge source delivery progresses offscreen")
	var score: Dictionary = command.mission.public_snapshot()
	command.focus_center("DC-01", 1)
	first._on_command_requested("investigate")
	check(first.intelligence.latest(1).source_type == "Follow-up Analysis", "Existing investigation releases authored source report")
	check(command.mission.public_snapshot() == score, "Reports and investigation earn no points")
	first._on_command_requested("deploy")
	var official: Dictionary = command.mission.public_snapshot()
	var traffic_history: Array = first.intelligence.history(10)
	first._on_replay_requested()
	check(first.intelligence.history(1).is_empty() and first.intelligence.history(10) == traffic_history, "Replay resets only active source schedule")
	first._on_command_requested("hold_fire")
	check(command.mission.public_snapshot() == official, "Practice cannot change official points")
	command.focus_center("DC-01", 11)
	var false_positive = first.get_node("EnemyContainer").get_child(4)
	false_positive._on_area_2d_mouse_exited()
	false_positive._process(31)
	first._process(0)
	await frames()
	check(panel.reports_label.text.contains("PRIOR / newer") and panel.reports_label.text.contains("REVISED") and panel.reports_label.text.contains("Assessed nonhostile"), "History and current revised assessment readable")
	check(command.registry.public_rows().filter(func(r): return r.contact_id == 11)[0].assessment == "Assessed nonhostile", "Strategic view reflects reassessment")
	await capture("p8_tactical_history")
	for button in [panel.investigate_button,panel.deploy_button,panel.hold_button,panel.replay_button]:
		check(EXPECTED_BOUNDS.encloses(button.get_global_rect()), "Action controls remain accessible")
	for index in range(20): await click_at(panel.reports_scroll.get_global_rect().get_center(), MOUSE_BUTTON_WHEEL_DOWN)
	check(panel.reports_scroll.scroll_vertical > 0, "Prior reports accessible by scroll")
	await capture("p8_history_scrolled")
	var public_text: String = JSON.stringify(command.registry.public_rows()) + panel.reports_label.text + JSON.stringify(command.mission.public_snapshot())
	for secret in ["covert_relay", "peaceful_survey_probe", "private_fixtures", "actual_result", "quality_penalty_pending"]:
		check(not public_text.contains(secret), "No private truth in public presentation: " + secret)
	command.show_scorecard(true)
	await frames()
	check(command.mission_ui.modal.visible and Rect2(0,0,1600,900).encloses(command.mission_ui.close_button.get_global_rect()), "Scorecard access retained")
	await capture("p8_scorecard")
	await click_at(command.mission_ui.close_button.get_global_rect().get_center())
	check(not command.scorecard_open, "Scorecard returns to tactical")
	var before: float = first.deadline.remaining(first.active_contact)
	command.show_overview()
	command.focus_center("DC-02", 13)
	command.focus_center("DC-01", 1)
	check(first.deadline.remaining(first.active_contact) <= before, "Navigation never restarts deadlines")
	check(not paused, "No SceneTree pause")
	await close_game()

func invalid_startup() -> void:
	for path in ["user://missing_intelligence.json", "user://invalid_intelligence.json"]:
		var file := FileAccess.open("user://invalid_intelligence.json", FileAccess.WRITE)
		file.store_string("{}")
		file.close()
		command = load("res://scene/orbital_command.tscn").instantiate()
		command.intelligence_data_path = path
		game = command
		test_viewport.add_child(command)
		await frames()
		check(not command.intelligence_error.is_empty() and command.registry.contacts.size() == 9, "Invalid optional extension fails atomically without invented traffic")
		check(command.mission.public_snapshot().participants == 3, "Original encounter/mission preserved on extension error")
		check(command.surveillance_notice.text.contains("UNAVAILABLE"), "Configuration error has a visible public diagnostic without hidden fixture details")
		await close_game()
	DirAccess.remove_absolute("user://invalid_intelligence.json")
