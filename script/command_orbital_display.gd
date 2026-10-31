extends "res://script/pursuit_display.gd"
## Draw-only adaptation. All paths, positions, picking and outcomes stay inherited.
func _draw() -> void:
	if not active:return
	var font:=ThemeDB.fallback_font
	for c in centers:
		var tile: Rect2=tiles[c];var origin: Vector2=origins[c];var ratio: float=ratios[c]
		draw_rect(tile,Color(0.012,0.04,0.065,0.62));draw_rect(tile,Color("315666"),false,1)
		for radius in [160,280,400]:draw_arc(origin,radius*ratio,0,TAU,80,Color(0.22,0.64,0.77,0.55),1.2,true)
		draw_circle(origin,14,Color("d2ac4d"));draw_string(font,origin+Vector2(-16,5),"DATA",HORIZONTAL_ALIGNMENT_LEFT,-1,12,Color.BLACK)
		if status_areas.has(c):draw_rect(status_areas[c],Color(0.02,0.07,0.10,0.85))
