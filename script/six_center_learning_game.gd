extends "res://script/martian_learning_game.gd"
## Expanded P12 wrapper; no canonical contacts or accepted P11 files are changed.
var learning_contacts: Dictionary={}
var learning_orbits: Dictionary={}
var learning_selected:=-1
var learning_center_select: OptionButton
var overview_button: Button
func learning_rows() -> Array:return learning_contacts.values()
func _ready() -> void:
	process_priority=80;command=$CommandCenter
	for row in command.registry.public_rows():learning_contacts[int(row.contact_id)]={"contact_id":int(row.contact_id),"center_id":row.center_id}
	for center in range(4,7):
		for slot in range(1,7):learning_contacts[center*100+slot]={"contact_id":center*100+slot,"center_id":"DC-%02d" % center}
	for id in learning_contacts:
		var profile: Dictionary={"elapsed":0.0,"clock":0.0,"hovered":false}
		if command.registry.contacts.has(id):
			var actor=actor_for(id)
			if "path" in actor:profile.path=actor.path.duplicate(true);profile.elapsed=actor.elapsed
			else:profile.angle=actor.orbit_angle;profile.progress=actor.orbit_progress;profile.ring=actor.current_ring;profile.speed=actor.move_speed
		else:profile.angle=(id%100)*TAU/6;profile.progress=0.0;profile.ring=(id%100)%3;profile.speed=[0.49,0.63,0.77][(id%100)%3];profile.fixed_ring=true
		learning_orbits[id]=profile
	loader=create_learning_loader()
	error=loader.load_questions(command.decision_pages.model)
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--odc-learning-seed="):session_seed=int(arg.get_slice("=",1))
	if session_seed<0:session_seed=Crypto.new().generate_random_bytes(4).decode_u32(0)
	if error.is_empty():error=loader.generate(session_seed,learning_rows())
	if not error.is_empty():push_error(error)
	session=preload("res://script/monte_carlo_session.gd").new();session.configure(loader)
	var record:=FileAccess.open("user://prototype12_catalog_session.json",FileAccess.WRITE)
	if record!=null:record.store_string(JSON.stringify({"seed":session_seed,"evasion_seed":session.evasion_seed,"catalog_sha256":FileAccess.get_sha256("res://data/cyber_catalog.json"),"eligible":loader.bank_size,"excluded":loader.excluded,"rounds":loader.rounds.map(func(group):return group.map(func(q):return {"learning_id":q.learning_id,"attack_id":q.attack_id,"contact_id":q.contact_id,"center_id":q.center_id,"options":q.options,"learning_deadline_seconds":q.learning_deadline_seconds}))},"  "))
	build();refresh()
func build_learning_presentation() -> void:
	super.build_learning_presentation();orbital_canvas.remove_child(orbital_display);orbital_display.queue_free()
	orbital_display=preload("res://script/six_center_display.gd").new();orbital_canvas.add_child(orbital_display);orbital_display.configure(self)
func build() -> void:
	super.build();martian.get_parent().remove_child(martian);martian.queue_free()
	martian=preload("res://script/monte_carlo_panel.gd").new();martian.configure(self)
	learning_center_select=OptionButton.new();place(shell,learning_center_select,Rect2(20,138,200,34))
	for i in range(1,7):learning_center_select.add_item("Learning DC-%02d" % i)
	learning_center_select.item_selected.connect(func(index):explicit_center="DC-%02d" % [index+1];reset_view())
	overview_button=button(shell,"6 CENTERS",Rect2(232,138,154,34),func():orbital_display.layout_centers(["DC-01","DC-02","DC-03","DC-04","DC-05","DC-06"]);view_mode="multi";refresh())
func analyze() -> void:
	if not error.is_empty():analysis_message.text=error;return
	session.advance(command.operations.session.now)
	if session.analyze(learning_rows()):review_index=-1;build_report();show_page("report")
func next_round() -> void:
	if not session.round_complete() or not session.has_next_round() or animations_active() or not session.pending.is_empty():return
	var times: Dictionary={}
	for q in loader.questions:times[int(q.contact_id)]=deadline_text(int(q.contact_id))
	if not session.advance_round(learning_rows(),times):return
	latest_result.clear();martian.reset_panel();orbital_display.configure(self);view_mode="multi";queued_reset_center="";analyze()
func focus_contact(id: int,explicit: bool=true) -> void:
	if not learning_contacts.has(id):return
	learning_selected=id
	if explicit:
		explicit_center=learning_contacts[id].center_id
		if is_instance_valid(learning_center_select):learning_center_select.select(int(explicit_center.right(2))-1)
	if not session.question(id).is_empty():session.focused=id
	if view_mode=="single" and explicit:reset_view()
func apply_learning_visuals() -> void:pass
func restore_learning_visuals() -> void:pass
func operational_deadline(id: int) -> Dictionary:
	return super.operational_deadline(id) if command.registry.contacts.has(id) else {"applies":false}
