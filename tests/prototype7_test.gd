extends "res://tests/prototype4_test.gd"
const MissionLoader = preload("res://script/mission_data_loader.gd")
const Ledger = preload("res://script/mission_ledger.gd")
var command: Node
var definition: Dictionary
var fixtures: Dictionary

func run() -> void:
	definition = MissionLoader.load_mission("res://data/mission.json").data
	fixtures = JSON.parse_string(FileAccess.get_file_as_string("res://data/encounters.json")).fixtures
	validate_data()
	validate_ledger()
	await rendered_mission()
	await rendered_expiration()
	await invalid_missions()
	print("PROTOTYPE 7 TEST: ", "PASS" if failures == 0 else "FAIL", " (", failures, " failures; ", checks, " checks)")
	quit(0 if failures == 0 else 1)

func event(fixture: String, action: String, id: int) -> Dictionary:
	var branch: String = "hold_fire" if action == "expired" else action
	var result: Dictionary = fixtures[fixture].outcomes[branch]
	return {"contact_id": id, "decision": action, "actual_result": result.actual_result,
		"observation": result.observation, "uncertainty": result.uncertainty}

func fresh() -> RefCounted:
	var ledger = Ledger.new()
	check(ledger.configure(definition, {"DC-01": 1, "DC-02": 4, "DC-03": 7}).is_empty(), "Mission configures with three independent participants")
	return ledger

func category(view: Dictionary, id: String) -> Dictionary:
	for item in view.categories:
		if item.id == id: return item
	return {}

func validate_data() -> void:
	check(MissionLoader.validate(definition).is_empty(), "Mission validates")
	check(definition.maximum_points == 1000 and definition.defender_weights.asset_protection == 350 and definition.defender_weights.threat_resolution == 250 and definition.defender_weights.decision_quality == 200 and definition.defender_weights.resource_management == 100 and definition.defender_weights.command_effectiveness == 100, "Requested configurable default weights")
	check(definition.attacker_future.implemented == false and definition.attacker_future.weights.mission_objectives_achieved == 400, "Attacker model is separate future config only")
	for mutation in ["missing_weight", "negative_weight", "weight_sum", "duplicate_objective", "missing_short_text", "missing_rule_fraction", "uncertain_credit", "bad_replay", "enabled_attacker", "missing_reason"]:
		var data := definition.duplicate(true)
		match mutation:
			"missing_weight": data.defender_weights.erase("decision_quality")
			"negative_weight": data.defender_weights.asset_protection = -1
			"weight_sum": data.maximum_points = 999
			"duplicate_objective": data.objectives[1].objective_id = data.objectives[0].objective_id
			"missing_short_text": data.objectives[0].erase("short_text")
			"missing_rule_fraction": data.public_evidence_rules[0].erase("resolution_fraction")
			"uncertain_credit": data.public_evidence_rules[3].resolution_fraction = 1.0
			"bad_replay": data.replay_policy = "repeatable_rewards"
			"enabled_attacker": data.attacker_future.implemented = true
			"missing_reason": data.unassessed_reasons.erase("resource_management")
		check(not MissionLoader.validate(data).is_empty(), "Malformed config rejected: " + mutation)
	var balanced := definition.duplicate(true)
	balanced.defender_weights.threat_resolution = 200
	balanced.defender_weights.asset_protection = 400
	check(MissionLoader.validate(balanced).is_empty(), "Weights configurable without UI code edits")
	var ledger = Ledger.new()
	check(not ledger.configure(definition, {"DC-01": 1, "DC-02": 1}).is_empty(), "Duplicate participant rejected")

