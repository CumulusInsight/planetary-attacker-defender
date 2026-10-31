extends Control
## Read-only projection of session.internal_for_center; owns no incident registry.
class WarningSign extends Control:
	func _draw() -> void:
		draw_colored_polygon(PackedVector2Array([Vector2(0,22),Vector2(12,0),Vector2(24,22)]),Color("ff5868"))
		draw_line(Vector2(12,7),Vector2(12,14),Color("260b16"),3);draw_circle(Vector2(12,18),1.6,Color("260b16"))
var game: Node
var on_return: Callable
var center_id:="DC-01"
var title_label: Label
var selected_identity:=""
var signature:=""
var incident_list: VBoxContainer
var count_label: Label
var detail: RichTextLabel
var back_button: Button
var defend_button: Button
var background: TextureRect
var station_art: Control
var incident_buttons: Dictionary={}
func text(parent: Node,value: String,font_size: int=18,color: Color=Color("c6dce8")) -> Label:
	var l:=Label.new();l.text=value;l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;l.add_theme_font_size_override("font_size",font_size);l.add_theme_color_override("font_color",color);parent.add_child(l);return l
func box(parent: Node) -> VBoxContainer:
	var p:=PanelContainer.new();var s:=StyleBoxFlat.new();s.bg_color=Color(0.015,0.055,0.08,0.94);s.border_color=Color("246276");s.set_border_width_all(1);s.set_content_margin_all(18);p.add_theme_stylebox_override("panel",s);p.size_flags_horizontal=Control.SIZE_EXPAND_FILL;parent.add_child(p)
	var v:=VBoxContainer.new();v.add_theme_constant_override("separation",12);p.add_child(v);return v
func heading(parent: Node,value: String) -> void:
	text(parent,value,21,Color("62deed"));parent.add_child(HSeparator.new())
func configure(owner_game: Node) -> void:
	game=owner_game;name="OrbitalSecurityConsole";size=get_viewport_rect().size;mouse_filter=Control.MOUSE_FILTER_STOP;z_index=100
	theme=Theme.new();theme.default_font=ThemeDB.fallback_font;theme.default_font_size=18
	background=TextureRect.new();background.texture=preload("res://images/space.jpg");background.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;background.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_COVERED;background.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(background);background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var shade:=ColorRect.new();shade.color=Color(0.005,0.018,0.045,0.83);shade.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(shade);shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var margin:=MarginContainer.new();add_child(margin);margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for edge in ["left","right","top","bottom"]:margin.add_theme_constant_override("margin_"+edge,24)
	var root:=VBoxContainer.new();root.add_theme_constant_override("separation",14);margin.add_child(root)
	var header:=HBoxContainer.new();root.add_child(header);var titles:=VBoxContainer.new();titles.size_flags_horizontal=Control.SIZE_EXPAND_FILL;header.add_child(titles)
	title_label=text(titles,"ORBITAL DATA CENTER 01",30,Color("78e0ef"));text(titles,"SECURITY OPERATIONS CONSOLE",17)
	back_button=Button.new();back_button.text="RETURN TO ORBITAL COMMAND";back_button.custom_minimum_size=Vector2(300,48);header.add_child(back_button);back_button.pressed.connect(dismiss)
	root.add_child(HSeparator.new())
	var body:=HBoxContainer.new();body.size_flags_vertical=Control.SIZE_EXPAND_FILL;body.add_theme_constant_override("separation",18);root.add_child(body)
	var left:=VBoxContainer.new();left.custom_minimum_size.x=360;left.size_flags_horizontal=Control.SIZE_EXPAND_FILL;left.size_flags_stretch_ratio=0.8;body.add_child(left)
	var status:=box(left);heading(status,"CENTER SECURITY STATUS");count_label=text(status,"",24);text(status,"Arrival records identify internal threats. Network compromise is not confirmed.",18)
	var incidents:=box(left);incidents.get_parent().size_flags_vertical=Control.SIZE_EXPAND_FILL;heading(incidents,"ACTIVE SECURITY INCIDENTS")
	var scroll:=ScrollContainer.new();scroll.size_flags_vertical=Control.SIZE_EXPAND_FILL;scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;incidents.add_child(scroll);incident_list=VBoxContainer.new();incident_list.size_flags_horizontal=Control.SIZE_EXPAND_FILL;incident_list.add_theme_constant_override("separation",10);scroll.add_child(incident_list)
	var right:=VBoxContainer.new();right.size_flags_horizontal=Control.SIZE_EXPAND_FILL;right.size_flags_stretch_ratio=1.7;body.add_child(right)
	station_art=preload("res://script/orbital_station_art.gd").new();station_art.custom_minimum_size.y=185;station_art.size_flags_vertical=Control.SIZE_EXPAND_FILL;station_art.mouse_filter=Control.MOUSE_FILTER_IGNORE;right.add_child(station_art)
	text(right,"ORBITAL INFRASTRUCTURE / STATION SCHEMATIC",14,Color("7a9bae")).horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	var details:=box(right);heading(details,"INCIDENT DETAILS");detail=RichTextLabel.new();detail.bbcode_enabled=true;detail.custom_minimum_size.y=235;detail.size_flags_vertical=Control.SIZE_EXPAND_FILL;detail.add_theme_font_size_override("normal_font_size",18);details.add_child(detail)
	var footer:=HBoxContainer.new();footer.add_theme_constant_override("separation",18);root.add_child(footer)
	var investigation:=box(footer);heading(investigation,"SECURITY INVESTIGATION");text(investigation,"Internal threat arrivals are recorded here. SIEM investigation capabilities will be introduced in a later stage.",17)
	var defense:=box(footer);heading(defense,"DEFENSIVE RESPONSE");text(defense,"Containment and resolution are not yet implemented. Arrival records remain persistent.",17);defend_button=Button.new();defend_button.text="DEFEND / RESOLVE - NOT YET AVAILABLE";defend_button.disabled=true;defense.add_child(defend_button)
	hide()