func apply_single_view(center: String) -> void:
	view_mode="single";orbital_display.layout_centers([center]);queued_reset_center="";update_learning_presentation()
	if is_instance_valid(learning_center_select):learning_center_select.select(int(center.right(2))-1)
func refresh_learning_deadlines() -> void:
	var ids: Array=loader.questions.map(func(q):return int(q.contact_id))
	ids.sort_custom(func(a,b):
		var av: Variant=learning_contacts[a].center_id if learning_sort==0 else a if learning_sort==1 else deadline_view(a).remaining
		var bv: Variant=learning_contacts[b].center_id if learning_sort==0 else b if learning_sort==1 else deadline_view(b).remaining
		if av==bv:return a<b
		return av<bv if learning_ascending else av>bv)
	if learning_deadline_table.get_meta("ids",[])!=ids:
		learning_deadline_table.clear();learning_deadline_items.clear();var root=learning_deadline_table.create_item()
		for id in ids:var item=learning_deadline_table.create_item(root);item.set_metadata(0,id);learning_deadline_items[id]=item
		learning_deadline_table.set_meta("ids",ids)
	for id in ids:
		var item=learning_deadline_items[id];item.set_text(0,learning_contacts[id].center_id);item.set_text(1,"C-%03d" % id);item.set_text(2,deadline_text(id))
	for i in range(3):learning_deadline_table.set_column_title(i,["Data Center","Learning Contact","Time"][i])
func update_learning_presentation() -> void:
	super.update_learning_presentation()
	if is_instance_valid(learning_center_select):learning_center_select.visible=learning_context and session.analyzed
	if is_instance_valid(overview_button):overview_button.visible=learning_context and session.analyzed;overview_button.disabled=animations_active()
func orbit_offset(id: int) -> Vector2:
	var profile: Dictionary=learning_orbits[id]
	var delta: float=maxf(0,session.now-float(profile.clock));profile.clock=session.now
	if not profile.hovered:
		if profile.has("path"):profile.elapsed+=delta
		else:
			profile.angle=fposmod(profile.angle+delta*profile.speed,TAU);profile.progress+=delta*profile.speed
			while profile.progress>=TAU:
				profile.progress-=TAU
				if not profile.get("fixed_ring",false):profile.ring=maxi(0,profile.ring-1)
	if profile.has("path"):
		var path: Dictionary=profile.path;var angle: float=path.initial_phase+path.direction*path.angular_rate*profile.elapsed
		return Vector2(path.horizontal_radius*cos(angle),path.vertical_radius*sin(angle)).rotated(path.orientation)
	return Vector2.from_angle(profile.angle)*[160,280,400][int(profile.ring)]
func set_learning_hover(id: int,value: bool) -> void:
	orbit_offset(id);learning_orbits[id].hovered=value
func _process(_delta: float) -> void:
	if not is_instance_valid(command):return
	session.advance(command.operations.session.now)
	var shots: Array=session.begin_volley()
	if not shots.is_empty():
		learning_context=true;var centers: Array=[]
		for shot in shots:
			var center: String=learning_contacts[int(shot.contact_id)].center_id
			if center not in centers:centers.append(center)
		if centers.size()>3:centers=["DC-01","DC-02","DC-03","DC-04","DC-05","DC-06"]
		orbital_display.layout_centers(centers);view_mode="multi" if centers.size()>1 else "single";focus_contact(int(shots[0].contact_id),false)
		for shot in shots:launch(shot)
	update_learning_presentation()
	for p in projectiles:
		if is_instance_valid(p):p.step(session.now)
	projectiles=projectiles.filter(func(p):return is_instance_valid(p) and not p.is_queued_for_deletion())
	if projectiles.is_empty() and not queued_reset_center.is_empty() and learning_context:apply_single_view(queued_reset_center)
	refresh()
func launch(shot: Dictionary) -> void:
	learning_context=true
	if not page.is_empty():close_page()
	update_learning_presentation()
	var id: int=shot.contact_id;var center: String=learning_contacts[id].center_id
	shot.visual_scale=orbital_display.ratios[center];shot.visual_bounds=orbital_display.tiles[center].grow(-12)
	var p=preload("res://script/monte_carlo_projectile.gd").new();p.setup(orbital_display.markers[id],orbital_display.origins[center],session.now,shot);orbital_display.add_child(p);projectiles.append(p);p.impacted.connect(impact);martian.add_shot(p)
func show_result_details(id: int) -> void:
	super.show_result_details(id)
	for row in session.public_rows(review_index):
		if row.contact_id==id and row.answered:
			var r: Dictionary=row.result
			hover_explanation.text+="\nEvasion: "+("success" if r.get("evasion_success",false) else "failed" if r.get("evasion_attempted",false) else "not attempted")
			if r.get("evasion_attempted",false):hover_explanation.text+=" / roll %.4f / probability %.0f%%" % [r.evasion_roll,r.evasion_probability*100]

func build_report() -> void:
	super.build_report()
	for options in option_buttons.values():
		for control in options:
			control.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
			control.tooltip_text=control.text

func create_learning_loader() -> RefCounted:
	return preload("res://script/catalog_learning_loader.gd").new()
