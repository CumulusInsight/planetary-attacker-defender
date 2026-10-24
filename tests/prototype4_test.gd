extends SceneTree
## Run rendered: godot --path . --script res://tests/prototype4_test.gd

const Loader = preload("res://script/attack_data_loader.gd")
const FIXTURE = "user://prototype4_test_fixture.json"
const EXPECTED_BOUNDS = Rect2(1280, 64, 300, 772)

var failures: int = 0
var checks: int = 0
var game: Node
var panel: PanelContainer
var test_viewport: SubViewport


func _initialize() -> void:
	# Isolate injected mouse events from the desktop pointer while rendering normally.
	test_viewport = SubViewport.new()
	test_viewport.size = Vector2i(1600, 900)
	test_viewport.world_2d = World2D.new()
	test_viewport.physics_object_picking = true
	test_viewport.handle_input_locally = true
	test_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(test_viewport)
	test_viewport.notify_mouse_entered()
	var preview := TextureRect.new()
	preview.texture = test_viewport.get_texture()
	preview.size = Vector2(1600, 900)
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(preview)
	call_deferred("run")


func check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error(message)


func frames(count: int = 4) -> void:
	for index in range(count):
		await physics_frame
		await process_frame


func spawn_game(path: String = "res://data/attacks.json") -> void:
	game = load("res://scene/game.tscn").instantiate()
	game.attack_data_path = path
	test_viewport.add_child(game)
	pointer_at(Vector2(40, 40))
	await frames()
	panel = game.get_node("HUD/AttackInfoPanel")


func close_game() -> void:
	game.queue_free()
	await frames()


func pointer_at(point: Vector2) -> void:
	var motion := InputEventMouseMotion.new()
	motion.position = point
	motion.global_position = point
	test_viewport.push_input(motion, true)


func click_at(point: Vector2, button: MouseButton = MOUSE_BUTTON_LEFT) -> void:
	pointer_at(point)
	var click := InputEventMouseButton.new()
	click.position = point
	click.global_position = point
	click.button_index = button
	click.pressed = true
	test_viewport.push_input(click, true)
	await frames()
	click.pressed = false
	test_viewport.push_input(click, true)
	await frames()


func check_record(record: Dictionary) -> void:
	check(panel.displayed_attack_id == record.attack_id, "Fixed panel ID matches selection")
	check(panel.abbreviation_label.text == record.abbreviation, "Fixed JSON abbreviation")
	check(panel.attack_id_label.text == "Attack ID: %d" % record.attack_id, "Fixed JSON ID text")
	check(panel.description_label.text == record.description, "Fixed JSON description")
	check(panel.severity_label.text == "Severity: %d" % record.severity, "Fixed JSON severity")
	check(panel.get_global_rect().is_equal_approx(EXPECTED_BOUNDS), "Fixed panel has approved bounds")


func sprite_bounds(sprite: Sprite2D) -> Rect2:
	return sprite.get_global_transform() * sprite.get_rect()


func capture(name: String) -> void:
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		test_viewport.get_texture().get_image().save_png("user://prototype4_%s.png" % name)


