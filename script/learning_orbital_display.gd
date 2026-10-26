extends Node2D
## Read-only, screen-space projection of the existing tactical actors. No movement integration.
var owner_game: Node
var centers: Array=[]
var tiles:={}
var origins:={}
var ratios:={}
var markers:={}
var sources:={}
var interactions:={}
var hovered:=-1
var active:=false
var area:=Rect2(20,184,1198,648)
func configure(game: Node) -> void:
	owner_game=game;centers.clear()
	for q in game.loader.questions:
		if q.center_id not in centers:centers.append(q.center_id)
	centers.sort()
	layout_centers(centers)
func layout_centers(ids: Array) -> void:
	centers=ids.duplicate();tiles.clear();origins.clear();ratios.clear()
	var width: float=(area.size.x-16*(centers.size()-1))/maxi(1,centers.size())
	for i in range(centers.size()):
		var c: String=centers[i];var tile:=Rect2(area.position+Vector2(i*(width+16),0),Vector2(width,area.size.y))
		tiles[c]=tile;origins[c]=tile.get_center();ratios[c]=minf((width-68)/800.0,(tile.size.y-110)/800.0)
func ensure_markers() -> void:
	for id in owner_game.command.registry.contacts:
		var c: String=owner_game.command.registry.contacts[id].center_id
		if c not in centers or markers.has(id):continue
		var actor=owner_game.actor_for(id);sources[id]=actor
		var marker:=Node2D.new();add_child(marker);markers[id]=marker
		if actor.has_node("Sprite2D"):
			var sprite=actor.get_node("Sprite2D").duplicate();sprite.name="Artwork";marker.add_child(sprite)
		else:
			var shape:=Polygon2D.new();shape.polygon=PackedVector2Array([Vector2(0,-9),Vector2(9,0),Vector2(0,9),Vector2(-9,0)]);shape.color=Color("a8d8ee");marker.add_child(shape)
		var caption:=Label.new();caption.name="Identifier";caption.text="C-%03d" % id;caption.position=Vector2(-26,17);caption.mouse_filter=Control.MOUSE_FILTER_IGNORE;caption.add_theme_font_size_override("font_size",14);marker.add_child(caption)
		var hitbox:=Control.new();hitbox.position=Vector2(-19,-19);hitbox.size=Vector2(38,38);hitbox.mouse_filter=Control.MOUSE_FILTER_STOP;marker.add_child(hitbox);interactions[id]=hitbox
		hitbox.mouse_entered.connect(func():hover_contact(id))
		hitbox.mouse_exited.connect(func():exit_contact(id))
		hitbox.gui_input.connect(func(event):
			if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
				owner_game.focus_contact(id);hitbox.accept_event())
func hover_contact(id: int) -> void:
	if not active:return
	if hovered!=id and hovered>=0:exit_contact(hovered)
	hovered=id;sources[id]._on_area_2d_mouse_entered()
func exit_contact(id: int) -> void:
	if hovered==id:
		sources[id]._on_area_2d_mouse_exited();hovered=-1
func sync(enabled: bool) -> void:
	active=enabled;visible=enabled
	if not enabled:
		if hovered>=0:exit_contact(hovered)
		return
	ensure_markers()
	for id in markers:
		var c: String=owner_game.command.registry.contacts[id].center_id
		var actor=sources[id];var marker=markers[id]
		if c not in centers:
			marker.hide()
			if hovered==id:exit_contact(id)
			continue
		marker.position=origins[c]+(actor.position-actor.center_position)*float(ratios[c])
		marker.visible=not owner_game.session.results.get(id,{}).get("hit",false)
		if not marker.visible and hovered==id:exit_contact(id)
		if marker.has_node("Artwork"):marker.get_node("Artwork").scale=actor.get_node("Sprite2D").scale*maxf(0.5,ratios[c])*actor.scale
	queue_redraw()
func _draw() -> void:
	if not active:return
	var font:=ThemeDB.fallback_font
	draw_rect(area,Color("03080d"))
	for c in centers:
		var tile: Rect2=tiles[c];var center: Vector2=origins[c];var scale: float=ratios[c]
		draw_rect(tile,Color("253d50"),false,1)
		draw_string(font,tile.position+Vector2(18,28),"Learning / "+c,HORIZONTAL_ALIGNMENT_LEFT,-1,21,Color("c7e9fa"))
		for radius in [160,280,400]:draw_arc(center,radius*scale,0,TAU,96,Color("385165"),1.5,true)
		var tactical=owner_game.command.tactical_centers[c]
		for actor in tactical.get_node("EnemyContainer").get_children():
			if not "path" in actor:continue
			var points:=PackedVector2Array()
			for i in range(97):
				var angle:=TAU*i/96.0
				points.append(center+Vector2(actor.path.horizontal_radius*cos(angle),actor.path.vertical_radius*sin(angle)).rotated(actor.path.orientation)*scale)
			draw_polyline(points,Color("23434e"),1,true)
		var texture: Texture2D=tactical.get_node("DataCenter/Sprite2D").texture
		draw_texture_rect(texture,Rect2(center-Vector2(26,26),Vector2(52,52)),false)
		draw_string(font,center+Vector2(-19,5),"DATA",HORIZONTAL_ALIGNMENT_LEFT,-1,15,Color.WHITE)
		draw_string(font,center+Vector2(-48,43),"$1,000,000",HORIZONTAL_ALIGNMENT_LEFT,-1,15,Color.WHITE)

	for id in markers:
		if markers[id].visible and sources[id].is_selected:draw_arc(markers[id].position,17,0,TAU,32,Color("fff09e"),2,true)
