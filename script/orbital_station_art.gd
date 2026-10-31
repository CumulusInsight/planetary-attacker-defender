extends Control
## Decorative schematic only; no systems telemetry or simulation actors.
func _draw() -> void:
	var c:=size/2
	var scale_factor:=minf(size.x/640,size.y/270)
	draw_set_transform(c,0,Vector2.ONE*scale_factor)
	for side in [-1,1]:
		draw_line(Vector2(side*90,0),Vector2(side*245,0),Color("66899e"),12)
		for y in [-100,22]:
			var r:=Rect2(Vector2(side*170-62,y),Vector2(124,78))
			draw_rect(r,Color("102d4b"));draw_rect(r,Color("5488a4"),false,2)
			for i in range(1,6):draw_line(r.position+Vector2(i*20,0),r.position+Vector2(i*20,78),Color("34607c"),1)
			for i in range(1,4):draw_line(r.position+Vector2(0,i*19),r.position+Vector2(124,i*19),Color("34607c"),1)
	draw_circle(Vector2.ZERO,112,Color("0a1e30"));draw_arc(Vector2.ZERO,106,0,TAU,96,Color("6d9bad"),12,true)
	draw_arc(Vector2.ZERO,88,0,TAU,96,Color("183f54"),19,true)
	for i in range(16):
		var p:=Vector2.from_angle(i*TAU/16)*89
		draw_circle(p,3,Color("5ad9ef"))
	draw_rect(Rect2(-41,-72,82,144),Color("294559"));draw_rect(Rect2(-41,-72,82,144),Color("8fb4c6"),false,2)
	for y in [-49,-23,3,29]:draw_rect(Rect2(-25,y,50,10),Color("48bad4"))
	draw_set_transform(Vector2.ZERO)
func _notification(what: int) -> void:
	if what==NOTIFICATION_RESIZED:queue_redraw()
