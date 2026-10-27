extends "res://script/learning_projectile.gd"
## Only the learning-game trajectory changes. Model answer correctness remains immutable.
var evaded:=false
func _init() -> void:duration=18.0
func evade(clock: float) -> bool:
	if evaded or impacted_already or clock>=fired_at+duration:return false
	evaded=true;hit=false
	return true
