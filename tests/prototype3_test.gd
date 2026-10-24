extends SceneTree

const Loader = preload("res://script/attack_data_loader.gd")
const FIXTURE = "user://prototype3_validation_fixture.json"

var game: Node
var failures: int = 0
var hover_panels_seen: Dictionary = {}

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func _initialize() -> void:
	call_deferred("run")

func frames(count: int = 4) -> void:
	for i in range(count):
		await physics_frame
		await process_frame

func run() -> void:
	validate_data_errors()
	await validate_controller_errors()
	game = load("res://scene/game.tscn").instantiate()
	root.add_child(game)
	await frames()
	var attackers = game.get_node("EnemyContainer").get_children()
	check(attackers.size() == 3, "Exactly three attackers")
	check(game.attack_records.size() == 3 and game.data_error.is_empty(), "Three JSON records loaded")
	check(attackers.map(func(a): return a.abbreviation) == ["VM ESC", "ROOTKIT", "FILELESS"], "Correct JSON identities")
	for i in range(3):
		for property in ["attack_id", "abbreviation", "description", "severity", "move_speed", "start_ring"]:
			check(attackers[i].get(property) == game.attack_records[i][property], "External configuration: " + property)
		check(attackers[i].get_node("AttackLabel").text == game.attack_records[i].abbreviation, "JSON identity displayed")
		check(attackers[i].current_ring == 2, "Start on outer ring")
	# Real viewport mouse events, through Area2D picking and connected signals.
	for target in attackers:
		target.attacker_hovered.connect(func(id): hover_panels_seen[id] = target.get_node("InfoPanel").visible)
		var motion := InputEventMouseMotion.new()
		motion.position = target.global_position
		root.push_input(motion)
		await frames()
		check(game.hovered_attack_id == target.attack_id, "Hover signal reaches controller")
		check(hover_panels_seen.get(target.attack_id, false), "Hover panel visible on hover signal")
		check(target.get_node("InfoPanel/InfoLabel").text.contains(target.description), "External hover description")
		var click := InputEventMouseButton.new()
		click.position = target.global_position
		click.button_index = MOUSE_BUTTON_LEFT
		click.pressed = true
		root.push_input(click)
		await frames()
		click.pressed = false
		root.push_input(click)
		check(game.selected_attack_id == target.attack_id, "Click selects target")
		check(not paused, "Selection never pauses scene tree")
		for other in attackers:
			check(other.is_selected == (other == target), "Exclusive selection transfers")
		var positions = attackers.map(func(a): return a.position)
		await create_timer(0.15).timeout
		for i in range(3):
			check(attackers[i].position.distance_to(positions[i]) > 1.0, "All attackers move during selection")
	# Observe actual frame-driven motion for two full slow orbits, including phase offsets.
	var last_rings = [2, 2, 2]
	var transitions = [0, 0, 0]
	var travelled = attackers.map(func(a): return a.orbit_progress)
	var last_angles = attackers.map(func(a): return a.orbit_angle)
	var end_time = Time.get_ticks_msec() + 19000
	while Time.get_ticks_msec() < end_time:
		await process_frame
		for i in range(3):
			var a = attackers[i]
			travelled[i] += fposmod(a.orbit_angle - last_angles[i], TAU)
			last_angles[i] = a.orbit_angle
			if a.current_ring != last_rings[i]:
				check(travelled[i] >= TAU * (transitions[i] + 1) - 0.001, "Full orbit before each inward jump")
				check(a.current_ring == last_rings[i] - 1, "Discrete jump by one ring")
				transitions[i] += 1
				last_rings[i] = a.current_ring
			check(is_equal_approx(a.orbit_radius, a.RING_RADII[a.current_ring]), "Radius stays on one of three paths")
	for i in range(3):
		check(transitions[i] == 2, "Two inward jumps for attacker %d" % i)
		check(attackers[i].current_ring == 0, "Remain at inner ring")
	var angles = attackers.map(func(a): return a.orbit_angle)
	await create_timer(0.2).timeout
	for i in range(3):
		check(attackers[i].orbit_angle != angles[i], "Continue orbiting at inner ring")
		check(attackers[i].current_ring == 0, "No jump past inner ring")
	check(game.get_node("DataCenter/ValueLabel").text == "$1,000,000", "DATA value")
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("user://prototype3_test_viewport.png")
	print("PROTOTYPE 3 TEST: ", "PASS" if failures == 0 else "FAIL", " (", failures, " failures)")
	quit(0 if failures == 0 else 1)



func write_fixture(source: String) -> void:
	var file := FileAccess.open(FIXTURE, FileAccess.WRITE)
	file.store_string(source)
	file.close()