func open_console(center: String="DC-01",return_action: Callable=Callable()) -> void:
	on_return=return_action
	center_id=center;selected_identity="";title_label.text="ORBITAL DATA CENTER "+center.right(2);signature="";refresh_records();show();back_button.grab_focus()
func dismiss() -> void:
	hide()
	if on_return.is_valid():on_return.call()
func _process(_delta: float) -> void:
	if visible:
		size=get_viewport_rect().size
		station_art.custom_minimum_size.y=40 if size.y<800 else 185
		detail.custom_minimum_size.y=120 if size.y<800 else 235
		refresh_records()
func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		dismiss();get_viewport().set_input_as_handled()
	elif visible and (event.is_action_pressed("ui_focus_next") or event.is_action_pressed("ui_focus_prev")):
		var controls: Array=[back_button];controls.append_array(incident_buttons.values())
		var index: int=controls.find(get_viewport().gui_get_focus_owner())
		index=posmod(index+(-1 if event.is_action_pressed("ui_focus_prev") else 1),controls.size())
		controls[index].grab_focus();get_viewport().set_input_as_handled()
func refresh_records() -> void:
	var rows: Array=game.incident_rows(center_id)
	var next_signature:=JSON.stringify(rows)
	if signature==next_signature:return
	signature=next_signature;count_label.text="No internal threats recorded." if rows.is_empty() else "%d unresolved internal threat%s" % [rows.size(),"" if rows.size()==1 else "s"]
	count_label.modulate=Color("b2e4cf") if rows.is_empty() else Color("ff6972")
	for child in incident_list.get_children():incident_list.remove_child(child);child.queue_free()
	incident_buttons.clear()
	if rows.is_empty():text(incident_list,"No arrival records for "+center_id+".");selected_identity="";detail.text="Select an incident to inspect its recorded arrival facts.\n\nNo intrusion or compromise has been inferred.";return
	if not rows.any(func(r):return r.physical_id==selected_identity):selected_identity=rows[0].physical_id
	for row in rows:
		var b:=Button.new();b.text="%s\n%s" % [row.physical_id,row.display_name];b.alignment=HORIZONTAL_ALIGNMENT_LEFT;b.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;b.custom_minimum_size.y=76;b.toggle_mode=true;b.button_pressed=row.physical_id==selected_identity
		for state_name in ["normal","hover","pressed","hover_pressed","focus"]:
			var style:=StyleBoxFlat.new();style.bg_color=Color("193342") if state_name in ["pressed","hover_pressed"] else Color("091d29");style.border_color=Color("ff6972") if state_name in ["pressed","hover_pressed","focus"] else Color("285367");style.set_border_width_all(1);style.content_margin_left=40;style.content_margin_right=8;b.add_theme_stylebox_override(state_name,style)
		b.add_theme_color_override("font_color",Color("ff949b"));incident_list.add_child(b)
		var warning:=WarningSign.new();warning.position=Vector2(8,24);warning.mouse_filter=Control.MOUSE_FILTER_IGNORE;b.add_child(warning)
		incident_buttons[row.physical_id]=b;b.pressed.connect(func():select_incident(row.physical_id))
	render_detail(rows)
func select_incident(identity: String) -> void:
	selected_identity=identity
	for key in incident_buttons:incident_buttons[key].button_pressed=key==identity
	render_detail(game.incident_rows(center_id))
func render_detail(rows: Array) -> void:
	for row in rows:
		if row.physical_id!=selected_identity:continue
		var cause: String="Threat evaded orbital interception." if row.arrival_cause=="EVADED_INTERCEPTION" else "Threat entered without interception."
		var lesson: Dictionary=game.loader.rich_attacks.get(int(row.learning_attack_id),{})
		var confirmation: String="NOT CONFIRMED" if not row.compromise_confirmed else "Confirmed in source record"
		detail.text="[b][color=#ff7a82]%s / %s[/color][/b]\n%s (catalog ID %d)\n\n%s\nSimulation arrival: %.2f s\nInternal state: %s\nCompromise: %s\nMissile outcome: %s\nMission: %s\nCanonical source name: %s\n\n[b]Attack definition[/b]\n%s" % [row.physical_id,row.center_id,row.display_name,int(row.learning_attack_id),cause,float(row.simulation_time),row.state,confirmation,row.source_outcome,row.mission_id,row.catalog_name,lesson.get("definition","No description available in the current catalog.")]