func run() -> void:
	await spawn_game()
	var attackers = game.get_node("EnemyContainer").get_children()
	check(attackers.size() == 3, "Exactly three attackers")
	check(game.selected_attack_id == -1 and panel.displayed_attack_id == -1, "No startup selection")
	check(panel.abbreviation_label.text == "Select an attacker", "Exact startup prompt")
	check(panel.description_label.text.is_empty() and panel.severity_label.text.is_empty(), "No invented startup data")
	check(panel.get_global_rect().is_equal_approx(EXPECTED_BOUNDS), "Startup panel bounds")
	check(panel.get_node("Content/FutureChoices").get_child_count() == 0, "Future choice area is empty")
	check(panel.get_node("Content/FutureChoices").mouse_filter == Control.MOUSE_FILTER_IGNORE, "Future choice area is inert")
	for node in panel.find_children("*", "BaseButton"):
		check(false, "No active defense buttons: " + str(node.name))
	check(not EXPECTED_BOUNDS.intersects(sprite_bounds(game.get_node("DataCenter/Sprite2D"))), "Panel does not overlap DATA artwork")
	for name in ["Label", "ValueLabel"]:
		check(not EXPECTED_BOUNDS.intersects(game.get_node("DataCenter/" + name).get_global_rect()), "Panel does not overlap DATA label/value")
	check(EXPECTED_BOUNDS.position.x > 1200, "Panel is outside all three orbital paths")
	await capture("startup")
	for index in range(attackers.size()):
		var target = attackers[index]
		await click_at(target.global_position)
		check(game.selected_attack_id == target.attack_id, "HUD does not block attacker clicks")
		check_record(game.attack_records[index])
		for other in attackers:
			check(other.is_selected == (other == target), "Exclusive highlight transfers")
		await capture("selected_%d" % target.attack_id)
		# Hover a different attacker without replacing the fixed selection.
		var other = attackers[(index + 1) % attackers.size()]
		var hover_seen := {"visible": false}
		var callback := func(_id): hover_seen.visible = other.get_node("InfoPanel").visible
		other.attacker_hovered.connect(callback)
		pointer_at(other.global_position)
		await frames()
		check(game.hovered_attack_id == other.attack_id and hover_seen.visible, "Other attacker retains local hover preview")
		check_record(game.attack_records[index])
		other.attacker_hovered.disconnect(callback)
		await click_at(Vector2(40, 40))
		check_record(game.attack_records[index])
		check(not target.get_node("InfoPanel").visible, "Selected moving detail does not persist after pointer exit")
		await click_at(target.global_position)
		check_record(game.attack_records[index])
		pointer_at(Vector2(40, 40))
		await frames()
	# Observe the fixed panel throughout both inward jumps of every attacker.
	var previous_rings = attackers.map(func(a): return a.current_ring)
	var transitions = [0, 0, 0]
	var last_angles = attackers.map(func(a): return a.orbit_angle)
	var travelled = attackers.map(func(a): return a.orbit_progress)
	var initial_positions = attackers.map(func(a): return a.position)
	var slowest_speed: float = attackers.map(func(a): return a.move_speed).min()
	# Two complete slowest orbits plus one second; never skip either inward jump.
	var observation_ms := int(ceil((2.0 * TAU / slowest_speed + 1.0) * 1000.0))
	var end_time = Time.get_ticks_msec() + observation_ms
	while Time.get_ticks_msec() < end_time:
		await process_frame
		check(panel.get_global_rect().is_equal_approx(EXPECTED_BOUNDS), "Panel stationary during rotation and jumps")
		check(not paused, "Reading never pauses movement")
		for index in range(attackers.size()):
			var attacker = attackers[index]
			travelled[index] += fposmod(attacker.orbit_angle - last_angles[index], TAU)
			last_angles[index] = attacker.orbit_angle
			if attacker.current_ring != previous_rings[index]:
				check(travelled[index] >= TAU * (transitions[index] + 1) - 0.001, "Full orbit before inward jump")
				check(attacker.current_ring == previous_rings[index] - 1, "One discrete ring per jump")
				previous_rings[index] = attacker.current_ring
				transitions[index] += 1
			check(not EXPECTED_BOUNDS.intersects(sprite_bounds(attacker.get_node("Sprite2D"))), "Panel clears attacker sprite throughout orbit")
			check(not EXPECTED_BOUNDS.intersects(attacker.get_node("AttackLabel").get_global_rect()), "Panel clears attacker label")
	for index in range(attackers.size()):
		check(transitions[index] == 2 and attackers[index].current_ring == 0, "Both inward jumps completed")
		check(attackers[index].position.distance_to(initial_positions[index]) > 1, "All attackers moved independently")
	var angles = attackers.map(func(a): return a.orbit_angle)
	await click_at(panel.get_global_rect().get_center())
	for index in range(attackers.size()):
		check(attackers[index].orbit_angle != angles[index], "Panel interaction does not stop inner motion")
	check_record(game.attack_records[2])
	await close_game()
	await fixtures_and_failures()
	await hover_freeze_and_resume()
	await overlapping_targets()
	print("PROTOTYPE 4 TEST: ", "PASS" if failures == 0 else "FAIL", " (", failures, " failures; ", checks, " checks)")
	quit(0 if failures == 0 else 1)


func write_fixture(source: String) -> void:
	var file := FileAccess.open(FIXTURE, FileAccess.WRITE)
	file.store_string(source)
	file.close()


