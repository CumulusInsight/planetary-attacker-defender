extends Node2D
class_name Enemy

signal attacker_selected(attack_id: int)
signal attacker_hovered(attack_id: int)

@export var attack_id: int = 0
@export var abbreviation: String = ""
@export_multiline var description: String = ""
@export var severity: int = 1
# Radians per second. Ring 0 is innermost; ring 2 is outermost.
@export var move_speed: float = 1.0
@export_range(0, 2) var start_ring: int = 2
@export var enemy_texture: Texture2D
@export var orbit_angle: float = 0.0

const RING_RADII = [160.0, 280.0, 400.0]
var center_position := Vector2(800, 450)
var current_ring: int = 2
var orbit_radius: float = 400.0
var is_selected: bool = false
var normal_scale := Vector2.ONE
var orbit_progress: float = 0.0
var is_hovered: bool = false


func _ready() -> void:
	normal_scale = scale
	current_ring = clampi(start_ring, 0, 2)
	orbit_radius = RING_RADII[current_ring]
	if enemy_texture:
		$Sprite2D.texture = enemy_texture
	$AttackLabel.text = abbreviation
	$InfoPanel/InfoLabel.text = "%s\n%s\nSeverity: %d" % [abbreviation, description, severity]
	_update_position()


func _process(delta: float) -> void:
	# Hover holds this object's state only; do not accumulate time to catch up later.
	if is_hovered:
		return
	var travel := move_speed * delta
	orbit_angle = fposmod(orbit_angle + travel, TAU)
	# Count a full orbit from the starting angle, independently of other attackers.
	orbit_progress += absf(travel)
	while orbit_progress >= TAU:
		orbit_progress -= TAU
		current_ring = maxi(0, current_ring - 1)
		orbit_radius = RING_RADII[current_ring]
	_update_position()


func _update_position() -> void:
	position = center_position + Vector2(cos(orbit_angle), sin(orbit_angle)) * orbit_radius
	# Keep the information panel inside the playfield, including when enlarged.
	$InfoPanel.position.x = -300.0 if position.x + 300.0 * scale.x > 1592.0 else 70.0
	$InfoPanel.position.y = clampf(-80.0, (8.0 - position.y) / scale.y, (892.0 - position.y) / scale.y - 104.0)


func set_selected(value: bool) -> void:
	is_selected = value
	scale = normal_scale * (1.5 if value else 1.0)
	$InfoPanel.visible = is_hovered
	_update_position()


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		attacker_selected.emit(attack_id)


func _on_area_2d_mouse_entered() -> void:
	is_hovered = true
	# Keep the current target pickable when another attacker passes behind/over it.
	# This Area2D has no artwork, so its input priority does not change the visuals.
	$Area2D.z_index = 1
	$InfoPanel.visible = true
	attacker_hovered.emit(attack_id)


func _on_area_2d_mouse_exited() -> void:
	is_hovered = false
	$Area2D.z_index = 0
	$InfoPanel.visible = false
