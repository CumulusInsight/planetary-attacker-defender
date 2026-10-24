extends Node2D

const AttackDataLoader = preload("res://script/attack_data_loader.gd")

@export_file("*.json") var attack_data_path: String = "res://data/attacks.json"
var attack_records: Array = []
var data_error: String = ""

var selected_attack_id: int = -1
var hovered_attack_id: int = -1
var _previous_picking_sort: bool = false
var _previous_picking_first_only: bool = false


func _enter_tree() -> void:
	# Load atomically before child _ready callbacks; never display substitute identities.
	var attackers := $EnemyContainer.get_children()
	var result := AttackDataLoader.load_attacks(attack_data_path, attackers.size())
	data_error = result.error
	if not data_error.is_empty():
		$EnemyContainer.hide()
		$EnemyContainer.process_mode = Node.PROCESS_MODE_DISABLED
		push_error(data_error)
		return
	attack_records = result.records
	for index in range(attackers.size()):
		var attacker = attackers[index]
		for property in attack_records[index]:
			attacker.set(property, attack_records[index][property])
		attacker.attacker_selected.connect(_on_attacker_selected)
		attacker.attacker_hovered.connect(_on_attacker_hovered)


func _ready() -> void:
	# One deterministic hover/click target, even where interaction circles overlap.
	var viewport := get_viewport()
	_previous_picking_sort = viewport.physics_object_picking_sort
	_previous_picking_first_only = viewport.physics_object_picking_first_only
	viewport.physics_object_picking_sort = true
	viewport.physics_object_picking_first_only = true
	if not data_error.is_empty():
		$HUD/AttackInfoPanel.show_unavailable()


func _exit_tree() -> void:
	var viewport := get_viewport()
	viewport.physics_object_picking_sort = _previous_picking_sort
	viewport.physics_object_picking_first_only = _previous_picking_first_only


func _draw() -> void:
	for radius in Enemy.RING_RADII:
		draw_arc(Vector2(800, 450), radius, 0.0, TAU, 192, Color(0.25, 0.32, 0.4, 0.65), 1.5, true)


func _on_attacker_selected(attack_id: int) -> void:
	var selected_record: Dictionary = {}
	for record in attack_records:
		if record.attack_id == attack_id:
			selected_record = record
			break
	if selected_record.is_empty():
		push_error("Cannot display attack information: unknown attack_id %d." % attack_id)
		$HUD/AttackInfoPanel.show_unavailable()
		return
	selected_attack_id = attack_id
	for attacker in $EnemyContainer.get_children():
		attacker.set_selected(attacker.attack_id == attack_id)
	$HUD/AttackInfoPanel.show_attack(selected_record)


func _on_attacker_hovered(attack_id: int) -> void:
	hovered_attack_id = attack_id
