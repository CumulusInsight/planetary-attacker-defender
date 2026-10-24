extends Node2D
## Visual surveillance trajectory, not a gravitational orbit or encounter.
signal attacker_selected(attack_id: int)
signal attacker_hovered(attack_id: int)
var attack_id: int
var contact_identifier: String
var path: Dictionary
var center_position := Vector2(800, 450)
var elapsed := 0.0
var total_orbit_travel := 0.0
var move_speed := 1.0
var is_hovered := false
var is_selected := false
var area: Area2D

func configure(id: int, trajectory: Dictionary) -> void:
	attack_id = id
	contact_identifier = "C-%03d" % id
	path = trajectory.duplicate(true)
	move_speed = path.angular_rate

func _ready() -> void:
	area = Area2D.new()
	area.name = "Area2D"
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 28.0
	shape.shape = circle
	area.add_child(shape)
	add_child(area)
	area.input_event.connect(_input_contact)
	area.mouse_entered.connect(_on_area_2d_mouse_entered)
	area.mouse_exited.connect(_on_area_2d_mouse_exited)
	var label := Label.new()
	label.name = "AttackLabel"
	label.text = contact_identifier
	label.position = Vector2(-34, 17)
	label.add_theme_font_size_override("font_size", 16)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(label)
	_update_position()

func position_at(seconds: float) -> Vector2:
	var phase: float = path.initial_phase + path.direction * path.angular_rate * seconds
	return center_position + Vector2(path.horizontal_radius * cos(phase), path.vertical_radius * sin(phase)).rotated(path.orientation)

func _process(delta: float) -> void:
	if is_hovered:
		return
	elapsed += delta
	total_orbit_travel += move_speed * delta
	_update_position()

func _update_position() -> void:
	position = position_at(elapsed)
	queue_redraw()

func _draw() -> void:
	# Same neutral symbol for all traffic; no affiliation or assessment encoding.
	draw_colored_polygon(PackedVector2Array([Vector2(0,-13), Vector2(14,0), Vector2(0,13), Vector2(-14,0)]), Color(0.65,0.8,0.9))
	if is_selected:
		draw_arc(Vector2.ZERO, 21, 0, TAU, 32, Color(1,0.96,0.62), 3, true)

func set_selected(value: bool) -> void:
	is_selected = value
	queue_redraw()

func _input_contact(_viewport: Node, event: InputEvent, _shape: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		attacker_selected.emit(attack_id)

func _on_area_2d_mouse_entered() -> void:
	is_hovered = true
	area.z_index = 1
	attacker_hovered.emit(attack_id)

func _on_area_2d_mouse_exited() -> void:
	is_hovered = false
	area.z_index = 0
