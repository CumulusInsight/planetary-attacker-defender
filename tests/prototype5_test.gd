extends "res://tests/prototype4_test.gd"
## Reuses rendered input helpers, not the older suite's scenario assertions.

const ScenarioLoader = preload("res://script/encounter_data_loader.gd")
const Session = preload("res://script/encounter_session.gd")
const BAD_SCENARIO = "user://prototype5_invalid_encounter.json"


func run() -> void:
	await validate_live_deadline()
	validate_command_status()
	validate_sessions()
	validate_scenario_errors()
	for fixture in ["H", "N", "N100"]:
		await rendered_encounter(fixture)
	await game_errors()
	print("PROTOTYPE 5 TEST: ", "PASS" if failures == 0 else "FAIL", " (", failures, " failures; ", checks, " checks)")
	quit(0 if failures == 0 else 1)


func assert_public(view: Dictionary, truth: Dictionary, result: String = "") -> void:
	var source := JSON.stringify(view)
	for forbidden in ["private_truth", "actual_result", "attempted_attack", truth.identity, truth.objective]:
		check(not source.contains(forbidden), "Public projection excludes private identity/objective/keys: " + forbidden)
	for capability in truth.capabilities:
		check(not source.contains(capability), "Private capability is not exposed")
	if not result.is_empty():
		check(not source.contains(result), "Private resolution code is not exposed")
	check(view.title == "Unidentified contact", "Resolving an encounter does not reveal identity")


func validate_sessions() -> void:
	var data := ScenarioLoader.load_fixtures("res://data/encounters.json")
	check(data.error.is_empty() and data.fixtures.size() == 3, "Both scenarios and confidence variant load")
	check(data.fixtures.N.private_truth == data.fixtures.N100.private_truth, "100% variant shares neutral private truth")
	for id in ["H", "N", "N100"]:
		var session = Session.new()
		check(session.configure(data.fixtures[id], 1).is_empty(), "Session configures " + id)
		var initial: Dictionary = session.public_view(1)
		var truth: Dictionary = session.debug_state().truth
		assert_public(initial, truth)
		if id == "H":
			check(truth.intent == "hostile" and truth.capabilities.size() == 3 and truth.attempted_attack in truth.capabilities, "Hostile has limited profile and predetermined attempt")
		else:
			check(truth.intent == "peaceful" and truth.capabilities.is_empty() and truth.attempted_attack.is_empty(), "Neutral has no hostile objective/capability")
		if id == "N100":
			check(initial.intelligence.contains("100%") and initial.intelligence.contains("NOT verified fact"), "Complete confidence is explicitly subjective")
		for action in ["investigate", "deploy", "hold_fire"]:
			check(not session.act(2, action).ok, "Background cannot execute " + action)
		check(not session.reset(2), "Background cannot reset active encounter")
		check(session.public_view(1) == initial, "Background commands leave active state unchanged")
		check(not session.act(1, "unknown").ok, "Unknown action rejected")
		for investigated_first in [false, true]:
			for action in ["deploy", "hold_fire"]:
				var first_result: Dictionary = {}
				for replay in range(2):
					check(session.reset(1), "Explicit reset permitted for active contact")
					check(session.public_view(1) == initial, "Replay restores initial reports and commands")
					if investigated_first:
						check(session.act(1, "investigate").ok, "Investigation accepted")
						var followup: Dictionary = session.public_view(1)
						check(not session.resolved and session.investigated and not followup.follow_up.is_empty(), "Follow-up allows a subsequent decision")
						check(not session.act(1, "investigate").ok, "Unlimited investigation prevented")
						check(session.public_view(1) == followup, "Repeated investigation has no effect")
					check(session.debug_state().truth == truth, "Investigating cannot change hidden identity")
					check(session.act(1, action).ok and session.resolved, "Explicit decision resolves authored branch")
					var final_view: Dictionary = session.public_view(1)
					var actual: String = session.debug_state().actual_result
					var expected := "interference_blocked" if action == "deploy" else "interference_allowed"
					if id != "H":
						expected = "probe_interfered" if action == "deploy" else "legitimate_passage"
					check(actual == expected, "Correct deterministic branch: " + id + "/" + action)
					assert_public(final_view, truth, actual)
					check(not final_view.can_deploy and not final_view.can_hold_fire and not final_view.can_investigate, "Only replay remains after decision")
					check(not session.act(1, "hold_fire").ok and not session.act(1, "deploy").ok, "Resolved result cannot be overwritten")
					check(session.debug_state().truth == truth, "Defense does not rewrite private identity")
					if replay == 0:
						first_result = final_view
					else:
						check(final_view == first_result, "Replay is deterministic without RNG")
		# Returned views/debug dictionaries cannot mutate the authoritative fixture.
		var debug_copy: Dictionary = session.debug_state()
		debug_copy.truth.identity = "MUTATED"
		check(session.debug_state().truth == truth, "Debug inspection returns copies")
		check(not session.configure({}, 1).is_empty(), "Invalid reconfiguration rejected")
		check(not session.resolved and not session.investigated and session.active_contact_id == -1, "Invalid reconfiguration clears stale decision state")
		check(not session.act(1, "deploy").ok, "Invalid reconfiguration cannot use a previous fixture")
	var sentinel = data.fixtures.H.duplicate(true)
	sentinel.private_truth.identity = "SECRET_IDENTITY_SENTINEL"
	sentinel.private_truth.objective = "SECRET_OBJECTIVE_SENTINEL"
	sentinel.private_truth.capabilities = ["SECRET_A", "SECRET_B", "SECRET_C"]
	sentinel.private_truth.attempted_attack = "SECRET_A"
	var session = Session.new()
	check(session.configure(sentinel, 1).is_empty(), "Sentinel private fixture valid")
	assert_public(session.public_view(1), sentinel.private_truth)
	check(not session.public_view(2).can_deploy, "Background view disables encounter decisions")


