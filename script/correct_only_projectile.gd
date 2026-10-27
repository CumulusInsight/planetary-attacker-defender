extends "res://script/monte_carlo_projectile.gd"
## Normalize floating-point equality at the 36-second boundary; no new clock.
func step(clock: float) -> void:
	var impact_time: float=fired_at+duration
	# Addition followed by subtraction can still yield 35.99999999999999.
	# A nanosecond visual comparison nudge stays inside the existing 1e-8 tolerance.
	# The session still records the unchanged authoritative simulation clock.
	super.step(impact_time+0.000000001 if absf(clock-impact_time)<=0.00000001 else clock)
