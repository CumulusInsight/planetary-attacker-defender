extends Panel
## One generated, looping alarm and one authoritative per-volley incoming-shot view.
var game: Node
var title: Label
var warning: Label
var incoming_label: Label
var count_label: Label
var selector: OptionButton
var shot_list: Label
var evade_button: Button
var mute_button: Button
var close_button: Button
var result_label: Label
var alarm: AudioStreamPlayer
var records: Dictionary={}
var selected_id:=-1
var muted:=false
var flash_on:=true
func configure(owner: Node) -> void:
	game=owner;game.place(game.shell,self,Rect2(1232,184,352,648))
	var border:=StyleBoxFlat.new();border.bg_color=Color("111e2a");border.border_color=Color("d95656");border.set_border_width_all(2);add_theme_stylebox_override("panel",border)
	title=game.label(self,Rect2(12,12,250,26),19);title.text="MARTIAN DEFENSE"
	close_button=game.button(self,"Close",Rect2(272,10,68,30),func():hide())
	incoming_label=game.label(self,Rect2(12,48,328,28),20)
	warning=game.label(self,Rect2(12,82,328,50),19);warning.text="WARNING! WARNING! WARNING!";warning.add_theme_color_override("font_color",Color("ff8c8c"))
	count_label=game.label(self,Rect2(12,138,328,28),17)
	selector=OptionButton.new();game.place(self,selector,Rect2(12,174,328,36));selector.add_theme_font_override("font",ThemeDB.fallback_font);selector.add_theme_font_size_override("font_size",17)
	selector.item_selected.connect(func(index):selected_id=int(selector.get_item_metadata(index));refresh())
	shot_list=game.label(self,Rect2(12,222,328,236),15);shot_list.add_theme_font_override("font",ThemeDB.fallback_font)
	evade_button=game.button(self,"EVADE PROJECTILE",Rect2(12,466,328,42),evade_selected)
	result_label=game.label(self,Rect2(12,520,328,72),17)
	mute_button=game.button(self,"MUTE",Rect2(12,604,328,32),func():muted=not muted;refresh())
	alarm=AudioStreamPlayer.new();alarm.name="MartianAlarm";alarm.volume_db=-13;alarm.stream=make_alarm();add_child(alarm)
	hide()
func make_alarm() -> AudioStreamWAV:
	var wave:=AudioStreamWAV.new();wave.format=AudioStreamWAV.FORMAT_16_BITS;wave.mix_rate=22050;wave.stereo=false
	var frames:=11025;var data:=PackedByteArray();data.resize(frames*2)
	for i in range(frames):
		var t: float=float(i)/22050.0
		var envelope: float=clampf(minf(t/0.015,(0.36-t)/0.015),0,1)
		var frequency: float=660.0 if t<0.18 else 880.0
		data.encode_s16(i*2,int(sin(TAU*frequency*t)*envelope*0.28*32767))
	wave.data=data;wave.loop_mode=AudioStreamWAV.LOOP_FORWARD;wave.loop_begin=0;wave.loop_end=frames
	return wave
func incoming() -> Array:
	var active: Array=[]
	for id in records:
		var p=records[id].get_ref()
		if is_instance_valid(p) and not p.impacted_already and game.session.now<p.fired_at+p.duration:active.append(int(id))
	return active
func add_shot(projectile: Node) -> void:
	if incoming().is_empty():records.clear();selected_id=-1
	records[projectile.contact_id]=weakref(projectile)
	if selected_id<0:selected_id=projectile.contact_id
	show();refresh()
func reset_panel() -> void:
	records.clear();selected_id=-1;alarm.stop();hide()
func evade_selected() -> void:
	if selected_id not in incoming():return
	var p=records[selected_id].get_ref()
	if p.evaded or game.session.now>=p.fired_at+p.duration:return
	if game.session.evade_shot(selected_id,p.generation) and p.evade(game.session.now):
		result_label.text="C-%03d: evasion ordered\nOutcome pending passage." % selected_id
	refresh()
func refresh() -> void:
	if not is_instance_valid(game):return
	var active:=incoming();var ids: Array=records.keys();ids.sort()
	var current_items: Array=[]
	for i in range(selector.item_count):current_items.append(int(selector.get_item_metadata(i)))
	if current_items!=ids:
		selector.clear()
		for id in ids:selector.add_item("%s / C-%03d" % [game.command.registry.contacts[id].center_id,id]);selector.set_item_metadata(selector.item_count-1,id)
	if selected_id in ids:selector.select(ids.find(selected_id))
	count_label.text="Active incoming projectiles: %d" % active.size()
	incoming_label.text="INCOMING PROJECTILE" if not active.is_empty() else "INCOMING FIRE RESOLVED"
	flash_on=fmod(game.session.now,1.0)<0.5
	warning.visible=not active.is_empty();warning.modulate.a=1.0 if flash_on or game.command.strategic_paused else 0.35
	var lines: Array=[]
	for id in ids:
		var result: Dictionary=game.session.results.get(id,{})
		var p=records[id].get_ref()
		var state: String=result.get("projectile_outcome","EVASION ORDERED" if is_instance_valid(p) and p.evaded else "APPROACHING")
		lines.append("%s / C-%03d - %s" % [game.command.registry.contacts[id].center_id,id,state])
		if not result.is_empty():lines.append(("  Correct: " if result.answer_correct else "  Incorrect; use ")+result.correct_name)
	shot_list.text="\n".join(lines)
	var selected=records.get(selected_id)
	var projectile=selected.get_ref() if selected!=null else null
	evade_button.disabled=selected_id not in active or not is_instance_valid(projectile) or projectile.evaded
	var result: Dictionary=game.session.results.get(selected_id,{})
	if not result.is_empty():result_label.text="C-%03d: %s\nCybersecurity answer: %s" % [selected_id,result.projectile_outcome,"CORRECT" if result.answer_correct else "INCORRECT"]+(("\nCorrect: "+result.correct_name) if not result.hit else "")
	elif is_instance_valid(projectile) and not projectile.evaded:result_label.text="Select one incoming shot to evade.\nOther shots remain independent."
	close_button.disabled=not active.is_empty()
	mute_button.text="UNMUTE" if muted else "MUTE"
	if active.is_empty() or muted:alarm.stop()
	else:
		if not alarm.playing:alarm.play()
		alarm.stream_paused=game.command.strategic_paused or not game.learning_context