func invalid_source(source: String, diagnostic: String) -> void:
	var file := FileAccess.open(BAD_SCENARIO, FileAccess.WRITE)
	file.store_string(source)
	file.close()
	var loaded := ScenarioLoader.load_fixtures(BAD_SCENARIO)
	check(loaded.fixtures.is_empty() and loaded.error.contains(diagnostic) and loaded.error.contains(BAD_SCENARIO), "Invalid scenario diagnostic: " + diagnostic)


func validate_scenario_errors() -> void:
	check(ScenarioLoader.load_fixtures("user://prototype5_missing/encounters.json").error.contains("cannot open"), "Missing scenario diagnostic")
	invalid_source("[invalid", "syntax error")
	invalid_source("[]", "root")
	invalid_source('{"fixtures":{}}', "expected exactly")
	var original = JSON.parse_string(FileAccess.get_file_as_string("res://data/encounters.json"))
	for section in ["private_truth", "reports", "outcomes"]:
		var data = original.duplicate(true)
		data.fixtures.H.erase(section)
		invalid_source(JSON.stringify(data), section)
	for confidence in [true, "100", null, -1, 101]:
		var data = original.duplicate(true)
		data.fixtures.N.reports.intelligence.confidence = confidence
		invalid_source(JSON.stringify(data), "confidence")
	var data = original.duplicate(true)
	data.fixtures.H.private_truth.capabilities = ["only_one"]
	invalid_source(JSON.stringify(data), "three capabilities")
	data = original.duplicate(true)
	data.fixtures.H.private_truth.attempted_attack = "outside_profile"
	invalid_source(JSON.stringify(data), "attempted_attack")
	data = original.duplicate(true)
	data.fixtures.N.private_truth.capabilities = ["unexpected"]
	invalid_source(JSON.stringify(data), "peaceful contact")
	data = original.duplicate(true)
	data.fixtures.N100.private_truth.identity = "different identity"
	invalid_source(JSON.stringify(data), "preserve N")
	data = original.duplicate(true)
	data.fixtures.H.outcomes.deploy.erase("observation")
	invalid_source(JSON.stringify(data), "observation")
	data = original.duplicate(true)
	data.fixtures.H.reports.sigint.limitation = "  "
	invalid_source(JSON.stringify(data), "limitation")
	data = original.duplicate(true)
	data.fixtures.N.outcomes.deploy.actual_result = "interference_blocked"
	invalid_source(JSON.stringify(data), "authored peaceful branch")
	data = original.duplicate(true)
	data.fixtures.N100.outcomes.hold_fire.observation = "Changed outcome for confidence alone"
	invalid_source(JSON.stringify(data), "preserve N's deterministic outcomes")
	DirAccess.remove_absolute(BAD_SCENARIO)