func expect_invalid(source: String, diagnostic: String) -> void:
	write_fixture(source)
	var result := Loader.load_attacks(FIXTURE)
	check(result.records.is_empty(), "Invalid data returns no partial configuration")
	check(result.error.contains(diagnostic) and result.error.contains(FIXTURE), "Actionable diagnostic: " + diagnostic)


func validate_data_errors() -> void:
	var valid := Loader.load_attacks("res://data/attacks.json")
	check(valid.error.is_empty() and valid.records.size() == 3, "Valid JSON dataset")
	var missing := Loader.load_attacks("user://prototype3_nonexistent/attacks.json")
	check(missing.error.contains("cannot open file"), "Missing file diagnostic")
	expect_invalid("[invalid", "JSON syntax error at line")
	expect_invalid("{}", "root must be an array")
	expect_invalid("[]", "expected exactly 3")
	var original: Array = JSON.parse_string(JSON.stringify(valid.records))
	var records := original.duplicate(true)
	records[1] = "bad record"
	expect_invalid(JSON.stringify(records), "record 2 must be an object")
	for field in Loader.REQUIRED_FIELDS:
		records = original.duplicate(true)
		records[1].erase(field)
		expect_invalid(JSON.stringify(records), "record 2 is missing required field '%s'" % field)
	for field in ["abbreviation", "description"]:
		for value in ["  ", null, 123]:
			records = original.duplicate(true)
			records[1][field] = value
			expect_invalid(JSON.stringify(records), "field '%s' must be a non-empty string" % field)
	for field in Loader.INTEGER_FIELDS:
		for value in [null, true, "1", 1.5, -1, 2147483648]:
			records = original.duplicate(true)
			records[1][field] = value
			expect_invalid(JSON.stringify(records), "field '%s' must be a non-negative 32-bit integer" % field)
	for value in [null, true, "0.9", 0, -1]:
		records = original.duplicate(true)
		records[1].move_speed = value
		expect_invalid(JSON.stringify(records), "field 'move_speed' must be a finite positive number")
	records = original.duplicate(true)
	records[1].start_ring = 3
	expect_invalid(JSON.stringify(records), "field 'start_ring' must be 0, 1, or 2")
	records = original.duplicate(true)
	records[1].attack_id = records[0].attack_id
	expect_invalid(JSON.stringify(records), "duplicate attack_id")
	# Different valid data must reach the reusable interface unchanged.
	records = original.duplicate(true)
	records[0].attack_id = 42
	records[0].description = "Changed JSON fixture description"
	records[0].severity = 0
	records[0].start_ring = 1
	write_fixture(JSON.stringify(records))
	var changed := Loader.load_attacks(FIXTURE)
	check(changed.error.is_empty() and changed.records[0].attack_id == 42, "Alternate valid JSON accepted")
	DirAccess.remove_absolute(FIXTURE)


func validate_controller_errors() -> void:
	for source in ["user://prototype3_nonexistent/attacks.json", FIXTURE]:
		if source == FIXTURE:
			write_fixture('[{"attack_id": 1}, {}, {}]')
		var invalid_game = load("res://scene/game.tscn").instantiate()
		invalid_game.attack_data_path = source
		root.add_child(invalid_game)
		await frames()
		check(not invalid_game.data_error.is_empty(), "Controller reports invalid source")
		check(invalid_game.attack_records.is_empty(), "Controller never supplies partial data")
		var container = invalid_game.get_node("EnemyContainer")
		check(not container.visible and container.process_mode == Node.PROCESS_MODE_DISABLED, "Invalid configuration cannot show anonymous moving attackers")
		invalid_game.queue_free()
		await frames()
	DirAccess.remove_absolute(FIXTURE)
	var records: Array = Loader.load_attacks("res://data/attacks.json").records
	records[0].attack_id = 42
	records[0].description = "Changed JSON fixture description"
	records[0].start_ring = 1
	write_fixture(JSON.stringify(records))
	var alternate_game = load("res://scene/game.tscn").instantiate()
	alternate_game.attack_data_path = FIXTURE
	root.add_child(alternate_game)
	await frames()
	var alternate = alternate_game.get_node("EnemyContainer/Enemy")
	check(alternate.attack_id == 42 and alternate.current_ring == 1, "Controller applies alternate JSON identity and ring")
	check(alternate.get_node("InfoPanel/InfoLabel").text.contains("Changed JSON fixture description"), "Controller applies alternate JSON description")
	alternate_game.queue_free()
	await frames()
	DirAccess.remove_absolute(FIXTURE)