func fixtures_and_failures() -> void:
	var records: Array = Loader.load_attacks("res://data/attacks.json").records
	records[0].attack_id = 42
	records[1].attack_id = 7
	records[2].attack_id = 900
	records[0].description = "Long JSON description for scroll testing. ".repeat(100)
	write_fixture(JSON.stringify(records))
	await spawn_game(FIXTURE)
	var target = game.get_node("EnemyContainer/Enemy")
	await click_at(target.global_position)
	check_record(records[0])
	check(game.selected_attack_id == 42, "Lookup by non-sequential ID")
	var scroll = panel.description_scroll
	check(panel.description_label.size.y > scroll.size.y, "Long description exceeds bounded scroll area")
	check(scroll.get_v_scroll_bar().visible, "Long description has scrollbar")
	var positions = game.get_node("EnemyContainer").get_children().map(func(a): return a.position)
	for index in range(4):
		await click_at(scroll.get_global_rect().get_center(), MOUSE_BUTTON_WHEEL_DOWN)
	check(scroll.scroll_vertical > 0, "Mouse wheel scrolls description")
	check(panel.get_global_rect().is_equal_approx(EXPECTED_BOUNDS), "Long description cannot grow panel")
	check(scroll.size.x <= 260 and scroll.get_h_scroll_bar().visible == false, "Description wraps without horizontal overflow")
	for index in range(3):
		check(game.get_node("EnemyContainer").get_child(index).position.distance_to(positions[index]) > 1, "All attackers move while scrolling")
	await capture("long_description")
	target = game.get_node("EnemyContainer/Enemy2")
	await click_at(target.global_position)
	check_record(records[1])
	check(scroll.scroll_vertical == 0, "Selection resets old scroll offset")
	# Unknown-ID input must clear stale details without selecting unrelated data.
	game._on_attacker_selected(9999)
	await frames()
	check(panel.displayed_attack_id == -1 and panel.description_label.text.is_empty(), "Unknown ID clears stale data")
	check(panel.abbreviation_label.text == "Attack information unavailable", "Unknown ID unavailable state")
	check(game.selected_attack_id == 7 and not paused, "Unknown ID preserves existing selection and running simulation")
	await close_game()
	for path in ["user://prototype4_missing/attacks.json", FIXTURE]:
		if path == FIXTURE:
			write_fixture("[invalid JSON")
		await spawn_game(path)
		check(not game.data_error.is_empty(), "Invalid JSON diagnostic retained")
		check(panel.abbreviation_label.text == "Attack information unavailable", "Invalid JSON neutral panel")
		check(panel.displayed_attack_id == -1 and panel.description_label.text.is_empty(), "No stale/substitute record")
		check(not game.get_node("EnemyContainer").visible, "Invalid attackers hidden")
		check(game.get_node("EnemyContainer").process_mode == Node.PROCESS_MODE_DISABLED, "Invalid attackers disabled")
		check(panel.get_global_rect().is_equal_approx(EXPECTED_BOUNDS), "Error state preserves bounds")
		await close_game()
	DirAccess.remove_absolute(FIXTURE)


func motion_state(attacker: Node2D) -> Array:
	return [attacker.orbit_angle, attacker.current_ring, attacker.orbit_radius, attacker.orbit_progress, attacker.position]


func hover_freeze_and_resume() -> void:
	await spawn_game()
	var attackers = game.get_node("EnemyContainer").get_children()
	for index in range(attackers.size()):
		var target = attackers[index]
		var artwork_scale: Vector2 = target.get_node("Sprite2D").scale
		check(target.get_node("Area2D/CollisionShape2D").shape.radius == 48.0, "Invisible interaction radius is enlarged to 48 pixels")
		pointer_at(target.global_position)
		await frames()
		check(target.is_hovered, "Pointer freezes the intended attacker")
		var stopped := motion_state(target)
		var other_angles = attackers.map(func(a): return a.orbit_angle)
		if index == 0:
			await capture("hover_hold_before")
		await create_timer(0.35).timeout
		if index == 0:
			await capture("hover_hold_after")
		check(motion_state(target) == stopped, "Hover preserves exact angle, ring, radius, progress, and position")
		check(target.get_node("Sprite2D").scale == artwork_scale, "Hover does not resize artwork")
		for other_index in range(attackers.size()):
			if other_index != index:
				var other = attackers[other_index]
				check(not other.is_hovered, "Only one attacker is frozen")
				check(fposmod(other.orbit_angle - other_angles[other_index], TAU) > 0.1, "Other attackers continue at normal speed")
		check(not paused, "Hover never pauses SceneTree")
		# The enlarged annulus itself must count as hover and accept a click.
		pointer_at(target.global_position + Vector2(44, 0))
		await frames()
		check(target.is_hovered and motion_state(target) == stopped, "Enlarged invisible hit area holds attacker")
		await click_at(target.global_position + Vector2(44, 0))
		check(target.is_selected and game.selected_attack_id == target.attack_id, "Clicking frozen attacker selects it")
		check_record(game.attack_records[index])
		check(motion_state(target) == stopped, "Selection while hovered does not advance orbit state")
		await capture("hover_frozen_%d" % target.attack_id)
		pointer_at(Vector2(40, 40))
		await frames()
		check(not target.is_hovered and target.is_selected, "Exit releases hover without removing selection")
		var resumed := motion_state(target)
		var travel: float = fposmod(target.orbit_angle - stopped[0], TAU)
		check(travel > 0 and travel < target.move_speed * 0.25, "Exit resumes with normal frame travel, not catch-up")
		check(target.current_ring == stopped[1], "Resume does not cause a sudden ring jump")
		check(is_equal_approx(target.orbit_progress - stopped[3], travel), "Resume preserves accumulated orbit progress")
		await create_timer(0.15).timeout
		check(target.orbit_angle != resumed[0] and not target.is_hovered, "Selection alone never freezes movement")
		check(not paused, "Exit and selection leave SceneTree running")
		if index == 0:
			await capture("hover_resumed")
	# Hold immediately before a full orbit: paused time must not consume the remainder.
	var target = attackers[0]
	target.orbit_progress = TAU - 0.2
	pointer_at(target.global_position)
	await frames()
	var near_jump := motion_state(target)
	await create_timer(0.5).timeout
	check(target.is_hovered and motion_state(target) == near_jump, "Freeze at orbit boundary does not trigger an inward jump")
	pointer_at(Vector2(40, 40))
	await frames()
	var travel_after_exit: float = fposmod(target.orbit_angle - near_jump[0], TAU)
	check(target.current_ring == near_jump[1] and travel_after_exit < 0.2, "Exit does not spend frozen time on orbit completion")
	await create_timer(0.2 / target.move_speed + 0.15).timeout
	check(target.current_ring == near_jump[1] - 1, "Remaining real movement completes orbit and jumps exactly once")
	await close_game()


