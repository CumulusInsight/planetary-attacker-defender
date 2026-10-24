extends "res://tests/prototype4_test.gd"
## Rendered strategic integration checks; inherited input/capture helpers only.
const StrategicLoader = preload("res://script/strategic_data_loader.gd")
var command: Node

func run() -> void:
	validate_configuration()
	command = load("res://scene/command_center.tscn").instantiate()
	game = command
	test_viewport.add_child(command)
	pointer_at(Vector2(10, 880))
	await frames()
	check(command.data_error.is_empty(), "Strategic initialization succeeds")
	check(command.registry.centers.size() == 3 and command.registry.contacts.size() == 9, "Three centers and nine unique contacts")
	for center_id in command.tactical_centers:
		var summary: Dictionary = command.registry.center_summary(center_id)
		check(summary.count == 3 and summary.active == 1, "Each center reports three monitored contacts and one live deadline")
		check(summary.urgent_id == command.tactical_centers[center_id].active_contact.contact_identifier, "Center urgent contact belongs to that center")
	check(command.registry.center_summary("DC-02").attention.contains("high assessed"), "Attention reflects assessed severity rather than actual affiliation")
	var rows: Array = command.registry.public_rows()
	for row in rows:
		check(row.center_id == "DC-%02d" % (int((row.contact_id - 1) / 3) + 1), "Correct stable contact association")
		if not [1, 4, 7].has(row.contact_id):
			check(row.remaining == null and row.status == "No encounter assigned", "No fabricated background deadline or encounter")
	var deadline_rows: Array = command.registry.triage(0)
	check(deadline_rows.slice(0, 3).map(func(row): return row.contact_id) == [7, 1, 4], "Earliest applicable deadlines first")
	check(command.registry.triage(1).slice(0, 3).map(func(row): return row.contact_id) == [4, 1, 7], "Highest assessed severity independent sort")
	await capture("p6_initial_overview")
	# Make urgency disagree with severity; never combine them into an opaque score.
	var first = command.tactical_centers["DC-01"]
	first.active_contact.total_orbit_travel += first.active_contact.move_speed * 100.0
	check(command.registry.triage(0)[0].contact_id == 1 and command.registry.triage(1)[0].contact_id == 4, "Urgency and assessed severity can disagree")
	command.sort_control.select(1)
	command.sort_control.item_selected.emit(1)
	check(command.sort_mode == 1 and command.queue.get_root().get_first_child().get_metadata(0) == 4, "Sort selector changes visible queue ordering")
	command.sort_control.select(0)
	command.sort_control.item_selected.emit(0)
	check(command.queue.get_root().get_first_child().get_metadata(0) == 1, "Deadline selector restores urgency order")
	check(is_equal_approx(first.deadline.budget / first.active_contact.move_speed, 300.0), "Five-minute default retained")
	check(command.center_buttons.size() == 3 and command.queue_rows.size() == 9, "All center cards and queue rows visible")
	assert_private()
	await capture("p6_overview")
	# Actual queue click navigates with intended contact selection.
	var item: TreeItem = command.queue_rows[5]
	var rect: Rect2 = command.queue.get_item_area_rect(item)
	await click_at(command.queue.global_position + rect.get_center())
	check(command.focused_center == "DC-02" and not command.overview.visible, "Queue click enters associated tactical view")
	var second = command.tactical_centers["DC-02"]
	panel = second.get_node("HUD/AttackInfoPanel")
	check(second.selected_attack_id == 5 and second.get_node("EnemyContainer").get_child(1).is_selected, "Queue contact is highlighted")
	check(panel.get_node("Content/Countdown").text == "--:--:--" and panel.deploy_button.disabled, "Background selection does not borrow active deadline/actions")
	# Leaving tactical clears hover rather than freezing an offscreen contact.
	await click_at(command.back_button.get_global_rect().get_center())
	check(command.focused_center.is_empty() and command.overview.visible, "Obvious return to strategic overview")
	await click_at(command.center_buttons["DC-03"].get_global_rect().get_center())
	check(command.focused_center == "DC-03", "Center card opens reusable tactical view")
	command.focus_center("DC-01", 1)
	var before: float = first.deadline.remaining(first.active_contact)
	command.focus_center("DC-02", 4)
	command.show_overview()
	command.focus_center("DC-01", 1)
	check(first.deadline.remaining(first.active_contact) <= before and before - first.deadline.remaining(first.active_contact) < 0.1, "Navigation does not reset or extend countdown")
	# Learning strategic pause holds all encounter movement/clocks but not background traffic.
	command.set_learning_mode(true)
	await click_at(command.pause_control.get_global_rect().get_center())
	var held := active_states()
	var background_before: float = first.get_node("EnemyContainer").get_child(1).total_orbit_travel
	command.show_overview()
	await create_timer(0.2).timeout
	check(command.strategic_paused and active_states() == held, "Strategic pause holds all encounter states while navigating")
	check(first.get_node("EnemyContainer").get_child(1).total_orbit_travel > background_before, "Background traffic continues during strategic reading")
	for button in command.center_buttons.values():
		check(Rect2(0, 0, 1600, 900).encloses(button.get_global_rect()), "Center cards fit reference viewport")
	check(command.queue.get_item_area_rect(command.queue.get_root().get_first_child().get_next().get_next().get_next().get_next().get_next().get_next().get_next().get_next()).end.y <= command.queue.size.y, "All nine queue rows fit without scrolling")
	check(command.context_label.text.contains("PAUSED"), "Strategic pause is explicitly visible")
	await capture("p6_paused_overview")
	command.focus_center("DC-02", 4)
	check(second.active_contact.strategic_paused, "Navigation never releases strategic pause")
	panel = second.get_node("HUD/AttackInfoPanel")
	await frames()
	check(panel.get_node("Content/Urgency").text.contains("STRATEGIC PAUSE"), "Tactical countdown identifies shared pause")
	check(panel.get_global_rect().is_equal_approx(EXPECTED_BOUNDS), "Tactical console retains accepted bounds")
	await capture("p6_tactical_paused")
	var paused_others := active_states()
	second._on_command_requested("investigate")
	second._on_replay_requested()
	await frames()
	check(command.strategic_paused and second.active_contact.strategic_paused, "Replay cannot release shared strategic pause")
	check(second.deadline.remaining(second.active_contact) == second.decision_window_seconds, "Paused replay restores full budget without ticking")
	for id in ["DC-01", "DC-03"]:
		check(active_states()[id] == paused_others[id], "Paused replay leaves other encounter state untouched")
	# Challenge keeps all centers progressing while overview or another center is viewed.
	command.set_learning_mode(false)
	check(not command.strategic_paused and command.pause_control.disabled, "Challenge disables/releases strategic pause")
	var resume := active_states()
	command.show_overview()
	await create_timer(0.15).timeout
	for id in command.tactical_centers:
		var tactical = command.tactical_centers[id]
		check(tactical.active_contact.total_orbit_travel > resume[id].travel, "Offscreen Challenge movement progresses independently")
		check(tactical.deadline.remaining(tactical.active_contact) < resume[id].remaining, "Offscreen Challenge deadline decreases")
		check(resume[id].remaining - tactical.deadline.remaining(tactical.active_contact) < 0.4, "Resume has no catch-up")
	command.focus_center("DC-01", 1)
	pointer_at(first.active_contact.position)
	await frames()
	var frozen := motion_state(first.active_contact)
	var other_before: float = second.deadline.remaining(second.active_contact)
	await create_timer(0.15).timeout
	check(first.active_contact.is_hovered and motion_state(first.active_contact) == frozen, "Tactical hover preserves accepted freeze")
	check(second.deadline.remaining(second.active_contact) < other_before, "Tactical hover never freezes another center")
	command.show_overview()
	check(not first.active_contact.is_hovered, "Leaving tactical releases stale hover")
	var hidden_before: float = first.deadline.remaining(first.active_contact)
	await create_timer(0.1).timeout
	check(first.deadline.remaining(first.active_contact) < hidden_before, "Hidden contact does not remain hover-frozen")
	# Each active session retains existing decision/follow-up/replay semantics.
	for id in command.tactical_centers:
		var tactical = command.tactical_centers[id]
		command.focus_center(id, tactical.active_contact.attack_id)
		panel = tactical.get_node("HUD/AttackInfoPanel")
		await click_at(panel.investigate_button.get_global_rect().get_center())
		check(tactical.encounter.investigated and not tactical.encounter.resolved, "Investigation is per encounter")
		await click_at(panel.deploy_button.get_global_rect().get_center())
		check(tactical.encounter.resolved, "Tactical defense remains usable")
		check(tactical.encounter.debug_state().actual_result == ("interference_blocked" if id == "DC-01" else "probe_interfered"), "Hostile and neutral deterministic outcomes preserved")
		assert_private()
		var others := active_states()
		await click_at(panel.replay_button.get_global_rect().get_center())
		check(not tactical.encounter.resolved and not tactical.encounter.investigated, "Replay resets only chosen encounter")
		check(tactical.deadline.remaining(tactical.active_contact) > tactical.decision_window_seconds - 0.3, "Replay restores chosen contact's full window")
		for other in command.tactical_centers:
			if other != id:
				check(command.tactical_centers[other].active_contact.total_orbit_travel >= others[other].travel, "Replay never resets another center")
		await click_at(panel.hold_button.get_global_rect().get_center())
		check(tactical.encounter.debug_state().decision == "hold_fire", "Explicit hold fire remains distinct")
		tactical._on_replay_requested()
		# Advance actual movement to deadline deterministically; do not wait five wall minutes.
		tactical.active_contact._on_area_2d_mouse_exited()
		tactical.active_contact._process(tactical.decision_window_seconds + 0.01)
		tactical._process(0.0)
		check(tactical.encounter.debug_state().decision == "expired", "Independent deadline expiration")
		tactical._on_command_requested("deploy")
		check(tactical.encounter.debug_state().decision == "expired", "Late action cannot replace expiration")
	command.show_overview()
	await frames()
	check(command.registry.center_summary("DC-01").active == 0 and command.registry.center_summary("DC-01").attention.contains("expired"), "Center summaries update after expiration")
	assert_private()
	await capture("p6_outcomes")
	check(not paused, "No SceneTree pause")
	await close_game()
	await validate_scaling()
	print("PROTOTYPE 6 TEST: ", "PASS" if failures == 0 else "FAIL", " (", failures, " failures; ", checks, " checks)")
	quit(0 if failures == 0 else 1)

