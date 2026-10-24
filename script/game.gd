extends Node2D

# Prototype 2 sample data only. Ring indices run from 0 (inner) to 2 (outer).
const SAMPLE_ATTACKERS = [
	{"attack_id": 1, "abbreviation": "VM ESC", "description": "Placeholder: virtual machine escape.", "severity": 1, "move_speed": 0.7, "start_ring": 2},
	{"attack_id": 2, "abbreviation": "ROOTKIT", "description": "Placeholder: concealed system access.", "severity": 2, "move_speed": 0.9, "start_ring": 2},
	{"attack_id": 3, "abbreviation": "FILELESS", "description": "Placeholder: memory-based activity.", "severity": 3, "move_speed": 1.1, "start_ring": 2},
]

var selected_attack_id: int = -1
var hovered_attack_id: int = -1


func _enter_tree() -> void:
	# Configure existing scene instances before their _ready callbacks run.
	var attackers := $EnemyContainer.get_children()
	for index in range(attackers.size()):
		var attacker = attackers[index]
		for property in SAMPLE_ATTACKERS[index]:
			attacker.set(property, SAMPLE_ATTACKERS[index][property])
		attacker.attacker_selected.connect(_on_attacker_selected)
		attacker.attacker_hovered.connect(_on_attacker_hovered)


func _draw() -> void:
	for radius in Enemy.RING_RADII:
		draw_arc(Vector2(800, 450), radius, 0.0, TAU, 192, Color(0.25, 0.32, 0.4, 0.65), 1.5, true)


func _on_attacker_selected(attack_id: int) -> void:
	selected_attack_id = attack_id
	for attacker in $EnemyContainer.get_children():
		attacker.set_selected(attacker.attack_id == attack_id)


func _on_attacker_hovered(attack_id: int) -> void:
	hovered_attack_id = attack_id
