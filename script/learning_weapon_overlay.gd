extends Node2D
var game: Node
var aim_point:=Vector2.ZERO
func configure(owner: Node) -> void:game=owner
func _process(_delta: float) -> void:
	if is_instance_valid(game):aim_point=get_global_mouse_position();queue_redraw()
func _draw() -> void:
	if not is_instance_valid(game) or not game.learning_context:return
	var display=game.orbital_display
	var id: int=game.player_target if game.session.firing_mode=="PLAYER FIRE" else game.learning_selected
	if display.markers.has(id) and display.markers[id].visible:
		var point: Vector2=display.markers[id].position;var color:=Color("f9e46b")
		draw_arc(point,23,0,TAU,64,color,2,true);draw_arc(point,29,0,TAU,64,Color(1,0.85,0.3,0.5),1,true)
		for i in range(16):
			var direction:=Vector2.from_angle(i*TAU/16);draw_line(point+direction*24,point+direction*(34 if i%4==0 else 28),color,2,true)
		for direction in [Vector2.LEFT,Vector2.RIGHT,Vector2.UP,Vector2.DOWN]:draw_line(point+direction*5,point+direction*19,color,1.5,true)
	if game.session.firing_mode!="PLAYER FIRE":return
	for center in display.centers:
		var origin: Vector2=display.origins[center];var direction: Vector2=(aim_point-origin).normalized()
		draw_circle(origin,11,Color("3a778e"));draw_line(origin,origin+direction*27,Color("f6f5da"),7,true);draw_line(origin,origin+direction*31,Color("57d9eb"),2,true)