func active_states() -> Dictionary:
	var states := {}
	for id in command.tactical_centers:
		var tactical = command.tactical_centers[id]
		states[id] = {"travel": tactical.active_contact.total_orbit_travel, "remaining": tactical.deadline.remaining(tactical.active_contact)}
	return states

func assert_private() -> void:
	var public_source := JSON.stringify(command.registry.public_rows())
	for tactical in command.tactical_centers.values():
		var truth: Dictionary = tactical.encounter.debug_state().truth
		for secret in [truth.identity, truth.objective, "private_truth", "developer_fixture", "actual_result", "attempted_attack"]:
			check(not public_source.contains(secret), "Strategic public projection excludes " + secret)
		for capability in truth.capabilities:
			check(not public_source.contains(capability), "Strategic projection excludes capability")
		var visible := ""
		for label in command.find_children("*", "Label"):
			if label.is_visible_in_tree():
				visible += label.text + "\n"
		for button in command.find_children("*", "Button"):
			if button.is_visible_in_tree():
				visible += button.text + "\n"
		check(not visible.contains(truth.identity) and not visible.contains(truth.objective), "Visible UI excludes hidden identity/objective")

func validate_configuration() -> void:
	var file := FileAccess.open("res://data/strategic_centers.json", FileAccess.READ)
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	check(StrategicLoader.validate(data).is_empty(), "Data-driven configuration validates")
	for mutation in ["duplicate_center", "duplicate_contact", "missing_active", "negative_duration", "bad_severity", "bad_fixture"]:
		var broken := data.duplicate(true)
		match mutation:
			"duplicate_center": broken.centers[1].center_id = broken.centers[0].center_id
			"duplicate_contact": broken.centers[1].contacts[0].contact_id = 1
			"missing_active": broken.centers[0].active_contact_id = 999
			"negative_duration": broken.centers[0].decision_window_seconds = -1
			"bad_severity": broken.centers[0].contacts[0].assessed_severity = 9
			"bad_fixture": broken.centers[0].developer_fixture = "missing"
		check(not StrategicLoader.validate(broken).is_empty(), "Invalid strategy rejected atomically: " + mutation)
	check(not StrategicLoader.load_centers("user://missing_strategic.json").error.is_empty(), "Missing strategy has diagnostic")

func validate_scaling() -> void:
	# Configuration is not limited to three centers or three contacts by the registry/loader.
	var file := FileAccess.open("res://data/strategic_centers.json", FileAccess.READ)
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	data.centers.resize(1)
	data.centers[0].contacts.append({"contact_id": 10, "assessed_severity": 0, "assessment": "Unknown", "confidence": null})
	check(StrategicLoader.validate(data).is_empty(), "One-center/four-contact configuration supported")
	var path := "user://prototype6_scaling.json"
	var output := FileAccess.open(path, FileAccess.WRITE)
	output.store_string(JSON.stringify(data))
	output.close()
	command = load("res://scene/command_center.tscn").instantiate()
	command.strategic_data_path = path
	game = command
	test_viewport.add_child(command)
	await frames()
	check(command.tactical_centers.size() == 1 and command.registry.contacts.size() == 4, "Reusable components instantiate changed population")
	var tactical = command.tactical_centers["DC-01"]
	check(tactical.get_node("EnemyContainer").get_child_count() == 4, "Tactical contacts match configuration count")
	check(tactical.get_node("EnemyContainer").get_child(3).get_node("AttackLabel").text == "C-010", "Dynamically added contact gets external identity")
	await close_game()
	DirAccess.remove_absolute(path)
