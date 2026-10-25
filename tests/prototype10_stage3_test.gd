extends "res://tests/prototype4_test.gd"
var command: Node
var ui: CanvasLayer
var observed_frames:=0
var legacy_flashes:=0
func settle() -> void:await create_timer(0.24).timeout
func inspect_frame() -> void:
	if not is_instance_valid(command):return
	observed_frames+=1
	for t in command.tactical_centers.values():
		if t.get_node("HUD/AttackInfoPanel").is_visible_in_tree():legacy_flashes+=1
	if command.mission_ui.local_panel.is_visible_in_tree() or command.operations.ui.local_panel.is_visible_in_tree():legacy_flashes+=1
func run() -> void:
	command=load("res://scene/refined_command.tscn").instantiate();game=command;test_viewport.add_child(game)
	pointer_at(Vector2(800,100));await frames()
	ui=command.decision_pages;command.set_strategic_pause(true);await frames()
	RenderingServer.frame_pre_draw.connect(inspect_frame)
	var tactical=command.tactical_centers["DC-01"]
	var official: Dictionary=command.mission.public_snapshot()
	var geometry: Transform2D=tactical.global_transform
	var active_world: Vector2=tactical.active_contact.position
	var active_progress: float=tactical.active_contact.total_orbit_travel
	var actors: Array=tactical.get_node("EnemyContainer").get_children()
	var states: Array=actors.map(func(c):return [c.get_instance_id(),c.position,c.angle] if c.get("angle")!=null else [c.get_instance_id(),c.position])
	check(ui.deadline_table.columns==3,"Deadline list uses actual three-column Tree layout")
	check(ui.deadline_table.get_column_title(0)=="Data Center" and ui.deadline_table.get_column_title(1)=="Potential Threat","Clear aligned headings preserve actual IDs")
	for column in range(3):
		ui.deadline_sort=column;ui.deadline_ascending=true;ui.refresh_deadlines()
		var asc: Array=ui.deadline_rows().map(func(r):return r.contact_id)
		ui.deadline_table.column_title_clicked.emit(column,MOUSE_BUTTON_LEFT)
		check(not ui.deadline_ascending,"Each deadline header reverses direction")
		check(ui.deadline_table.get_column_title(column).ends_with(" v"),"Visible descending direction")
		if column==2:check(asc==[7,1,4],"Deadline ordering numeric, not formatted strings")
		else:check(asc==[1,4,7],"Center/contact ascending uses actual stable identity")
		check(ui.deadline_rows().map(func(r):return r.contact_id)==[4,1,7] if column==2 else ui.deadline_rows().map(func(r):return r.contact_id)==[7,4,1],"Header descending order is actual reversal")
	ui.deadline_sort=2;ui.deadline_ascending=true;ui.refresh_deadlines()
	check(ui.deadline_rows().size()==3,"Background contacts have no fabricated deadline")
	var fixture: Array=[{"contact_id":2,"center_id":"DC-01","remaining":null,"status":"Background traffic"},{"contact_id":1,"center_id":"DC-01","remaining":null,"status":"Deadline expired"},{"contact_id":3,"center_id":"DC-01","remaining":15.0,"status":"Awaiting decision"}]
	check(ui.deadline_rows(fixture).map(func(r):return r.contact_id)==[1,3],"Expired known zero sorts before numeric deadline; missing not fabricated")
	for column in range(3):
		var x: float=ui.deadline_table.get_item_area_rect(ui.deadline_items[1],column).position.x
		for id in [4,7]:check(ui.deadline_table.get_item_area_rect(ui.deadline_items[id],column).position.x==x,"Every deadline row shares real column alignment")
	await capture("p10s3_default")
	var item: TreeItem=ui.deadline_items[4]
	await click_at(ui.deadline_table.get_global_rect().position+ui.deadline_table.get_item_area_rect(item).get_center());await settle()
	check(ui.selected==4 and command.focused_center=="DC-02" and ui.opened.threat,"Click deadline navigates to correct center and persistent public panel")
	check(not command.tactical_centers["DC-02"].encounter.resolved,"Navigation issues no defense")
	ui.close_panel("threat",true);ui.select_contact(1);await settle()
	var contact=actors.filter(func(c):return c.attack_id==10)[0]
	await click_at(test_viewport.canvas_transform*contact.global_position);await settle();await frames(35)
	check(ui.selected==10 and ui.opened.threat,"Orbital click retains selected contact and open Threat beyond half a second")
	check(ui.header_contact.text.contains("C-010"),"Persistent panel displays selected contact")
	check(contact.is_selected,"Visible selected-contact highlight remains")
	await capture("p10s3_selected")
	check(legacy_flashes==0 and observed_frames>30,"No transient legacy panel at any monitored rendered frame")
	ui.command_icon("contacts");await settle()
	print("PIPE SIZE ",ui.contact_table.size," expected ",ui.PIPE_WIDTH-36," horizontal ",ui.contact_table.scroll_horizontal_enabled," minimum ",ui.contact_table.get_combined_minimum_size())
	check(ui.contact_table.size.x==ui.PIPE_WIDTH-36 and not ui.contact_table.scroll_horizontal_enabled,"Seven columns fit without horizontal scrolling")
	var total:=0.0
	for i in range(7):total+=ui.contact_table.get_column_width(i)
	check(total<=ui.contact_table.size.x,"Actual seven-column widths fit table")
	check(ui.table_rows.size()==18,"All eighteen contacts accessible")
	check(ui.contact_table.get_selected().get_metadata(0)==ui.selected,"Contacts table highlight matches persistent orbital selection")
	for state in ["MONITORED","WATCHLIST","INVESTIGATING","ESCALATED","RESOLVED"]:
		check(ui.concise_state(state).length()<=13,"All five operational labels remain distinct and compact")
	var font: Font=ui.contact_table.get_theme_font("font")
	for row in ui.public_rows():
		var r: TreeItem=ui.table_rows[row.contact_id]
		check(r.get_tooltip_text(5)==row.assessment and r.get_tooltip_text(6)==row.operational_status,"Full assessment/state preserved in tooltips")
		for col in range(7):check(font.get_string_size(r.get_text(col),HORIZONTAL_ALIGNMENT_LEFT,-1,16).x<=ui.contact_table.get_column_width(col)-6,"Readable cell fits pipeline: "+r.get_text(col))
	check(ui.concise_state("WATCHLIST")!=ui.concise_state("MONITORED") and ui.concise_state("RESOLVED")!=ui.concise_state("ESCALATED"),"Distinct operational labels")
	check(test_viewport.canvas_transform.origin==Vector2(360,0),"Presentation smoothly shifts orbital display right")
	check(tactical.global_transform==geometry,"Simulation world transform unchanged")
	check(actors.map(func(c):return c.get_instance_id())==states.map(func(s):return s[0]),"No contact nodes recreated")
	await capture("p10s3_contacts")
	var shifted: Vector2=test_viewport.canvas_transform*contact.global_position
	pointer_at(shifted);await frames()
	check(contact.is_hovered,"Hover picking follows presentation shift")
	var stopped: float=contact.elapsed;await frames(5)
	check(contact.elapsed==stopped,"Shifted hover still freezes only selected trajectory")
	pointer_at(Vector2(900,200));await frames()
	check(not contact.is_hovered,"Shifted mouse exit resumes hover state")
	await click_at(test_viewport.canvas_transform*contact.global_position);await settle()
	check(ui.selected==10 and ui.opened.threat and not ui.opened.contacts,"Click picking follows shifted contact and opens persistent information")
	ui.command_icon("contacts");await settle()
	ui.toggle_pin("contacts");ui.show_section("threat")
	await frames(2)
	check(test_viewport.canvas_transform.origin.x>0 and test_viewport.canvas_transform.origin.x<360,"Closing smoothly returns through intermediate presentation positions")
	await settle()
	check(not ui.opened.contacts and ui.pinned!="contacts","Opening another large panel safely closes/unpins wide pipeline")
	check(test_viewport.canvas_transform.origin==Vector2.ZERO,"Closing pipeline restores exact original canvas")
	check(tactical.global_transform==geometry,"Close does not alter simulation transform")
	check(tactical.active_contact.position==active_world and tactical.active_contact.total_orbit_travel==active_progress,"Learning-paused world position/progression unchanged by shift")
	check(test_viewport.canvas_transform.x==Vector2.RIGHT and test_viewport.canvas_transform.y==Vector2.DOWN,"Presentation translation never scales/rotates orbital geometry")
	for column in range(7):
		ui.contact_table.column_title_clicked.emit(column,MOUSE_BUTTON_LEFT)
		check(ui.public_rows().size()==18,"All sorting keys preserve full network")
	ui.show_section("threat");await settle()
	var text: String=""
	for n in ui.section_nodes.threat.get_children():
		if n is Label:text+=n.text+"\n"
	check(text.contains("POSSIBLE CYBERATTACKS") and text.contains("Likelihood based on available intelligence") and not text.contains("HYPOTHESES"),"Accessible threat terminology")
	check(ui.model.view(10).cyber.reduce(func(n,h):return n+(0 if h.likelihood==null else h.likelihood),0)>100,"Independent likelihoods unchanged")
	print("THREAT STATE ",ui.opened," visible ",ui.panels.threat.visible," active ",ui.active_panel)
	check(ui.opened.threat and ui.panels.threat.visible,"Threat remains visible after sorting/navigation")
	await capture("p10s3_threat")
	check(ui.top_buttons.intelligence.text=="E" and ui.intel_tab.text=="Evidence","Evidence naming consistent")
	ui.show_drawer("intelligence");await settle();await capture("p10s3_evidence")
	check(ui.drawer_heading.text=="EVIDENCE" and ui.evidence_records.size()>0,"Full evidence remains accessible")
	ui.show_drawer("history");await settle()
	check(ui.drawer_heading.text=="DECISION TIMELINE","Decision Timeline preserved")
	var remaining: float=tactical.deadline.remaining(tactical.active_contact)
	ui.command_icon("mission");await frames()
	check(command.mission_ui.card_title.text.begins_with("FINAL MISSION SCORECARD") and ui.score_separator.visible,"Scorecard title visibly separated")
	for i in range(5):check(not ui.score_categories[i].bar.visible,"Unassessed points not shown as earned zeroes")
	ui.score_details.pressed.emit();await frames()
	check(command.mission_ui.card_scroll.visible and not ui.score_root.visible,"Full scoring explanations optional and preserved")
	ui.score_details.pressed.emit();command.mission_ui.close_button.pressed.emit();await frames()
	check(not command.scorecard_open,"Consistent upper-right Close returns")
	check(command.mission.public_snapshot()==official and tactical.deadline.remaining(tactical.active_contact)==remaining,"UI operations do not alter score or paused deadline")
	# Resolve official participants through their accepted deterministic command paths to inspect real bars.
	for center in command.tactical_centers:
		var t=command.tactical_centers[center]
		t._on_attacker_selected(t.encounter.active_contact_id);t._on_command_requested("hold_fire")
	ui.command_icon("mission");await frames()
	var actual: Dictionary=command.mission.public_snapshot()
	check(actual.complete,"Final scorecard receives actual complete public mission")
	for i in range(5):
		var c: Dictionary=actual.categories[i];var bar: ProgressBar=ui.score_categories[i].bar
		check(bar.visible==(c.points!=null),"Only actually assessed category gets bar")
		check(bar.max_value==c.maximum,"Graph uses actual configured category maximum")
		if c.points!=null:check(is_equal_approx(bar.value,c.points),"Graph equals actual public points")
	await capture("p10s3_mission")
	command.mission_ui.close_button.pressed.emit();ui.close_panel("drawer",true);ui.close_panel("threat",true)
	check(ui.deadline_empty.visible and ui.deadline_rows().is_empty(),"No active deadline message after actual encounters finish")
	command.set_learning_mode(false);var before: float=command.operations.session.now;await frames(10)
	check(command.operations.session.now>before,"Challenge simulation continues with refined UI")
	check(legacy_flashes==0,"No legacy flash through selection, scorecard, navigation and final outcomes")
	RenderingServer.frame_pre_draw.disconnect(inspect_frame)
	await close_game()
	check(test_viewport.canvas_transform==Transform2D.IDENTITY,"Presentation transform restored on teardown")
	print("PROTOTYPE 10 STAGE 3: ","PASS" if failures==0 else "FAIL"," (",failures," failures; ",checks," checks)")
	quit(0 if failures==0 else 1)
