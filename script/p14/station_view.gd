extends Control
## Native layered illustration. No P12 actors, orbital rules or physical records.
signal module_selected(id: String)
var session: RefCounted
var animation_time:=0.0
var selected:=""
var hotspots: Dictionary={}
const MODULES={"core":Vector2(775,417),"identity":Vector2(560,413),"network":Vector2(966,416)}
func _ready() -> void:
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	for key in MODULES:
		var b:=Button.new();b.flat=true;b.tooltip_text="Inspect "+key+" module";b.position=MODULES[key]+Vector2(-82,-68);b.size=Vector2(164,140)
		for state in ["normal","pressed","disabled"]:b.add_theme_stylebox_override(state,StyleBoxEmpty.new())
		var outline:=StyleBoxFlat.new();outline.bg_color=Color(0.5,0.85,0.9,0.025);outline.border_color=Color(0.5,0.85,0.9,0.5);outline.set_border_width_all(1);outline.set_corner_radius_all(15);b.add_theme_stylebox_override("hover",outline);b.add_theme_stylebox_override("focus",outline)
		var title:=Label.new();title.text={"core":"OPERATIONS","identity":"IDENTITY","network":"NETWORK"}[key];title.position=Vector2(0,141);title.size=Vector2(164,26);title.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;title.add_theme_font_size_override("font_size",18);title.add_theme_color_override("font_color",Color("a5e5ed"));title.mouse_filter=Control.MOUSE_FILTER_IGNORE;b.add_child(title)
		add_child(b);hotspots[key]=b;b.pressed.connect(func():module_selected.emit(key))
func _process(delta: float) -> void:
	if session!=null and not session.paused:animation_time+=delta
	for key in hotspots:hotspots[key].position=MODULES[key]+Vector2(-82,-68+sin(animation_time*0.3)*2)
	queue_redraw()
func projection(p: Vector3) -> Vector2:
	return Vector2((p.x-p.y)*0.84,(p.x+p.y)*0.36-p.z)+Vector2(775,462)
func polygon(points: Array,color: Color) -> void:
	var vertices:=PackedVector2Array()
	for p in points:vertices.append(projection(p))
	draw_colored_polygon(vertices,color)
func hull(x: float,y: float,w: float,d: float,h: float,tone: Color) -> void:
	var a:=Vector3(x-w/2,y-d/2,0);var b:=a+Vector3(w,0,0);var c:=b+Vector3(0,d,0);var e:=a+Vector3(0,d,0);var up:=Vector3(0,0,h)
	polygon([a,b,b+up,a+up],tone.darkened(0.4));polygon([b,c,c+up,b+up],tone.darkened(0.22));polygon([e,c,c+up,e+up],tone.darkened(0.5));polygon([a+up,b+up,c+up,e+up],tone)
	for edge in [[a+up,b+up],[b+up,c+up],[c+up,e+up],[e+up,a+up]]:draw_line(projection(edge[0]),projection(edge[1]),Color("96b4c0"),1.3,true)
	for i in range(1,5):
		var p:=Vector3(x-w/2+w*i/5,y+d/2+0.3,h*0.48)
		draw_line(projection(p),projection(p+Vector3(w/9,0,0)),Color("71d5e9"),3,true)
	# Roof hatches and side seams establish scale without a texture dependency.
	for i in range(3):
		var p:=Vector3(x-w*0.3+i*w*0.27,y-d*0.2,h+0.4)
		draw_line(projection(p),projection(p+Vector3(0,d*0.4,0)),tone.darkened(0.35),5,true)
	for i in range(1,5):draw_line(projection(Vector3(x+w/2,y-d/2+i*d/5,8)),projection(Vector3(x+w/2,y-d/2+i*d/5,h-5)),tone.darkened(0.45),1,true)
func cylinder(center: Vector2,radius: Vector2,height: float,color: Color) -> void:
	var top:=center-Vector2(0,height);var front:=PackedVector2Array()
	for i in range(41):front.append(top+Vector2(cos(i*PI/40)*radius.x,sin(i*PI/40)*radius.y))
	for i in range(40,-1,-1):front.append(center+Vector2(cos(i*PI/40)*radius.x,sin(i*PI/40)*radius.y))
	draw_station_ellipse(center,radius,color.darkened(0.5));draw_colored_polygon(front,color.darkened(0.3));draw_station_ellipse(top,radius,color);draw_station_ellipse(top,radius,Color("96b4c0"),false,1.5)
	for band in [0.28,0.72]:
		var points:=PackedVector2Array()
		for i in range(41):points.append(center-Vector2(0,height*band)+Vector2(cos(i*PI/40)*radius.x,sin(i*PI/40)*radius.y))
		draw_polyline(points,Color("1b3547"),5,true)
	for i in range(1,12):
		var a:=i*PI/12;var p:=center-Vector2(0,height*0.5)+Vector2(cos(a)*radius.x,sin(a)*radius.y)
		draw_line(p-Vector2(3,0),p+Vector2(3,0),Color("70d4e9"),3,true)