func spawn_fixture(id: String, path: String = "res://data/encounters.json") -> void:
	game = load("res://scene/game.tscn").instantiate()
	game.developer_fixture = id
	game.encounter_data_path = path
	test_viewport.add_child(game)
	pointer_at(Vector2(40, 40))
	await frames()
	panel = game.get_node("HUD/AttackInfoPanel")


func assert_console_private() -> void:
	var debug: Dictionary = game.encounter.debug_state()
	var visible_text := ""
	for label in game.find_children("*", "Label"):
		if label.is_visible_in_tree():
			visible_text += label.text + "\n"
	for forbidden in [debug.truth.identity, debug.truth.objective, "private_truth", "attempted_attack", "actual_result", "VM ESC", "ROOTKIT", "FILELESS"]:
		check(not visible_text.contains(forbidden), "Visible text excludes private/legacy identity: " + forbidden)
	for capability in debug.truth.capabilities:
		check(not visible_text.contains(capability), "Visible text excludes private capability")
	check(panel.get_global_rect().is_equal_approx(EXPECTED_BOUNDS), "Command console keeps original bounds: " + str(panel.get_global_rect()))


func rendered_encounter(id: String) -> void:
	await spawn_fixture(id)
	var contacts = game.get_node("EnemyContainer").get_children()
	check(contacts.size() == 3 and game.encounter_error.is_empty(), "Exactly three contacts and one valid encounter")
	check(game.encounter.active_contact_id == contacts[0].attack_id, "Only first stable contact hosts encounter")
	check(contacts[0].get_node("Sprite2D").texture.resource_path == "res://images/enemy1.png", "Same contact artwork in every fixture")
	for index in range(3):
		check(contacts[index].get_node("AttackLabel").text == "C-%03d" % contacts[index].attack_id, "Stable contact-only labels")
		check(is_equal_approx(contacts[index].move_speed, [0.49, 0.63, 0.77][index]), "Accepted movement speed preserved")
	check(panel.investigate_button.disabled and panel.deploy_button.disabled and panel.hold_button.disabled, "No command before contact selection")
	var active = contacts[0]
	pointer_at(active.position)
	await frames()
	var held := motion_state(active)
	var other_angles = [contacts[1].orbit_angle, contacts[2].orbit_angle]
	await create_timer(0.2).timeout
	check(active.is_hovered and motion_state(active) == held, "Hover freeze preserves exact state without popup")
	for index in range(3):
		check(not contacts[index].get_node("InfoPanel").visible, "No floating hover popups")
	check(contacts[1].orbit_angle != other_angles[0] and contacts[2].orbit_angle != other_angles[1], "Only hovered contact pauses")
	await click_at(active.position)
	check(panel.displayed_attack_id == active.attack_id and active.is_selected, "Frozen contact click selects console")
	check(panel.reports_label.text.contains("INTELLIGENCE") and panel.reports_label.text.contains("SIGINT") and panel.reports_label.text.contains("NOT verified fact"), "Reports explicitly distinguish confidence from verification")
	if id == "N100":
		check(panel.reports_label.text.contains("100%"), "Incorrect complete confidence appears as assessment")
	assert_console_private()
	check(panel.get_node("Content/Countdown").text != "--:--:--", "Active live deadline shown prominently")
	check(panel.resources_label.get_global_rect().end.y <= panel.reports_scroll.get_global_rect().position.y, "Resources do not overlap reports")
	await capture("p5_%s_initial" % id)
	for background in [contacts[1], contacts[2]]:
		await click_at(background.position)
		check(panel.get_node("Content/Countdown").text == "--:--:--" and panel.resources_label.text.contains("Est. analysis: Unavailable"), "Background UI does not inherit active timing")
		check(background.is_selected and panel.displayed_attack_id == background.attack_id, "Background remains selectable")
		check(panel.deploy_button.disabled and panel.hold_button.disabled and panel.investigate_button.disabled, "Background has no encounter actions")
		game._on_command_requested("deploy")
		game._on_replay_requested()
		check(not game.encounter.resolved and not game.encounter.investigated, "Background cannot accidentally resolve/reset active encounter")
	await click_at(active.position)
	await click_at(panel.investigate_button.get_global_rect().get_center())
	check(game.encounter.investigated and not game.encounter.resolved, "Real console investigation shows follow-up without resolution")
	check(panel.reports_label.text.contains("FOLLOW-UP") and panel.investigate_button.disabled and not panel.deploy_button.disabled, "Only one follow-up, subsequent decision available")
	var followup: Dictionary = game.encounter.public_view(active.attack_id)
	await click_at(panel.investigate_button.get_global_rect().get_center())
	check(game.encounter.public_view(active.attack_id) == followup, "Disabled investigation cannot repeat")
	await capture("p5_%s_followup" % id)
	for action in ["deploy", "hold_fire"]:
		var button = panel.deploy_button if action == "deploy" else panel.hold_button
		await click_at(button.get_global_rect().get_center())
		check(game.encounter.resolved, "Real console decision resolves encounter")
		var expected := "interference_blocked" if action == "deploy" else "interference_allowed"
		if id != "H":
			expected = "probe_interfered" if action == "deploy" else "legitimate_passage"
		check(game.encounter.debug_state().actual_result == expected, "Rendered branch has correct private outcome")
		check(panel.reports_label.text.contains("PLAYER DECISION") and panel.reports_label.text.contains("OBSERVED AFTERWARD") and panel.reports_label.text.contains("STILL UNCERTAIN"), "Decision, observations, and remaining uncertainty distinguished")
		check(panel.contact_label.text == "Unidentified contact", "Console never reveals resolved identity")
		var scroll_bar = panel.reports_scroll.get_v_scroll_bar()
		check(panel.reports_scroll.scroll_vertical >= int(scroll_bar.max_value - scroll_bar.page) - 1, "Outcome scroll reaches the updated observation and uncertainty")
		assert_console_private()
		await capture("p5_%s_%s" % [id, action])
		var angles = contacts.map(func(c): return c.orbit_angle)
		await create_timer(0.15).timeout
		for index in range(3):
			check(contacts[index].orbit_angle != angles[index], "Outcome does not stop orbital motion")
		check(panel.deploy_button.disabled and panel.hold_button.disabled and panel.investigate_button.disabled and not panel.replay_button.disabled, "Resolution locks decisions and enables replay")
		var previous_angle: float = active.orbit_angle
		await click_at(panel.replay_button.get_global_rect().get_center())
		check(not game.encounter.resolved and not game.encounter.investigated, "Replay restores decision and one investigation")
		check(panel.investigate_button.disabled == false and not panel.reports_label.text.contains("OBSERVED AFTERWARD"), "Replay clears previous observations")
		check(fposmod(active.orbit_angle - game.deadline.initial.angle, TAU) < active.move_speed * 0.3 and active.current_ring == game.deadline.initial.ring, "Replay restores captured active movement state")
		check(active.is_selected and panel.displayed_attack_id == active.attack_id, "Replay retains contact selection")
	check(not paused, "No global pause in any encounter action")
	await close_game()


