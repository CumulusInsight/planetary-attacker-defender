extends Node2D
## Deterministic homing visual in world coordinates; elapsed comes only from the shared simulation clock.
signal impacted(contact_id: int,generation: int)
var target: Node2D
var origin:=Vector2.ZERO
var head:=Vector2.ZERO
var trail:=PackedVector2Array()
var fired_at:=0.0
var hit:=false
var target_at_impact:=Vector2.ZERO
var contact_id:=-1
var generation:=0
var impacted_already:=false
var elapsed:=0.0
const HIT_EFFECT_DURATION:=1.95
const MISS_EFFECT_DURATION:=0.65
const HIT_RADIUS_MULTIPLIER:=3.0
var duration:=3.6
var last_step_clock: Variant=null
var visual_lane:=0.0
var volley:=false
var visual_scale:=1.0
var visual_bounds:=Rect2()
func setup(actor: Node2D,start: Vector2,clock: float,shot: Dictionary) -> void:
	target=actor;origin=start;head=start;fired_at=clock;hit=shot.hit;contact_id=shot.contact_id;generation=shot.generation
	visual_scale=shot.get("visual_scale",1.0);visual_bounds=shot.get("visual_bounds",Rect2());visual_lane=shot.get("visual_lane",0.0);volley=shot.get("volley",false)
	z_index=4090
func step(clock: float) -> void:
	if not is_instance_valid(target):queue_free();return
	if last_step_clock!=null and clock<=last_step_clock:return
	last_step_clock=clock
	elapsed=maxf(0,clock-fired_at)
	if not impacted_already:
		var p:=clampf(elapsed/duration,0,1)
		var endpoint: Vector2=target.global_position
		if not hit:
			var miss: Vector2=endpoint+Vector2(115,-95)*visual_scale
			if visual_bounds.has_area():miss=miss.clamp(visual_bounds.position,visual_bounds.end)
			if miss.distance_to(endpoint)<20:miss=endpoint+(origin-endpoint).normalized()*28
			endpoint=endpoint.lerp(miss,maxf(0,(p-0.6)/0.4))
		head=origin.lerp(endpoint,p)+(endpoint-origin).normalized().orthogonal()*sin(PI*p)*visual_lane;trail.append(head)
		if trail.size()>28:trail.remove_at(0)
		if p>=1:
			target_at_impact=target.global_position
			if hit:head=target_at_impact
			impacted_already=true;impacted.emit(contact_id,generation)
	elif elapsed>duration+effect_duration():queue_free()
	queue_redraw()
func _draw() -> void:
	if trail.size()>1:draw_polyline(trail,Color(0.3,0.9,1,0.85),maxf(3,5*visual_scale),true)
	if not impacted_already:
		if volley:draw_string(ThemeDB.fallback_font,head+Vector2(-60 if head.x>origin.x else 12,-12),"C-%03d" % contact_id,HORIZONTAL_ALIGNMENT_LEFT,-1,14,Color.WHITE)
		draw_circle(head,maxf(5,9*visual_scale),Color(0.8,0.98,1));draw_arc(head,maxf(8,14*visual_scale),0,TAU,24,Color(0.1,0.7,1),2,true)
	else:draw_impact(self)
func effect_duration() -> float:return HIT_EFFECT_DURATION if hit else MISS_EFFECT_DURATION
func impact_radius(spread: float) -> float:
	return (12+spread*48)*maxf(0.5,visual_scale)*(HIT_RADIUS_MULTIPLIER if hit else 1.0)
func draw_impact(painter: CanvasItem) -> void:
	if not impacted_already:return
	var spread:=clampf((elapsed-duration)/effect_duration(),0,1)
	var color:=Color(0.45,0.92,1,1-spread) if hit else Color(1,0.7,0.25,1-spread)
	var radius_scale: float=maxf(0.5,visual_scale)*(HIT_RADIUS_MULTIPLIER if hit else 1.0)
	if hit:
		var ring:=PackedVector2Array()
		for i in range(41):ring.append(head+Vector2.from_angle(i*TAU/40)*impact_radius(spread))
		draw_effect_line(painter,ring,color,5)
	else:painter.draw_arc(head,impact_radius(spread),0,TAU,40,color,5,true)
	for i in range(10):
		var direction:=Vector2.from_angle(i*TAU/10)
		var points:=PackedVector2Array([head+direction*(12+spread*20)*radius_scale,head+direction*(24+spread*45)*radius_scale])
		if hit:draw_effect_line(painter,points,color,3)
		else:painter.draw_line(points[0],points[1],color,3,true)
func effect_segments(points: PackedVector2Array) -> Array:
	if not hit or not visual_bounds.has_area():return [points]
	# Clip geometry itself, avoiding a persistent canvas clip that could affect other UI.
	var rect:=visual_bounds.grow(-3)
	var polygon:=PackedVector2Array([rect.position,Vector2(rect.end.x,rect.position.y),rect.end,Vector2(rect.position.x,rect.end.y)])
	return Geometry2D.intersect_polyline_with_polygon(points,polygon)
func draw_effect_line(painter: CanvasItem,points: PackedVector2Array,color: Color,width: float) -> void:
	for segment in effect_segments(points):
		if segment.size()>1:painter.draw_polyline(segment,color,width,true)
