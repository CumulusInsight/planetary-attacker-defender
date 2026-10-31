extends Button
var kind:="overview"
func _draw() -> void:
	var p:=Vector2(size.x/2,28);var color:=Color("82e0f2") if button_pressed else Color("d8ecf4")
	if kind=="overview":
		for d in [Vector2(0,-11),Vector2(-15,11),Vector2(15,11)]:draw_line(p,p+d,color,2,true);draw_circle(p+d,5,color)
	elif kind=="assessment":
		draw_arc(p,13,0,TAU,48,color,2,true)
		for d in [Vector2.LEFT,Vector2.RIGHT,Vector2.UP,Vector2.DOWN]:draw_line(p+d*8,p+d*20,color,2,true)
		draw_circle(p,3,color)
	elif kind=="evidence":
		draw_rect(Rect2(p-Vector2(12,17),Vector2(24,34)),color,false,2)
		for y in [-8,0,8]:draw_line(p+Vector2(-6,y),p+Vector2(7,y),color,2,true)
	else:
		draw_line(p+Vector2(-12,-16),p+Vector2(-12,16),color,2,true)
		for y in [-11,0,11]:draw_circle(p+Vector2(-12,y),3,color);draw_line(p+Vector2(-5,y),p+Vector2(14,y),color,2,true)