func overlapping_targets() -> void:
	# Fixture-only starting phases put all three existing attackers in overlapping areas.
	await spawn_game()
	pointer_at(Vector2(40, 40))
	await frames()
	var attackers = game.get_node("EnemyContainer").get_children()
	for index in range(attackers.size()):
		attackers[index].orbit_angle = 0.5 + index * 0.02
		attackers[index].orbit_progress = 0.0
		attackers[index]._update_position()
	await frames(1)
	var front = attackers[2]
	pointer_at(front.global_position)
	await frames()
	check(front.is_hovered, "Frontmost overlapping attacker receives hover")
	check(attackers.filter(func(a): return a.is_hovered).size() == 1, "Overlapping areas freeze exactly one attacker")
	var held := motion_state(front)
	var other_angles = attackers.map(func(a): return a.orbit_angle)
	await create_timer(0.12).timeout
	check(motion_state(front) == held, "Overlap hover target stays stable")
	for index in range(2):
		check(attackers[index].orbit_angle != other_angles[index], "Overlapping unhovered attackers continue moving")
	var selections: Array[int] = []
	for attacker in attackers:
		attacker.attacker_selected.connect(func(id): selections.append(id))
	await click_at(front.global_position)
	check(selections == [front.attack_id], "One overlapping click emits one selection")
	check(front.is_selected and panel.displayed_attack_id == front.attack_id, "Overlap click matches frozen attacker and fixed data")
	# Move over another attacker's exposed edge: ownership and selection must transfer.
	pointer_at(Vector2(40, 40))
	await frames()
	var other = attackers[0]
	var exposed_edge := Vector2.ZERO
	var exposed := false
	# Wait for an exposed point with a frame of travel margin, rather than click
	# through a fully occluding neighbour or skim the moving target's outer edge.
	for attempt in range(120):
		exposed_edge = other.global_position + (other.global_position - front.global_position).normalized() * 32.0
		exposed = true
		for neighbour in attackers:
			if neighbour != other:
				var radius: float = neighbour.get_node("Area2D/CollisionShape2D").shape.radius * neighbour.scale.x
				if exposed_edge.distance_to(neighbour.global_position) < radius + 8.0:
					exposed = false
		if exposed:
			break
		await frames(1)
	check(exposed, "Nearby moving attacker exposes a pickable portion of its hit area")
	await click_at(exposed_edge)
	check(other.is_hovered and other.is_selected and not front.is_selected, "Nearby target can receive transferred hover and selection")
	check(panel.displayed_attack_id == other.attack_id, "Nearby selection transfers stationary information")
	var owner_state := motion_state(other)
	# A later-drawn neighbour passes over an existing hover owner.
	front.orbit_angle = other.orbit_angle + 0.01
	front._update_position()
	await frames()
	check(other.is_hovered and not front.is_hovered, "Passing frontmost neighbour cannot steal existing hover ownership")
	check(motion_state(other) == owner_state, "Overlap ownership preserves frozen orbit state")
	selections.clear()
	await click_at(other.global_position)
	check(selections == [other.attack_id], "Overlapping neighbour cannot steal frozen target click")
	pointer_at(Vector2(40, 40))
	await frames()
	check(attackers.all(func(a): return not a.is_hovered), "Leaving cluster releases every hover freeze")
	check(not paused, "Overlapping interaction never pauses SceneTree")
	await close_game()