func solar(x: float,y: float) -> void:
	var p:=Vector3(x,y,8)
	polygon([p,p+Vector3(175,0,0),p+Vector3(175,124,0),p+Vector3(0,124,0)],Color("122944"))
	for i in range(8):draw_line(projection(p+Vector3(i*25,0,0)),projection(p+Vector3(i*25,124,0)),Color("44718c"),1,true)
	for i in range(6):draw_line(projection(p+Vector3(0,i*24.8,0)),projection(p+Vector3(175,i*24.8,0)),Color("44718c"),1,true)
func _draw() -> void:
	draw_set_transform(Vector2(0,sin(animation_time*0.3)*2))
	# Station hull shadow, solar wings, radiators, truss and layered modules.
	draw_station_ellipse(Vector2(790,530),Vector2(263,84),Color(0,0,0,0.27))
	solar(-355,-93);solar(180,-50);solar(-285,116);solar(210,125)
	for point in [Vector3(-155,0,0),Vector3(190,0,0),Vector3(0,-105,0),Vector3(0,150,0)]:draw_line(projection(Vector3.ZERO),projection(point),Color("526c7d"),18,true)
	hull(-163,89,108,81,53,Color("4e7283"));hull(125,-100,105,85,63,Color("537e8b"));hull(0,0,155,132,65,Color("607e8d"))
	cylinder(Vector2(775,456),Vector2(107,44),64,Color("678591"));cylinder(Vector2(775,390),Vector2(53,24),65,Color("88a2aa"))
	var hub:=projection(Vector3(0,0,65));draw_station_ellipse(hub,Vector2(113,49),Color("294353"),false,4)
	for i in range(22):
		var a:=i*TAU/22;var pos:=hub+Vector2(cos(a)*112,sin(a)*48);draw_circle(pos,2.3,Color("e9ba83") if i%4==0 else Color("4ed1e9"))
	# Antenna and beacon.
	var antenna:=projection(Vector3(125,-100,63));draw_line(antenna,antenna+Vector2(0,-62),Color("9ab7be"),3,true)
	draw_arc(antenna+Vector2(0,-67),24,0.12,PI-0.12,40,Color("93b7c3"),3,true)
	draw_circle(projection(Vector3(0,0,122)),4,Color(1,0.42,0.35,0.55+0.4*sin(animation_time*2)))
	if session!=null and session.upgrade_ready:
		var point: Vector2=MODULES[session.upgrade]
		for i in range(3):draw_arc(point,38+i*5,0,TAU,60,Color(0.3,0.85,0.78,0.25-float(i)*0.05),2,true)
		for i in range(4):draw_line(point+Vector2(-22+i*14,-6),point+Vector2(-22+i*14,-22),Color("87ead5"),3,true)
	if not selected.is_empty():draw_arc(MODULES[selected],72,0,TAU,70,Color("8fd4df"),1,true)
	if session!=null and session.incident!="QUIET" and not session.finished:
		var alert_color:=Color("e5b578") if not session.unauthorized else Color("e58483")
		alert_color.a=0.3+0.2*(sin(animation_time*2)+1)/2
		if not session.credentials_retired or (session.unauthorized and not session.session_revoked):draw_arc(MODULES.identity,80,0,TAU,70,alert_color,3,true)
	# A service craft follows a smooth repeating route; illustration only.
	var t:=animation_time*0.08;var craft:=Vector2(780+cos(t)*300,455+sin(t)*155)
	draw_line(craft-Vector2(19,3),craft-Vector2(6,1),Color(0.3,0.8,1,0.6),2,true);draw_colored_polygon(PackedVector2Array([craft+Vector2(8,0),craft+Vector2(-5,-5),craft+Vector2(-5,5)]),Color("b8c8d2"))
	draw_set_transform(Vector2.ZERO)
func draw_station_ellipse(center: Vector2,radius: Vector2,color: Color,filled: bool=true,width: float=1) -> void:
	var points:=PackedVector2Array()
	for i in range(81):points.append(center+Vector2(cos(i*TAU/80)*radius.x,sin(i*TAU/80)*radius.y))
	if filled:draw_colored_polygon(points,color)
	else:draw_polyline(points,color,width,true)
