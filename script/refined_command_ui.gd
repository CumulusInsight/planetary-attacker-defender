extends "res://script/visual_command_ui.gd"
## Stage 3 presentation only. Source simulations and accepted Stage 2 remain unchanged.
const PIPE_WIDTH=704.0
const PIPE_COLUMNS=[70,58,70,90,94,108,112]
var refined_ready:=false
var deadline_table: Tree
var deadline_empty: Label
var deadline_items:={}
var deadline_sort:=2
var deadline_ascending:=true
var deadline_building:=false
var orbit_tween: Tween
var orbit_target:=Vector2.ZERO
var saved_canvas:=Transform2D.IDENTITY
var score_root: Control
var score_categories:={}
var score_summary: Label
var score_objectives: Label
var score_details: Button
var score_separator: HSeparator
var detail_scoring:=false
var legacy_guards: Array=[]
func _ready() -> void:
	super._ready()
	saved_canvas=get_viewport().canvas_transform
	build_refinements()
	refined_ready=true
	for tactical in command.tactical_centers.values():
		guard_legacy(tactical.get_node("HUD"))
		guard_legacy(tactical.action_feedback)
	guard_legacy(command.mission_ui.local_panel)
	guard_legacy(command.mission_ui.network_label)
	guard_legacy(command.operations.ui.local_panel)
	for tactical in command.tactical_centers.values():
		for actor in tactical.get_node("EnemyContainer").get_children():
			actor.attacker_selected.connect(func(id):select_contact(id);show_section("threat");clean_legacy())
	clean_legacy()
	refresh_status();refresh_contacts();refresh_scorecard()
func guard_legacy(node: Node) -> void:
	# Hide stable presentation roots rather than fighting show() reentrantly in visibility_changed.
	legacy_guards.append(node)
	if node is CanvasLayer:
		for child in node.get_children():
			if child is CanvasItem:child.hide()
		node.hide()
	else:
		var holder:=Control.new();holder.mouse_filter=Control.MOUSE_FILTER_IGNORE
		node.get_parent().add_child(holder);node.reparent(holder);holder.hide()
func evidence_label(text: String) -> String:
	var label:=super.evidence_label(text)
	return "Initial estimate" if label=="Initial hypothesis" else label
func build_refinements() -> void:
	top_buttons.intelligence.text="E";top_buttons.intelligence.tooltip_text="Evidence / intelligence reports and source history"
	intel_tab.text="Evidence"
	for node in section_nodes.threat.get_children():
		if node is Label and node.text.begins_with("HYPOTHESES"):
			node.text="POSSIBLE CYBERATTACKS";node.position.y=67
	make_label(section_nodes.threat,Rect2(0,88,604,22),14).text="Likelihood based on available intelligence"
	for i in range(3):hypothesis_cards[i].get_parent().position.y=115+i*75
	recommendation_short.position.y=345
	status_strip.hide()
	deadline_table=Tree.new();deadline_table.columns=3;deadline_table.hide_root=true
	deadline_table.column_titles_visible=true;deadline_table.select_mode=Tree.SELECT_ROW;deadline_table.allow_reselect=true
	deadline_table.add_theme_font_size_override("font_size",16)
	deadline_table.add_theme_font_override("font",ThemeDB.fallback_font)
	deadline_table.add_theme_font_override("title_button_font",ThemeDB.fallback_font)
	deadline_table.add_theme_font_size_override("title_button_font_size",15)
	deadline_table.add_theme_constant_override("v_separation",3)
	command.cyber.place(shell,deadline_table,Rect2(1168,52,416,124))
	deadline_empty=make_label(deadline_table,Rect2(12,40,390,40),16)
	deadline_empty.text="No active decision deadlines"
	for i in range(3):
		deadline_table.set_column_expand(i,false);deadline_table.set_column_custom_minimum_width(i,[120,154,112][i])
	deadline_table.column_title_clicked.connect(func(column,_button=1):
		if column==deadline_sort:deadline_ascending=not deadline_ascending
		else:deadline_sort=column;deadline_ascending=true
		refresh_deadlines())
	deadline_table.item_selected.connect(func():
		if not deadline_building and deadline_table.get_selected()!=null:
			select_contact(int(deadline_table.get_selected().get_metadata(0)));show_section("threat"))
	contact_table.size=Vector2(PIPE_WIDTH-36,460)
	contact_table.custom_minimum_size=Vector2.ZERO
	contact_table.scroll_horizontal_enabled=false
	contact_table.add_theme_font_size_override("font_size",16)
	contact_table.add_theme_font_override("font",ThemeDB.fallback_font)
	contact_table.add_theme_font_override("title_button_font",ThemeDB.fallback_font)
	contact_table.add_theme_font_size_override("title_button_font_size",14)
	for i in range(7):contact_table.set_column_custom_minimum_width(i,PIPE_COLUMNS[i])
	contact_summary.position.y=632;contact_summary.size=Vector2(PIPE_WIDTH-36,36)
	for node in panels.contacts.get_children():
		if node is Button and node.text=="Open selected Threat Assessment":node.size.x=PIPE_WIDTH-36
		if node is Label and node.position.y==104:
			node.text="Operational pipeline / click headers to sort\nFull values in tooltips. Display filters only.";node.size.x=PIPE_WIDTH-36
	concern_filter.size.x=PIPE_WIDTH-328
	build_scorecard()