func validate_ledger() -> void:
	var ledger = fresh()
	var initial: Dictionary = ledger.public_snapshot()
	check(initial.confirmed_points == null and initial.assessed_maximum == 0.0 and initial.unassessed_maximum == 1000.0, "Unavailable categories are not earned zeroes")
	check(initial.objectives.size() == 5 and initial.resolved == 0 and not initial.complete, "Five mission objectives and no invented dispositions")
	for key in MissionLoader.DEFENDER:
		check(category(initial, key).points == null, "Initial category unassessed: " + key)
	check(not ledger.record_resolution("DC-02", event("H", "deploy", 1)).ok, "Cross-center event cannot contaminate ledger")
	check(not ledger.record_resolution("DC-01", {"contact_id": 1, "decision": "investigate"}).ok, "Investigation is not a scored resolution")
	for pair in [["DC-01", "H", "deploy", 1], ["DC-02", "N100", "hold_fire", 4], ["DC-03", "N", "hold_fire", 7]]:
		var before_other: Dictionary = ledger.public_snapshot("DC-03")
		check(ledger.record_resolution(pair[0], event(pair[1], pair[2], pair[3])).recorded, "First deterministic disposition recorded")
		if pair[0] != "DC-03": check(ledger.public_snapshot("DC-03") == before_other, "Other center's score isolated")
	var final_view: Dictionary = ledger.public_snapshot()
	check(final_view.complete and final_view.resolved == 3 and final_view.timely == 3, "Mission concludes after three official first resolutions")
	check(is_equal_approx(final_view.confirmed_points, 350.0) and is_equal_approx(final_view.assessed_maximum, 350.0) and is_equal_approx(final_view.unassessed_maximum, 650.0), "Confirmed effects/timeliness total 350; unsupported 650 remains unassessed")
	check(is_equal_approx(category(final_view, "threat_resolution").points, 250.0), "Effective block and deliberate quiet passage recognized")
	for key in ["asset_protection", "decision_quality", "resource_management"]:
		check(category(final_view, key).points == null, "Final unavailable category remains unassessed: " + key)
	for index in range(5):
		check(not ledger.record_resolution("DC-01", event("H", "hold_fire", 1)).recorded, "Repeated/replayed resolutions cannot farm or overwrite score")
	check(ledger.public_snapshot() == final_view, "Official score immutable under practice replays")
	var total := 0.0
	for center in ["DC-01", "DC-02", "DC-03"]:
		total += ledger.public_snapshot(center).confirmed_points
	check(is_equal_approx(total, final_view.confirmed_points), "Local contributions sum to network score")
	for fixture in ["H", "N", "N100"]:
		for action in ["deploy", "hold_fire", "expired"]:
			var one = fresh()
			one.record_resolution("DC-01", event(fixture, action, 1))
			var review: Dictionary = one.debug_review("DC-01")
			var public: Dictionary = one.public_snapshot()
			check(review.correct_decision == ((fixture == "H" and action == "deploy") or (fixture != "H" and action == "hold_fire")), "Actual deterministic adjudication ignores assessed confidence")
			if action == "expired":
				check(public.expired == 1 and public.timely == 0 and public.confirmed_points == 0.0, "Expired quiet passage is not rewarded as intentional hold fire")
			if fixture != "H" and action == "deploy":
				check(review.unnecessary_engagement and review.quality_penalty_pending > 0.0, "Actual unnecessary engagement has private pending penalty")
				check(category(public, "threat_resolution").points == null and category(public, "decision_quality").points == null, "High-assessed peaceful deployment earns no confirmed defense/quality reward")
			assert_public(public)
	# Identical public evidence/action must be indistinguishable even if private adjudication differs.
	var private_a = fresh()
	var private_b = fresh()
	var same := event("N", "deploy", 1)
	private_a.record_resolution("DC-01", same)
	same.actual_result = "interference_blocked"
	private_b.record_resolution("DC-01", same)
	check(private_a.debug_review("DC-01") != private_b.debug_review("DC-01"), "Private outcomes can differ")
	check(private_a.public_snapshot() == private_b.public_snapshot(), "No hidden-truth scoring side channel for identical public facts")
	var altered: Dictionary = final_view.duplicate(true)
	altered.outcomes[0].observation = "changed"
	check(ledger.public_snapshot() != altered, "Public snapshots cannot mutate ledger state")
	var unknown = fresh()
	var unknown_event := event("H", "deploy", 1)
	unknown_event.observation = "Unreviewed observation"
	unknown.record_resolution("DC-01", unknown_event)
	check(category(unknown.public_snapshot(), "threat_resolution").points == null, "Unreviewed evidence is unassessed, never fabricated")

func assert_public(view: Dictionary) -> void:
	var source := JSON.stringify(view)
	check(not source.contains('"unnecessary_engagement":'), "Private engagement verdict is absent; public objective ID is allowed")
	for forbidden in ["actual_result", "private_review", "correct_decision", "quality_penalty_pending", "attacker_future", "Martian covert operative", "Neutral planetary research probe", "interference_blocked", "probe_interfered", "uplink_override"]:
		check(not source.contains(forbidden), "Public score projection excludes " + forbidden)

func spawn_command(path: String = "res://data/mission.json") -> void:
	command = load("res://scene/command_center.tscn").instantiate()
	command.mission_data_path = path
	game = command
	test_viewport.add_child(command)
	pointer_at(Vector2(10, 880))
	await frames()

