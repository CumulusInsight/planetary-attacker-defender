extends "res://script/martian_projectile.gd"
var evasion_attempted:=false
var evasion_started:=0.0
func _init() -> void:duration=36.0
func order_evasion(clock: float,success: bool) -> bool:
	if evasion_attempted or impacted_already or clock>=fired_at+duration:return false
	evasion_attempted=true;evasion_started=clock
	# Incorrect countermeasures remain MISS even if their evasion roll succeeds.
	if success and hit:evaded=true;hit=false
	return true
