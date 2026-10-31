extends Control
## Center-specific read-only arrival view. No evaluator, defense or resolution commands.
var game: Node
var center_id:="DC-01"
var title: Label
var status: Label
var facts: RichTextLabel
var incidents: VBoxContainer
var selected_identity:=""
var signature:=""
var security_button: Button
var return_button: Button
var training_button: Button
var tactical_tools: Button
func configure(owner_game: Node) -> void:
	game=owner_game;name="LiveTacticalCommand";z_index=90;theme=Theme.new();theme.default_font=ThemeDB.fallback_font;theme.default_font_size=19
	for state_name in ["normal","hover","pressed","focus"]:
		var style:=StyleBoxFlat.new();style.bg_color=Color("102937") if state_name=="normal" else Color("204450");style.border_color=Color("378596");style.set_border_width_all(1);style.set_content_margin_all(12);style.set_corner_radius_all(4);theme.set_stylebox(state_name,"Button",style)
	var bg:=ColorRect.new();bg.color=Color("05121e");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
	var margins:=MarginContainer.new();margins.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(margins)
	for edge in ["left","right","top","bottom"]:margins.add_theme_constant_override("margin_"+edge,28)
	var col:=VBoxContainer.new();col.add_theme_constant_override("separation",16);margins.add_child(col)
	var header:=HBoxContainer.new();col.add_child(header);title=Label.new();title.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;title.size_flags_horizontal=Control.SIZE_EXPAND_FILL;title.add_theme_font_size_override("font_size",28);title.modulate=Color("8ee0e8");header.add_child(title)
	return_button=Button.new();return_button.text="RETURN TO ORBITAL COMMAND";header.add_child(return_button);return_button.pressed.connect(game.open_orbital_view)
	col.add_child(HSeparator.new());status=Label.new();status.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;col.add_child(status)
	var split:=HBoxContainer.new();split.size_flags_vertical=Control.SIZE_EXPAND_FILL;split.add_theme_constant_override("separation",24);col.add_child(split)
	var scroll:=ScrollContainer.new();scroll.custom_minimum_size.x=360;scroll.size_flags_horizontal=Control.SIZE_EXPAND_FILL;scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;split.add_child(scroll);incidents=VBoxContainer.new();incidents.size_flags_horizontal=Control.SIZE_EXPAND_FILL;incidents.add_theme_constant_override("separation",12);scroll.add_child(incidents)
	facts=RichTextLabel.new();facts.bbcode_enabled=true;facts.size_flags_horizontal=Control.SIZE_EXPAND_FILL;facts.size_flags_stretch_ratio=1.7;facts.add_theme_font_size_override("normal_font_size",20);split.add_child(facts)
	col.add_child(HSeparator.new());var note:=Label.new();note.text="Arrival is not proof of compromise. Investigation and containment are not yet implemented.
First Watch is separate training; its checklist does not verify this live incident.";note.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;col.add_child(note)
	var buttons:=HBoxContainer.new();buttons.add_theme_constant_override("separation",20);col.add_child(buttons)
	security_button=Button.new();security_button.text="OPEN SECURITY CONSOLE";buttons.add_child(security_button);security_button.pressed.connect(func():game.open_security(center_id))
	training_button=Button.new();training_button.text="FIRST WATCH - TRAINING";buttons.add_child(training_button);training_button.pressed.connect(func():game.request_host("training"))
	tactical_tools=Button.new();tactical_tools.text="TACTICAL OFFICER TOOLS";tactical_tools.tooltip_text="Existing DC-01 operational intelligence and confirmed command paths; separate from the learning-arrival record.";buttons.add_child(tactical_tools);tactical_tools.pressed.connect(game.open_legacy_tactical)
	hide()
func open_center(center: String) -> void:
	center_id=center;selected_identity="";signature="";show();refresh();return_button.grab_focus()
func _process(_delta: float) -> void:
	if visible:size=get_viewport_rect().size;refresh()
func refresh() -> void:
	var rows: Array=game.incident_rows(center_id);var sig:=JSON.stringify([game.navigation_context.mission_id(),rows])
	title.text=center_id+" / ORBITAL TACTICAL COMMAND" if center_id=="DC-01" else center_id+" / TACTICAL STATUS - OBSERVER ONLY"
	status.text="%s | %d unresolved internal arrival(s)
%s" % [game.navigation_context.mission_id(),rows.size(),"Lieutenant / your assigned orbital data center" if center_id=="DC-01" else "Competing installation: observation only; no command authority granted."]
	training_button.tooltip_text=game.navigation_context.training_blocker()
	tactical_tools.disabled=center_id!="DC-01"
	if sig==signature:return
	signature=sig
	for child in incidents.get_children():incidents.remove_child(child);child.queue_free()
	if not rows.any(func(r):return r.physical_id==selected_identity):selected_identity="" if rows.is_empty() else rows[0].physical_id
	if rows.is_empty():facts.text="[b]No internal arrivals recorded for "+center_id+".[/b]

Unanswered, queued and airborne threats are not internal arrivals. A confirmed HIT creates no arrival.

No unauthorized session or network compromise has been inferred."
	for row in rows:
		var b:=Button.new();b.text=row.display_name+"
"+row.physical_id+" / "+row.source_outcome;b.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;b.custom_minimum_size.y=90;b.add_theme_color_override("font_color",Color("ff929c"));incidents.add_child(b);b.pressed.connect(func():selected_identity=row.physical_id;signature="";refresh())
		if row.physical_id==selected_identity:
			facts.text="[b][color=#ff929c]%s[/color][/b]

Incident: %s
Mission: %s
Target: %s
Question: %s
Canonical ID: %d / %s

%s
Missile outcome: %s
Answer: %s
Simulation arrival: %.2f seconds
Internal state: %s
Compromise: %s

[b]Recorded evidence[/b]
%s

[b]Educational attack definition[/b]
%s

Next: inspect the same arrival in Security Console. No live remediation is available yet." % [row.display_name,row.physical_id,row.mission_id,row.center_id,row.learning_id,row.attack_id,row.catalog_name,row.cause_text,row.source_outcome,"Correct" if row.answer_correct==true else "Incorrect" if row.answer_correct==false else "Unavailable",row.simulation_time,row.state,"Confirmed in source record" if row.compromise_confirmed else "NOT CONFIRMED",row.evidence,row.definition]