func build_scorecard() -> void:
	var card=command.mission_ui.card
	for child in card.get_children():
		if child is Label and child!=command.mission_ui.card_title:child.hide()
	score_separator=HSeparator.new();command.cyber.place(card,score_separator,Rect2(24,62,1272,4))
	score_root=Control.new();score_root.mouse_filter=Control.MOUSE_FILTER_IGNORE
	command.cyber.place(card,score_root,Rect2(24,82,1272,610))
	score_summary=make_label(score_root,Rect2(0,0,1272,50),21)
	for i in range(5):
		var row:=Control.new();command.cyber.place(score_root,row,Rect2(0,62+i*68,1272,64))
		var label:=make_label(row,Rect2(0,0,360,30),19)
		var value:=make_label(row,Rect2(880,0,392,30),18)
		var bar:=ProgressBar.new();bar.step=0.0;bar.show_percentage=false;bar.mouse_filter=Control.MOUSE_FILTER_IGNORE
		command.cyber.place(row,bar,Rect2(378,7,470,16))
		var state:=make_label(row,Rect2(378,29,894,24),16)
		score_categories[i]={"label":label,"value":value,"bar":bar,"status":state}
	score_objectives=make_label(score_root,Rect2(0,415,1272,190),17)
	score_details=make_button(card,"Scoring details / outcomes",Rect2(24,712,340,40),func():detail_scoring=not detail_scoring;refresh_scorecard())
func refresh_scorecard() -> void:
	var view: Dictionary=command.mission.public_snapshot()
	if view.is_empty():return
	command.mission_ui.card_title.text="FINAL MISSION SCORECARD"+(" / IN PROGRESS" if not view.complete else "")
	command.mission_ui.card_scroll.visible=detail_scoring
	score_root.visible=not detail_scoring
	score_details.text="< Back to summary" if detail_scoring else "Scoring details / outcomes"
	score_summary.text=("Confirmed: unassessed" if view.confirmed_points==null else "Confirmed: %.1f / %.0f" % [view.confirmed_points,view.maximum])+"   /   %d of %d resolved   /   %d timely   /   %d expired" % [view.resolved,view.participants,view.timely,view.expired]
	for i in range(view.categories.size()):
		var c: Dictionary=view.categories[i];var target: Dictionary=score_categories[i]
		target.label.text=c.label;target.value.text="Unassessed / %.0f maximum" % c.maximum if c.points==null else "%.1f / %.0f maximum" % [c.points,c.maximum]
		target.bar.max_value=c.maximum;target.bar.visible=c.points!=null
		if c.points!=null:target.bar.value=c.points
		target.status.text=c.status+(" / %.1f assessed capacity" % c.assessed_maximum if c.points!=null else " / no earned points asserted")
		target.label.tooltip_text=c.reason;target.value.tooltip_text=c.reason
	var goals: Array=[]
	for objective in view.objectives:goals.append(objective.short_text+" — "+objective.status)
	score_objectives.text="MISSION OBJECTIVES\n"+"\n".join(goals)
func deadline_rows(source: Array=[]) -> Array:
	var rows: Array=command.strategic_table_rows() if source.is_empty() else source.duplicate(true)
	rows=rows.filter(func(r):return r.remaining!=null or r.status=="Deadline expired")
	# Expiry is a known zero, not a missing deadline. Unknowns never receive a fabricated clock.
	rows.sort_custom(func(a,b):
		var av: Variant=a.center_id if deadline_sort==0 else a.contact_id if deadline_sort==1 else (0.0 if a.status=="Deadline expired" else a.remaining)
		var bv: Variant=b.center_id if deadline_sort==0 else b.contact_id if deadline_sort==1 else (0.0 if b.status=="Deadline expired" else b.remaining)
		if (av==null)!=(bv==null):return av!=null
		if av==bv:return a.contact_id<b.contact_id
		return av<bv if deadline_ascending else av>bv)
	return rows
