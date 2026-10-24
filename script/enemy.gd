extends Node2D
class_name Enemy

var attack_names = [
	"QUANTUM",
	"BLUJACK",
	"OFF CRACK"
]

var attack_name: String = ""

signal movement_signal

@export var enemy_texture: Texture2D
@export var orbit_speed: float = 1.0
@export var orbit_radius: float = 350.0
@export var orbit_angle: float = 0.0
@export var inward_step: float = 40.0
@export var critical_orbit_radius: float = 120.0
@export var critical_orbit_speed: float = 0.8
@export var critical_orbit_slot: int = 0

var center_position := Vector2(800, 450)

var is_selected: bool = false
static var selected_enemy = null
var normal_scale: Vector2

var in_critical_orbit := false

# Normal orbit revolution counter
var revolution_count: int = 0

# Critical orbit revolution counter
var critical_revolution_count: int = 0

# How many revolutions are required
var required_revolutions: int = 1

# Whether this enemy is currently allowed
# to count normal revolutions.
var counting_revolutions: bool = false

# Blink duration
var blink_duration: float = 0.12


func _ready():
	# Assign unique random attacks.
	if name == "Enemy":
		var shuffled_attacks = attack_names.duplicate()
		shuffled_attacks.shuffle()

		attack_name = shuffled_attacks[0]
		get_parent().get_node("Enemy2").attack_name = shuffled_attacks[1]
		get_parent().get_node("Enemy3").attack_name = shuffled_attacks[2]

	$Sprite2D.texture = enemy_texture
	normal_scale = scale
	await get_tree().process_frame
	$AttackLabel.text = attack_name
	
	# ENEMY
	if name == "Enemy":
		required_revolutions = 1
		counting_revolutions = true

	# ENEMY 2
	elif name == "Enemy2":
		required_revolutions = 2
		counting_revolutions = false

		var previous_enemy = get_parent().get_node("Enemy")
		previous_enemy.movement_signal.connect(_on_previous_enemy_signal)

	# ENEMY 3
	elif name == "Enemy3":
		required_revolutions = 3
		counting_revolutions = false

		var previous_enemy = get_parent().get_node("Enemy2")
		previous_enemy.movement_signal.connect(_on_previous_enemy_signal)


func _on_previous_enemy_signal():
	# The previous enemy has completed its required action.
	# We are now allowed to count our revolutions.
	counting_revolutions = true


func _process(delta):

	var current_speed = orbit_speed

	# Critical orbit uses its own speed.
	if in_critical_orbit:
		current_speed = critical_orbit_speed

	# All enemies continue revolving.
	orbit_angle += current_speed * delta

	# Completed a full 360° revolution.
	if orbit_angle >= TAU:
		orbit_angle -= TAU

		# ==========================================
		# CRITICAL ORBIT
		# ==========================================
		if in_critical_orbit:

			critical_revolution_count += 1

			# Enemy = 1
			# Enemy2 = 2
			# Enemy3 = 3
			if critical_revolution_count >= required_revolutions:

				critical_revolution_count = 0

				# Blink visually.
				blink()

				# Send signal to the next enemy.
				movement_signal.emit()

		# ==========================================
		# NORMAL ORBIT
		# ==========================================
		elif counting_revolutions:

			revolution_count += 1

			# Have we completed the required
			# number of revolutions?
			if revolution_count >= required_revolutions:

				revolution_count = 0
				counting_revolutions = false

				# Move one orbit inward.
				orbit_radius -= inward_step

				# Have we reached the critical orbit?
				if orbit_radius <= critical_orbit_radius:

					orbit_radius = critical_orbit_radius

					in_critical_orbit = true

					critical_revolution_count = 0

					# IMPORTANT:
					# Do NOT signal the next enemy yet.
					# We only signal after completing
					# the required critical revolutions.

					# Put the planet into its assigned
					# critical orbit position.
					orbit_angle = float(critical_orbit_slot) * TAU / 3.0

				else:

					# We are still outside the critical orbit.
					# Signal the next enemy normally.
					movement_signal.emit()

	var offset = Vector2(cos(orbit_angle), sin(orbit_angle)) * orbit_radius

	position = center_position + offset


func blink():
	# Briefly hide the planet.
	$Sprite2D.visible = false

	await get_tree().create_timer(blink_duration).timeout

	$Sprite2D.visible = true


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:

			# No planet is currently selected.
			if Enemy.selected_enemy == null:

				Enemy.selected_enemy = self
				is_selected = true
				scale = normal_scale * 1.5
				
				$InfoPanel.visible = true
				
				$InfoPanel/InfoLabel.text = "ENEMY: " + name + "\n" + \
				"ATTACK: " + attack_name + "\n" + \
				"SPEED: " + str(orbit_speed) + "\n" + \
				"ORBIT: " + str(orbit_radius)

				# Pause the entire game.
				get_tree().paused = true

			# The player clicked the already-selected planet.
			elif Enemy.selected_enemy == self:

				scale = normal_scale
				is_selected = false
				Enemy.selected_enemy = null
				
				$InfoPanel.visible = false

				# Resume the entire game.
				get_tree().paused = false

			# Another planet was clicked.
			else:

				# Do nothing.
				return
