extends "res://script/live_status_display.gd"
## Cosmetic pursuit only. No method here writes a grade, RNG roll or physical outcome.
var pursuits: Dictionary={}
var departed: Dictionary={}
var reentries: Dictionary={}
var seen_generation:=-1
func configure(game: Node) -> void:
	owner_game=game
	if seen_generation!=game.session.generation and game.session.round_index==0:departed.clear();reentries.clear()
	seen_generation=game.session.generation;pursuits.clear();trails.clear()
	layout_centers(["DC-01","DC-02","DC-03","DC-04","DC-05","DC-06"])
	for q in game.loader.questions:
		var id:=int(q.contact_id);var key: String=game.session.question_targets.get(q.learning_id,"")
		if departed.has(key) and game.session.physical_targets.get(key,{}).get("alive",false):
			reentries[id]={"time":game.session.now,"key":key};departed.erase(key)
func ray_end(start: Vector2,direction: Vector2,rect: Rect2) -> Vector2:
	var distance:=100000.0
	if absf(direction.x)>0.0001:distance=minf(distance,((rect.end.x if direction.x>0 else rect.position.x)-start.x)/direction.x)
	if absf(direction.y)>0.0001:distance=minf(distance,((rect.end.y if direction.y>0 else rect.position.y)-start.y)/direction.y)
	return start+direction*maxf(0,distance)
func start_pursuit(id: int,shot: Dictionary) -> void:
	var center: String=owner_game.learning_contacts[id].center_id;var start: Vector2=markers[id].position
	if reentries.has(id):
		start=start.clamp(tiles[center].position+Vector2(24,44),tiles[center].end-Vector2(24,24));markers[id].position=start;reentries.erase(id)
	var direction: Vector2=(start-origins[center]).normalized()
	if direction.length()<0.5:direction=Vector2.from_angle(float(id)*0.73)
	pursuits[id]={"start":start,"direction":direction,"time":owner_game.session.now,"physical_id":shot.physical_id,"generation":shot.generation,"center":center}
func sync(enabled: bool) -> void:
	active=enabled;visible=enabled
	if not enabled:return
	ensure_markers()
	for id in markers:
		var center: String=owner_game.learning_contacts[id].center_id;var marker: Node2D=markers[id]
		var key: String=owner_game.session.physical_slots.get(id,"")
		marker.visible=center in centers and physical_alive(id) and not departed.has(key)
		if center not in centers:continue
		var base: Vector2=origins[center]+owner_game.orbit_offset(id)*float(ratios[center]);var position:=base
		var result: Dictionary=owner_game.session.results.get(id,{})
		if result.get("projectile_outcome","")=="EVADED" and pursuits.has(id):departed[key]=true;marker.visible=false
		if pursuits.has(id) and int(pursuits[id].generation)==owner_game.session.generation and result.is_empty():
			var path: Dictionary=pursuits[id];var t: float=clampf((owner_game.session.now-float(path.time))/36.0,0,1)
			var inside: Vector2=ray_end(path.start,path.direction,tiles[center].grow(-24))
			position=path.start.lerp(inside,t*0.65)
			var shot: Dictionary=owner_game.session.flights.get(id,{})
			if shot.get("evasion_attempted",false):
				if not path.has("turn_time"):
					path.turn_time=owner_game.session.now;path.turn_start=position
					path.turn_end=ray_end(position,path.direction,tiles[center].grow(6) if shot.get("evasion_success",false) else tiles[center].grow(-24))
					path.inside_exit=ray_end(position,path.direction,tiles[center].grow(-6));path.escape=shot.get("evasion_success",false)
				var remaining: float=maxf(0.001,float(path.time)+36.0-float(path.turn_time))
				var turn: float=clampf((owner_game.session.now-float(path.turn_time))/remaining,0,1)
				# A continuous directional leg, with gentle acceleration rather than alternating lateral jumps.
				if path.escape:
					# Keep the target observable until the final passage leg, then cross only its own boundary.
					var leg: float=clampf(turn/0.94,0,1) if turn<=0.94 else clampf((turn-0.94)/0.06,0,1)
					position=Vector2(path.turn_start if turn<=0.94 else path.inside_exit).lerp(path.inside_exit if turn<=0.94 else path.turn_end,leg*leg*(3-2*leg))
				else:position=Vector2(path.turn_start).lerp(path.turn_end,turn*turn*(3-2*turn))
			marker.visible=physical_alive(id) and tiles[center].has_point(position)
		elif reentries.has(id):
			var entry: Dictionary=reentries[id];var t: float=clampf((owner_game.session.now-float(entry.time))/4.0,0,1)
			position=Vector2(tiles[center].end.x+20,tiles[center].get_center().y).lerp(base,t*t*(3-2*t));marker.visible=physical_alive(id) and tiles[center].has_point(position)
			if t>=1:reentries.erase(id)
		else:position=position.clamp(tiles[center].position+Vector2(22,42),tiles[center].end-Vector2(40,24))
		marker.position=position;marker.set_meta("physical_id",key)
		if marker.has_node("Artwork"):
			var source=owner_game.actor_for(id);marker.get_node("Artwork").scale=source.get_node("Sprite2D").scale*maxf(0.35,ratios[center])*source.scale
		var caption: Label=marker.get_node("Identifier")
		caption.text="C-%03d/P%d" % [id,owner_game.session.physical_targets.get(key,{}).get("version",1)]
		# Keep the moving identifier out of the outcome band as a survivor exits.
		var caption_position: Vector2=(position+Vector2(-24,10)).clamp(tiles[center].position+Vector2(4,30),tiles[center].end-Vector2(caption.get_minimum_size().x+4,20))
		caption.position=caption_position-position
	for center in centers:
		if not status_labels.has(center):
			var text:=Label.new();text.mouse_filter=Control.MOUSE_FILTER_IGNORE;text.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;text.add_theme_font_override("font",ThemeDB.fallback_font);add_child(text);status_labels[center]=text
	for center in status_labels:
		var text: Label=status_labels[center];text.visible=enabled and center in centers
		if not text.visible:continue
		text.position=status_areas[center].position;text.size=status_areas[center].size;text.add_theme_font_size_override("font_size",14 if centers.size()>3 else 18)
		var lines: PackedStringArray=[]
		for q in owner_game.loader.questions:
			if q.center_id==center:
				var status: String=owner_game.session.live_status(int(q.contact_id))
				if not status.is_empty():lines.append("C-%03d: %s" % [q.contact_id,status])
		text.text="\n".join(lines);text.tooltip_text=text.text
	queue_redraw()
