extends PanelContainer
## Presentation only: the controller supplies already validated attack records.

var displayed_attack_id: int = -1

@onready var abbreviation_label: Label = %Abbreviation
@onready var attack_id_label: Label = %AttackId
@onready var description_label: Label = %Description
@onready var severity_label: Label = %Severity
@onready var description_scroll: ScrollContainer = %DescriptionScroll


func _ready() -> void:
	show_empty()


func show_attack(record: Dictionary) -> void:
	displayed_attack_id = record.attack_id
	abbreviation_label.text = record.abbreviation
	attack_id_label.text = "Attack ID: %d" % record.attack_id
	description_label.text = record.description
	severity_label.text = "Severity: %d" % record.severity
	description_scroll.scroll_vertical = 0


func show_empty() -> void:
	_clear_details()
	abbreviation_label.text = "Select an attacker"


func show_unavailable() -> void:
	_clear_details()
	abbreviation_label.text = "Attack information unavailable"


func _clear_details() -> void:
	displayed_attack_id = -1
	abbreviation_label.text = ""
	attack_id_label.text = ""
	description_label.text = ""
	severity_label.text = ""
	description_scroll.scroll_vertical = 0