func rendered_mission() -> void:
	await spawn_command()
	check(command.mission_error.is_empty() and command.registry.contacts.size() == 9, "Prototype 7 retains three-center nine-contact simulation")
	check(command.command_level == "operations" and command.mission_ui.level_control.item_count == 2, "Exactly two implemented command levels")
	check(command.mission_ui.network_label.visible and not command.mission_ui.local_panel.visible, "Network responsibility shown to Operations Commander")
	check(command.mission_ui.network_label.get_global_rect().end.y <= command.center_buttons["DC-01"].get_global_rect().position.y, "Network scoreboard does not overlap center cards")
	await capture("p7_operations_initial")
	command.set_strategic_pause(true)
	var states := all_states()
	command.mission_ui.level_control.select(1)
	command.mission_ui.level_control.item_selected.emit(1)
	await frames()
	check(command.command_level == "tactical" and command.focused_center == "DC-01", "Role selector opens Tactical Officer focus")
	check(all_states() == states, "Command level does not change timers, physics or truth while paused")
	var first = command.tactical_centers["DC-01"]
	command.focus_center("DC-01", 1)
	panel = first.get_node("HUD/AttackInfoPanel")
	check(command.mission_ui.local_panel.visible and not command.mission_ui.network_label.visible, "Tactical Officer gets local objectives/performance")
	for objective in command.mission.public_snapshot().objectives:
		check(command.mission_ui.local_label.text.contains(objective.short_text), "Local objectives come from mission data")
	check(command.mission_ui.local_panel.get_global_rect().end.x < 328, "Local display stays outside enlarged orbital click area")
	check(panel.get_global_rect().is_equal_approx(EXPECTED_BOUNDS), "Accepted intelligence console bounds preserved")
	var before: Dictionary = command.mission.public_snapshot()
	await click_at(panel.investigate_button.get_global_rect().get_center())
	check(first.encounter.investigated and command.mission.public_snapshot() == before, "Investigation awards no points")
	for index in range(3):
		command.show_overview()
		command.focus_center("DC-01", 1)
	check(command.mission.public_snapshot() == before, "Navigation awards no points")
	check(command.mission_ui.local_label.get_minimum_size().y <= command.mission_ui.local_label.size.y and command.mission_ui.local_label.get_global_rect().end.y <= command.mission_ui.local_panel.get_global_rect().end.y, "Local objective/status text fits its panel")
	await capture("p7_tactical_objectives")
	await click_at(panel.deploy_button.get_global_rect().get_center())
	check(command.mission.public_snapshot().resolved == 1, "Actual resolution signal appends one official event")
	var official: Dictionary = command.mission.public_snapshot()
	await click_at(panel.deploy_button.get_global_rect().get_center())
	check(command.mission.public_snapshot() == official, "Disabled repeat button cannot farm")
	await click_at(panel.replay_button.get_global_rect().get_center())
	check(not first.encounter.resolved and first.active_contact.strategic_paused, "Replay keeps accepted shared pause")
	await click_at(panel.hold_button.get_global_rect().get_center())
	check(command.mission.public_snapshot() == official, "Practice outcome cannot replace first official score")
	# Selected high-confidence neutral contact: actual response may be harmful, never automatic defense reward.
	command.focus_center("DC-02", 4)
	panel = command.tactical_centers["DC-02"].get_node("HUD/AttackInfoPanel")
	await frames()
	await capture("p7_neutral_before")
	await click_at(panel.deploy_button.get_global_rect().get_center())
	check(command.mission.debug_review("DC-02").get("quality_penalty_pending", -1) > 0.0, "Neutral engagement penalty recorded privately")
	check(category(command.mission.public_snapshot("DC-02"), "threat_resolution").points == null, "Neutral defense is not treated as successful threat resolution")
	command.focus_center("DC-03", 7)
	panel = command.tactical_centers["DC-03"].get_node("HUD/AttackInfoPanel")
	await frames()
	await click_at(panel.hold_button.get_global_rect().get_center())
	var final_view: Dictionary = command.mission.public_snapshot()
	check(final_view.complete and final_view.resolved == 3, "Final mission scorecard available after all official dispositions")
	assert_public(final_view)
	command.show_overview()
	await frames()
	check(command.mission_ui.scorecard_button.text.contains("Final"), "Clear final scorecard entry")
	await capture("p7_operations_final")
	await click_at(command.mission_ui.scorecard_button.get_global_rect().get_center())
	check(command.scorecard_open and command.mission_ui.modal.visible, "Actual scorecard button opens detailed panel")
	await frames()
	var text: String = command.mission_ui.card_label.text
	for category_name in ["ASSET PROTECTION", "THREAT RESOLUTION", "DECISION QUALITY", "RESOURCE MANAGEMENT", "COMMAND EFFECTIVENESS"]:
		check(text.contains(category_name), "Scorecard explains category " + category_name)
	check(text.contains("Unassessed") and not text.contains("correct_decision") and not text.contains("probe_interfered"), "Scorecard distinguishes unavailable categories without private codes")
	check(command.mission_ui.card_scroll.get_v_scroll_bar().visible, "Detailed report scrolls within bounded scorecard")
	check(Rect2(0, 0, 1600, 900).encloses(command.mission_ui.close_button.get_global_rect()), "Scorecard close remains accessible")
	await capture("p7_scorecard")
	for index in range(12):
		await click_at(command.mission_ui.card_scroll.get_global_rect().get_center(), MOUSE_BUTTON_WHEEL_DOWN)
	check(command.mission_ui.card_scroll.scroll_vertical > 0, "Detailed objective and outcome explanations accessible by wheel")
	await capture("p7_scorecard_outcomes")
	for label in command.find_children("*", "Label"):
		if label.is_visible_in_tree():
			for secret in ["Martian covert operative", "Neutral planetary research probe", "quality_penalty_pending", "probe_interfered", "uplink_override"]:
				check(not label.text.contains(secret), "Visible labels do not reveal " + secret)
	await click_at(command.mission_ui.close_button.get_global_rect().get_center())
	check(not command.scorecard_open, "Scorecard returns safely to command")
	command.set_learning_mode(false)
	var running := all_states()
	command.set_command_level("tactical")
	await create_timer(0.12).timeout
	for id in running:
		check(command.tactical_centers[id].active_contact.total_orbit_travel > running[id].travel, "Command levels do not pause Challenge movement")
	await close_game()