func game_errors() -> void:
	for source in ["user://prototype5_missing/encounters.json", BAD_SCENARIO, "res://data/encounters.json"]:
		if source == BAD_SCENARIO:
			var file := FileAccess.open(source, FileAccess.WRITE)
			file.store_string("[invalid")
			file.close()
		await spawn_fixture("unknown" if source.begins_with("res://") else "H", source)
		check(not game.encounter_error.is_empty(), "Scenario errors have diagnostics, no fallback")
		check(panel.contact_label.text == "Command unavailable" and panel.reports_label.text.is_empty(), "No partial/private scenario information on failure")
		var contacts = game.get_node("EnemyContainer").get_children()
		var angles = contacts.map(func(c): return c.orbit_angle)
		await create_timer(0.1).timeout
		for index in range(3):
			check(contacts[index].orbit_angle != angles[index], "Scenario-data error preserves existing motion")
		await click_at(contacts[0].position)
		game._on_command_requested("hold_fire")
		check(not game.encounter.resolved and panel.deploy_button.disabled and panel.hold_button.disabled, "Invalid data cannot resolve an encounter")
		await close_game()
	DirAccess.remove_absolute(BAD_SCENARIO)


func validate_command_status() -> void:
	var provider = load("res://script/command_status.gd")
	for pair in [[0, "00:00:00"], [9, "00:00:09"], [65, "00:01:05"], [3661, "01:01:01"], [188130, "2 days 04:15:30"]]:
		check(provider.format_time(pair[0]) == pair[1], "Time formatting: " + str(pair[0]))
	for invalid in [null, -1, 1.5, "60", true, INF, NAN]:
		check(provider.format_time(invalid) == "Unavailable", "Invalid duration is unavailable")
	var data: Dictionary = provider.demonstration(1)
	var text: String = provider.present(data, 1)
	for expected in ["DEMO", "not scheduled", "8 total", "Available: 5", "Occupied: 3", "Objects of concern: 1", "Awaiting analysis: 1", "Reports awaiting decision: 1", "Est. analysis: 00:12:45"]:
		check(text.contains(expected), "Demo resource label: " + expected)
	check(not provider.present(data, 2).contains("Time to act"), "Demo resources cannot fabricate a live deadline")
	check(provider.present(data, 2).contains("Est. analysis: Unavailable"), "Background cannot inherit active analysis")
	for key in ["total", "available", "occupied", "concern", "awaiting_analysis", "awaiting_decision"]:
		var broken := data.duplicate(true)
		broken.erase(key)
		check(provider.present(broken, 1).contains("Resource values unavailable"), "Missing resource safe: " + key)
		broken[key] = -1
		check(provider.present(broken, 1).contains("Resource values unavailable"), "Invalid resource safe: " + key)
	var inconsistent := data.duplicate(true)
	inconsistent.available = 8
	check(provider.present(inconsistent, 1).contains("Resource values unavailable"), "Staff accounting checked")


