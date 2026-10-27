extends "res://script/six_center_display.gd"
## Presentation-only status bands; session results remain the single authority.
var status_labels: Dictionary={}
var status_areas: Dictionary={}
func layout_centers(ids: Array) -> void:
	var original_area:=area
	if ids.size() in [2,3]:area.size.y-=52
	super.layout_centers(ids)
	area=original_area
	status_areas.clear()
	for center in centers:
		var count:=0
		for q in owner_game.loader.questions:
			if q.center_id==center:count+=1
		var original: Rect2=tiles[center]
		var height: float=maxf(46,minf(140,count*(50 if centers.size()>3 else 42)))
		status_areas[center]=Rect2(original.position+Vector2(4,original.size.y-height),Vector2(original.size.x-8,height-4))
		tiles[center]=Rect2(original.position,Vector2(original.size.x,original.size.y-height-4))
		origins[center]=tiles[center].get_center()
		ratios[center]=minf((tiles[center].size.x-66)/800,(tiles[center].size.y-74)/800)
func sync(enabled: bool) -> void:
	super.sync(enabled)
	for center in centers:
		if not status_labels.has(center):
			var text:=Label.new();text.mouse_filter=Control.MOUSE_FILTER_IGNORE;text.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;text.add_theme_font_override("font",ThemeDB.fallback_font);add_child(text);status_labels[center]=text
	for center in status_labels:
		var text: Label=status_labels[center];text.visible=enabled and center in centers
		if not text.visible:continue
		text.position=status_areas[center].position;text.size=status_areas[center].size;text.add_theme_font_size_override("font_size",14 if centers.size()>3 else 18)
		var lines: PackedStringArray=[]
		for q in owner_game.loader.questions:
			if q.center_id!=center:continue
			var status: String=owner_game.session.live_status(int(q.contact_id))
			if not status.is_empty():lines.append("C-%03d: %s" % [q.contact_id,status])
		text.text="\n".join(lines);text.tooltip_text=text.text
	queue_redraw()
func _draw() -> void:
	super._draw()
	if not active:return
	for center in centers:draw_rect(status_areas[center],Color("111e2b"))