func all_states() -> Dictionary:
	var result := {}
	for id in command.tactical_centers:
		var tactical = command.tactical_centers[id]
		result[id] = {"travel": tactical.active_contact.total_orbit_travel, "remaining": tactical.deadline.remaining(tactical.active_contact), "truth": tactical.encounter.debug_state().truth}
	return result

func invalid_missions() -> void:
	var path := "user://prototype7_bad_mission.json"
	for failure in ["missing", "syntax", "configuration"]:
		var source := "user://prototype7_missing_mission.json"
		if failure != "missing":
			var file := FileAccess.open(path, FileAccess.WRITE)
			file.store_string("[invalid" if failure == "syntax" else "{}")
			file.close()
			source = path
		await spawn_command(source)
		check(not command.mission_error.is_empty(), "Missing/invalid mission has understandable diagnostic")
		check(command.mission_ui.network_label.text.contains("UNAVAILABLE") and command.mission_ui.scorecard_button.disabled, "No substitute scorecard or earned zeroes on mission failure")
		check(command.tactical_centers.size() == 3 and command.registry.contacts.size() == 9, "Mission failure preserves tactical simulation")
		command.focus_center("DC-01", 1)
		command.tactical_centers["DC-01"]._on_command_requested("hold_fire")
		check(command.tactical_centers["DC-01"].encounter.resolved, "Original decisions still work without mission config")
		await close_game()
	DirAccess.remove_absolute(path)


func rendered_expiration() -> void:
	await spawn_command()
	command.set_learning_mode(false)
	var first = command.tactical_centers["DC-01"]
	var other_before: Dictionary = command.mission.public_snapshot("DC-02")
	first.active_contact._process(first.decision_window_seconds + 0.01)
	first._process(0.0)
	await frames()
	var view: Dictionary = command.mission.public_snapshot()
	check(view.expired == 1 and view.timely == 0 and view.resolved == 1, "Actual movement-driven expiry emits one official ledger event")
	check(view.confirmed_points == 0.0 and category(view, "command_effectiveness").points == 0.0, "Missed deadline is an assessed zero for timeliness, not unknown health")
	check(category(view, "asset_protection").points == null, "Expiry does not invent asset damage")
	check(command.mission.public_snapshot("DC-02") == other_before, "Expiry scoring is isolated from other centers")
	first._on_attacker_selected(1)
	first._on_replay_requested()
	first._on_command_requested("deploy")
	check(command.mission.public_snapshot() == view, "Timely practice after expiry cannot repair the official score")
	await close_game()