func validate_live_deadline() -> void:
	for fixture in ["H", "N", "N100"]:
		await spawn_fixture(fixture)
		var live_before: float = game.deadline.remaining(game.active_contact)
		await create_timer(0.12).timeout
		check(game.deadline.remaining(game.active_contact) < live_before, "Rendered simulation continuously advances countdown")
		game._on_attacker_selected(game.active_contact.attack_id)
		await click_at(panel.get_node("Content/Reading").get_global_rect().get_center())
		var reading_before: float = game.deadline.remaining(game.active_contact)
		var bg_before: float = game.get_node("EnemyContainer").get_child(1).total_orbit_travel
		await create_timer(0.15).timeout
		check(game.reading and game.deadline.remaining(game.active_contact) == reading_before, "Rendered reading toggle holds authoritative countdown")
		check(game.get_node("EnemyContainer").get_child(1).total_orbit_travel > bg_before, "Reading leaves background moving")
		await click_at(panel.get_node("Content/Reading").get_global_rect().get_center())
		check(not game.reading, "Rendered reading toggle exits pause")
		game.set_process(false)
		var contacts = game.get_node("EnemyContainer").get_children()
		for c in contacts:
			c.set_process(false)
		var active = contacts[0]
		game.deadline.restore(active)
		active.is_hovered = false
		game._on_attacker_selected(active.attack_id)
		var full: float = game.decision_window_seconds
		check(is_equal_approx(game.deadline.remaining(active), full), "Deadline defaults to five active minutes")
		check(is_equal_approx(full, 300.0), "Configurable default is 300 seconds")
		var custom = load("res://script/orbital_deadline.gd").new()
		check(custom.capture(active, 600.0) and is_equal_approx(custom.remaining(active), 600.0), "Custom window converted to travel budget")
		var background_travel: float = contacts[1].total_orbit_travel
		for step in [1.0, TAU / active.move_speed, TAU / active.move_speed]:
			var before: float = game.deadline.remaining(active)
			active._process(step)
			game._process(0.0)
			check(is_equal_approx(game.deadline.remaining(active), before - step), "Countdown tracks actual travel across ring jumps")
		check(active.current_ring == 0 and not game.encounter.resolved, "Innermost arrival is not collision or expiry")
		game._set_learning_mode(true)
		game._set_reading(true)
		var learning_before: float = game.deadline.remaining(active)
		var learning_state := motion_state(active)
		active._process(60.0)
		contacts[1]._process(0.5)
		game._process(0.0)
		check(motion_state(active) == learning_state and game.deadline.remaining(active) == learning_before, "Reading freezes active motion and clock exactly")
		check(panel.get_node("Content/Urgency").text.contains("READING"), "Reading pause visibly identified")
		await frames()
		await capture("p5_learning")
		game._set_reading(false)
		active._process(0.1)
		check(is_equal_approx(game.deadline.remaining(active), learning_before - 0.1), "Learning exit resumes without catch-up")
		game._set_reading(true)
		game._set_learning_mode(false)
		check(not active.learning_paused and not game.reading, "Challenge releases reading pause")
		var challenge_before: float = game.deadline.remaining(active)
		active._process(0.2)
		check(is_equal_approx(game.deadline.remaining(active), challenge_before - 0.2), "Active Challenge progresses normally")
		game._process(0.0)
		await frames()
		await capture("p5_active_challenge")
		var frozen: float = game.deadline.remaining(active)
		active._on_area_2d_mouse_entered()
		active._process(50.0)
		contacts[1]._process(1.0)
		game._process(0.0)
		check(game.deadline.remaining(active) == frozen and contacts[1].total_orbit_travel > background_travel, "Hover holds deadline only for active contact")
		active._on_area_2d_mouse_exited()
		active._process(0.25)
		check(is_equal_approx(game.deadline.remaining(active), frozen - 0.25), "Resume has no catch-up")
		for id in [contacts[1].attack_id, active.attack_id, active.attack_id]:
			var before: float = game.deadline.remaining(active)
			game._on_attacker_selected(id)
			check(game.deadline.remaining(active) == before, "Selection never extends deadline")
		game._on_command_requested("investigate")
		check(is_equal_approx(game.deadline.remaining(active), frozen - 0.25), "Investigation does not reset deadline")
		game._on_attacker_selected(contacts[1].attack_id)
		active._process(game.deadline.remaining(active) + 0.001)
		game._process(0.0)
		check(game.encounter.resolved and game.encounter.debug_state().decision == "expired", "Expiration is separate recorded decision")
		check(game.encounter.debug_state().actual_result == ("interference_allowed" if fixture == "H" else "legitimate_passage"), "Authored deterministic no-intervention branch")
		check(panel.get_node("Content/Countdown").text == "--:--:--", "Active expiration stays off background countdown")
		game._on_attacker_selected(active.attack_id)
		check(panel.status_label.text == "Deadline expired" and panel.deploy_button.disabled and panel.investigate_button.disabled and panel.hold_button.disabled, "Late timely actions disabled")
		game._on_command_requested("deploy")
		check(game.encounter.debug_state().decision == "expired", "Late defense cannot replace expiry")
		assert_console_private()
		await frames()
		await capture("p5_%s_expired" % fixture)
		var other: float = contacts[1].total_orbit_travel
		game._on_replay_requested()
		check(is_equal_approx(game.deadline.remaining(active), full) and active.current_ring == game.deadline.initial.ring and active.orbit_progress == game.deadline.initial.progress, "Replay restores full authoritative motion and countdown")
		check(contacts[1].total_orbit_travel == other, "Replay leaves background motion untouched")
		game._on_command_requested("hold_fire")
		check(game.encounter.debug_state().decision == "hold_fire", "Explicit hold fire is distinct from expiry")
		game._on_replay_requested()
		active._process(full)
		game._process(0.0)
		check(game.encounter.debug_state().decision == "expired", "Replay same elapsed progression expires deterministically")
		panel.show_clock(188130.0)
		await frames()
		check(panel.get_global_rect().is_equal_approx(EXPECTED_BOUNDS), "Days-format countdown stays within fixed console")
		for button in [panel.investigate_button, panel.deploy_button, panel.hold_button, panel.replay_button]:
			check(EXPECTED_BOUNDS.encloses(button.get_global_rect()), "All controls remain accessible")
		check(panel.reports_scroll.size.y >= 120.0, "Reports retain readable scroll area")
		await capture("p5_clock_days")
		await close_game()
