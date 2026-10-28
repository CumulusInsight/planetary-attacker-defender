extends Node2D
var owner_game: Node
var centers: Array=[]
var tiles: Dictionary={}
var origins: Dictionary={}
var ratios: Dictionary={}
var markers: Dictionary={}
var area:=Rect2(20,184,1198,648)
var active:=false
var trails: Dictionary={}
func configure(game: Node) -> void:
	owner_game=game;layout_centers(["DC-01","DC-02","DC-03","DC-04","DC-05","DC-06"])
func layout_centers(ids: Array) -> void:
	centers=ids.duplicate();centers.sort();tiles.clear();origins.clear();ratios.clear()
	var columns: int=3 if centers.size()>3 else maxi(1,centers.size());var rows: int=2 if centers.size()>3 else 1
	var size:=Vector2((area.size.x-16*(columns-1))/columns,(area.size.y-(52 if rows==2 else 0)-16*(rows-1))/rows)
	for i in range(centers.size()):
		var tile:=Rect2(area.position+Vector2(i%columns,i/columns)*(size+Vector2(16,16)),size)
		tiles[centers[i]]=tile;origins[centers[i]]=tile.get_center();ratios[centers[i]]=minf((size.x-66)/800,(size.y-74)/800)
func physical_alive(slot: int) -> bool:
	var key: String=owner_game.session.physical_slots.get(slot,"")
	return key.is_empty() or owner_game.session.physical_targets[key].alive
func ensure_markers() -> void:
	for slot in owner_game.learning_contacts:
		if markers.has(slot):continue
		var marker:=Node2D.new();add_child(marker);markers[slot]=marker
		if owner_game.command.registry.contacts.has(slot) and owner_game.actor_for(slot).has_node("Sprite2D"):
			var sprite=owner_game.actor_for(slot).get_node("Sprite2D").duplicate();sprite.name="Artwork";marker.add_child(sprite)
		else:
			var shape:=Polygon2D.new();shape.polygon=PackedVector2Array([Vector2(0,-7),Vector2(7,0),Vector2(0,7),Vector2(-7,0)]);shape.color=Color("9be2f4");marker.add_child(shape)
		var caption:=Label.new();caption.name="Identifier";caption.position=Vector2(-24,10);caption.add_theme_font_size_override("font_size",13);caption.mouse_filter=Control.MOUSE_FILTER_IGNORE;marker.add_child(caption)
		var pick:=Button.new();pick.flat=true;pick.modulate.a=0;pick.position=Vector2(-14,-14);pick.size=Vector2(28,28);marker.add_child(pick);pick.pressed.connect(func():owner_game.focus_contact(slot))
		pick.mouse_entered.connect(func():owner_game.set_learning_hover(slot,true))
		pick.mouse_exited.connect(func():owner_game.set_learning_hover(slot,false))
func sync(enabled: bool) -> void:
	active=enabled;visible=enabled
	if not enabled:return
	ensure_markers()
	for slot in markers:
		var row: Dictionary=owner_game.learning_contacts[slot];var c: String=row.center_id;var marker: Node2D=markers[slot]
		marker.visible=c in centers and physical_alive(slot)
		if not marker.visible:continue
		var offset: Vector2=owner_game.orbit_offset(slot)
		var base: Vector2=origins[c]+offset*float(ratios[c]);var position: Vector2=base
		if marker.has_node("Artwork"):
			var source=owner_game.actor_for(slot);marker.get_node("Artwork").scale=source.get_node("Sprite2D").scale*maxf(0.35,ratios[c])*source.scale
		var shot: Dictionary=owner_game.session.flights.get(slot,{})
		if shot.get("evasion_attempted",false):
			var started: float=shot.get("evasion_started",owner_game.session.now);var t: float=owner_game.session.now-started
			var incoming: Vector2=(base-origins[c]).normalized();var lateral:=incoming.orthogonal()
			var envelope: float=minf(1,t/0.4)
			position+=lateral*sin(t*TAU/1.4)*minf(tiles[c].size.x,tiles[c].size.y)*0.30*envelope
			trails[slot]=trails.get(slot,PackedVector2Array());var points: PackedVector2Array=trails[slot]
			if points.is_empty() or points[-1].distance_to(position)>1:points.append(position.clamp(tiles[c].position+Vector2(22,42),tiles[c].end-Vector2(40,24)))
			if points.size()>120:points.remove_at(0)
			trails[slot]=points
		elif trails.has(slot):trails.erase(slot)
		# Smoothly return survivors to orbit; simulation pause holds this state too.
		if marker.has_meta("last_clock") and not shot.get("evasion_attempted",false):
			var delta: float=maxf(0,owner_game.session.now-float(marker.get_meta("last_clock")))
			if marker.get_meta("returning",false):position=marker.position.lerp(base,minf(1,delta*3));marker.set_meta("returning",position.distance_to(base)>1)
		if shot.get("evasion_attempted",false):marker.set_meta("returning",true)
		marker.position=position.clamp(tiles[c].position+Vector2(22,42),tiles[c].end-Vector2(40,24));marker.set_meta("last_clock",owner_game.session.now)
		var key: String=owner_game.session.physical_slots.get(slot,"");marker.set_meta("physical_id",key)
		marker.get_node("Identifier").text="C-%03d/P%d" % [slot,owner_game.session.physical_targets.get(key,{}).get("version",1)]
	queue_redraw()
func _draw() -> void:
	if not active:return
	var font:=ThemeDB.fallback_font;draw_rect(area,Color("03080d"))
	for c in centers:
		var tile: Rect2=tiles[c];var origin: Vector2=origins[c];var ratio: float=ratios[c]
		draw_rect(tile,Color("385165"),false,1);draw_string(font,tile.position+Vector2(12,24),"Learning / "+c,HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color("c7e9fa"))
		for radius in [160,280,400]:draw_arc(origin,radius*ratio,0,TAU,64,Color("385165"),1,true)
		draw_circle(origin,14,Color("d2ac4d"));draw_string(font,origin+Vector2(-16,5),"DATA",HORIZONTAL_ALIGNMENT_LEFT,-1,12,Color.BLACK)
	for slot in trails:
		if markers.has(slot) and markers[slot].visible and trails[slot].size()>1:draw_polyline(trails[slot],Color(1,0.7,0.2,0.6),2,true)

	draw_selection_marker()
func draw_selection_marker() -> void:
	if markers.has(owner_game.learning_selected) and markers[owner_game.learning_selected].visible:draw_arc(markers[owner_game.learning_selected].position,17,0,TAU,32,Color("fff09e"),2,true)
