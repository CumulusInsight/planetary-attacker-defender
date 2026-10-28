extends Button
## Native vectors: white idle check, green selected check; never answer correctness.
var kind:="check"
var selected_answer:=false
func _ready() -> void:
	focus_mode=Control.FOCUS_ALL
	mouse_entered.connect(queue_redraw)
	mouse_exited.connect(queue_redraw)
func _draw() -> void:
	var color:=icon_color()
	if disabled:color.a=0.45
	var c:=size/2.0
	if selected_answer:draw_style_box(selection_style(),Rect2(Vector2.ONE,size-Vector2(2,2)))
	if kind=="check":
		draw_polyline(PackedVector2Array([c+Vector2(-9,0),c+Vector2(-3,6),c+Vector2(9,-7)]),color,check_width(),true)
	else:
		for side in [-1,1]:
			var x: float=side*11.0
			draw_polyline(PackedVector2Array([c+Vector2(0,-6),c+Vector2(x,-8),c+Vector2(x,7),c+Vector2(0,9),c+Vector2(0,-6)]),color,1.6,true)
			for y in [-3,1,5]:draw_line(c+Vector2(side*3,y),c+Vector2(side*8,y-1),color,1,true)
func selection_style() -> StyleBoxFlat:
	var style:=StyleBoxFlat.new();style.bg_color=Color("21445e");style.border_color=Color("8ac8f0");style.set_border_width_all(1)
	return style

func icon_color() -> Color:
	return Color("70ee94") if kind=="check" and selected_answer else Color("e6eef8")
func check_width() -> float:return 3.0 if selected_answer else 1.5