func refresh_deadlines() -> void:
	deadline_building=true
	var rows:=deadline_rows();deadline_empty.visible=rows.is_empty();var ids: Array=rows.map(func(r):return r.contact_id)
	if ids!=deadline_table.get_meta("ids",[]):
		deadline_table.clear();deadline_items.clear();var root:=deadline_table.create_item()
		for r in rows:
			var item:=deadline_table.create_item(root);item.set_metadata(0,r.contact_id);deadline_items[r.contact_id]=item
		deadline_table.set_meta("ids",ids)
	for r in rows:
		var item: TreeItem=deadline_items[r.contact_id]
		item.set_text(0,r.center_id);item.set_text(1,"C-%03d" % r.contact_id)
		item.set_text(2,"EXPIRED" if r.status=="Deadline expired" else command.registry.time_text(r.remaining))
		item.set_tooltip_text(1,"Potential threat is a surveillance label, not confirmed hostility. Select to review public assessment.")
		item.set_custom_bg_color(0,Color("30475b") if r.contact_id==selected else Color.TRANSPARENT)
		if r.contact_id!=selected:item.deselect(0)
		elif not item.is_selected(0):item.select(0)
	for i in range(3):deadline_table.set_column_title(i,["Data Center","Potential Threat","Time"][i]+(" ^" if deadline_ascending else " v") if deadline_sort==i else ["Data Center","Potential Threat","Time"][i])
	deadline_building=false
func refresh_status() -> void:
	super.refresh_status()
	if refined_ready:
		status_strip.hide();refresh_deadlines()
		deadline_table.position.x=16 if opened.threat else 1168
static func concise_assessment(text: String) -> String:
	return {"Suspected hostile":"Suspected", "Assessed nonhostile":"Nonhostile", "Uncertain":"Uncertain","Assessment revised":"Revised", "Unknown; no investigation assigned":"Unknown", "Officer suspects hostile intent. Origin and identity are unresolved.":"Suspected", "Officer reports complete certainty that this contact is hostile.":"Suspected", "Officer suspects a threat, but a research transit is also possible.":"Uncertain"}.get(text,text)
static func concise_state(text: String) -> String:
	return {"MONITORED":"Monitored","WATCHLIST":"Watchlist","INVESTIGATING":"Investigating","ESCALATED":"Escalated","RESOLVED":"Resolved","Background traffic":"Background","No active encounter":"Background","Decision recorded":"Decided","Deadline expired":"Expired","Awaiting decision":"Pending","Unidentified contact":"Unknown", "Assessment pending":"Pending", "No encounter assigned":"Background", "Follow-up received":"Follow-up"}.get(text,text)
func refresh_contacts() -> void:
	super.refresh_contacts()
	if not refined_ready:return
	_table_building=true
	for row in public_rows():
		var item: TreeItem=table_rows[row.contact_id]
		var full: Array=["C-%03d" % row.contact_id,row.center_id,command.registry.SEVERITY[row.severity],"Unknown" if row.confidence==null else str(row.confidence)+"%",command.registry.time_text(row.remaining),row.assessment,row.operational_status]
		item.set_text(2,"Unrated" if row.severity==0 else "Medium" if row.severity==2 else full[2])
		item.set_text(4,"—" if row.remaining==null else full[4])
		item.set_text(5,concise_assessment(row.assessment));item.set_text(6,concise_state(row.operational_status))
		for i in range(7):item.set_tooltip_text(i,full[i])
		if row.contact_id==selected and not item.is_selected(0):item.select(0)
		elif row.contact_id!=selected:item.deselect(0)
	_table_building=false
	contact_summary.text="C-%03d / %s selected    |    %d of 18 contacts" % [selected,command.registry.contacts[selected].center_id,public_rows().size()]
func select_contact(id: int) -> void:
	super.select_contact(id)
	if refined_ready:clean_legacy()
func _process(delta: float) -> void:
	var previous:=selected
	super._process(delta)
	if not refined_ready:return
	if previous!=selected:show_section("threat")
	clean_legacy();refresh_scorecard()
func open_panel(key: String) -> void:
	if refined_ready:
		# The wider pipeline is exclusive: close/unpin it when opening any other large panel.
		if key!="contacts" and opened.contacts:
			opened.contacts=false
			if pinned=="contacts":pinned=""
		elif key=="contacts":
			for other in ["threat","drawer"]:opened[other]=false
			if pinned in ["threat","drawer"]:pinned=""
	super.open_panel(key)
func toggle_pin(key: String) -> void:
	super.toggle_pin(key)
	pin_buttons.contacts.tooltip_text="Wide pipeline is exclusive; opening another large panel closes and unpins it."
func target_rect(key: String) -> Rect2:
	if refined_ready and key=="contacts":return Rect2(16,112,PIPE_WIDTH,724)
	return super.target_rect(key)
func layout_panels() -> void:
	super.layout_panels()
	if not refined_ready:return
	var target:=Vector2(360,0) if opened.contacts else Vector2.ZERO
	if target!=orbit_target:
		orbit_target=target
		if orbit_tween!=null and orbit_tween.is_valid():orbit_tween.kill()
		orbit_tween=create_tween();orbit_tween.tween_method(apply_orbit_offset,get_viewport().canvas_transform.origin-saved_canvas.origin,target,0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
func apply_orbit_offset(offset: Vector2) -> void:
	var projection:=saved_canvas;projection.origin+=offset;get_viewport().canvas_transform=projection
func _exit_tree() -> void:
	if refined_ready and is_instance_valid(get_viewport()):get_viewport().canvas_transform=saved_canvas
