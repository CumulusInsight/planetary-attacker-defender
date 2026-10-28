extends "res://script/correct_only_projectile.gd"
## Same 36-second authoritative callback; a faster-looking continuous closing curve.
const TRAIL_SECONDS:=40.0
var samples: Array=[]
func trail_pulse() -> float:return 0.65+0.35*(0.5+0.5*sin(elapsed*TAU*2.0))
func step(clock: float) -> void:
	if not is_instance_valid(target):queue_free();return
	if last_step_clock!=null and clock<=float(last_step_clock):return
	last_step_clock=clock;elapsed=maxf(0,clock-fired_at)
	var at_boundary: bool=absf(clock-(fired_at+duration))<=0.00000001
	if not impacted_already:
		var t: float=1.0 if at_boundary else clampf(elapsed/duration,0,1)
		var close: float=1-pow(1-t,3);var destination: Vector2=target.global_position
		if not hit:
			# Keep a visible following gap; the target exits its own tile while the missile cannot catch it.
			var away: Vector2=(destination-origin).normalized();destination-=away*maxf(24,60*visual_scale)
		var next: Vector2=origin.lerp(destination,close)
		if visual_bounds.has_area():next=next.clamp(visual_bounds.position,visual_bounds.end)
		head=next;samples.append({"point":head,"time":clock});trail.append(head)
		if trail.size()>120:trail.remove_at(0)
		if t>=1:
			target_at_impact=target.global_position
			if hit:head=target_at_impact
			impacted_already=true;impacted.emit(contact_id,generation)
	elif elapsed>duration+effect_duration():samples.clear();queue_free()
	samples=samples.filter(func(s):return clock-float(s.time)<=TRAIL_SECONDS)
	queue_redraw()
func _draw() -> void:
	var clock: float=fired_at+elapsed
	for i in range(1,samples.size()):
		var a: Vector2=samples[i-1].point;var b: Vector2=samples[i].point
		var alpha: float=clampf(1-(clock-float(samples[i].time))/TRAIL_SECONDS,0,1)
		if impacted_already:alpha*=clampf(1-(elapsed-duration)/effect_duration(),0,1)
		draw_line(a,b,Color(1.0,0.06,0.04,alpha*trail_pulse()),maxf(3,6*visual_scale),true)
	if not impacted_already:
		draw_circle(head,maxf(5,9*visual_scale),Color("d5fbff"));draw_arc(head,maxf(8,14*visual_scale),0,TAU,24,Color("43baf5"),2,true)
	elif hit:draw_impact(self)
