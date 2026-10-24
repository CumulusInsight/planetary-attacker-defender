extends RefCounted
## Reads actual movement travel; never integrates delta or wall-clock time.
var initial: Dictionary = {}
var budget: float = 0.0

func capture(contact: Node, seconds: float) -> bool:
	if not is_finite(seconds) or seconds <= 0.0 or contact.move_speed <= 0.0:
		return false
	initial = {"angle": contact.orbit_angle, "progress": contact.orbit_progress,
		"ring": contact.current_ring, "travel": contact.total_orbit_travel}
	budget = absf(contact.move_speed) * seconds
	return true

func remaining(contact: Node) -> float:
	return maxf(0.0, budget - (contact.total_orbit_travel - initial.travel)) / absf(contact.move_speed)

func restore(contact: Node) -> void:
	contact.orbit_angle = initial.angle
	contact.orbit_progress = initial.progress
	contact.current_ring = initial.ring
	contact.orbit_radius = contact.RING_RADII[contact.current_ring]
	contact.total_orbit_travel = initial.travel
	contact._update_position()
