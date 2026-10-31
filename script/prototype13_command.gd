extends "res://script/retrofit_learning_game.gd"
var security_console: Control
var security_entry: Button
signal host_requested(route: String)
var navigation_context: RefCounted
var navigation: OptionButton
var tactical_console: Control
var navigation_notice: Label
var externally_covered:=false
var group_ui: Control
const IncidentProjection=preload("res://script/live_incident_projection.gd")
func _ready() -> void:
	super._ready()
	security_console=preload("res://script/group_incident_inspector.gd").new();shell.add_child(security_console);security_console.configure(self)
	security_entry=Button.new();security_entry.text="SECURITY CONSOLE";security_entry.tooltip_text="Open Orbital Data Center 01 Security Console";security_entry.add_theme_font_override("font",ThemeDB.fallback_font);security_entry.add_theme_font_size_override("font_size",13);shell.add_child(security_entry);security_entry.pressed.connect(func():open_security("DC-01"))
	build_navigation()
	group_ui=preload("res://script/tactical_group_ui.gd").new();shell.add_child(group_ui);group_ui.configure(self)
	open_orbital_view()
func _process(delta: float) -> void:
	super._process(delta)
	if not is_instance_valid(security_entry):return
	command.decision_pages.role_select.hide()
	command.decision_pages.center_control.hide()
	learning_center_select.hide()
	overview_button.hide()
	security_entry.visible=false # Tile inspector links now include all six centers.
	if security_entry.visible:
		var tile: Rect2=orbital_display.tiles["DC-01"];security_entry.position=tile.position+Vector2(tile.size.x-157,3);security_entry.size=Vector2(150,26)
func mode_modal_open() -> bool:
	return externally_covered or (is_instance_valid(tactical_console) and tactical_console.visible) or (is_instance_valid(security_console) and security_console.visible) or (is_instance_valid(group_ui) and is_instance_valid(group_ui.personnel_panel) and group_ui.personnel_panel.visible) or super.mode_modal_open()
func player_fire_at(point: Vector2) -> bool:
	if externally_covered or (is_instance_valid(tactical_console) and tactical_console.visible) or (is_instance_valid(security_console) and security_console.visible):return false
	return super.player_fire_at(group_ui.orbital_coordinates(point) if is_instance_valid(group_ui) else point)

func build_navigation() -> void:
	navigation_context=preload("res://script/orbital_command_context.gd").new();navigation_context.configure(self)
	var legacy=command.decision_pages.role_select
	navigation=preload("res://script/command_navigation.gd").new();legacy.get_parent().add_child(navigation);navigation.position=legacy.position;navigation.size=legacy.size;navigation.configure(self);legacy.hide()
	command.decision_pages.center_control.item_selected.connect(func(index):remember_center(command.decision_pages.center_control.get_item_text(index)))
	learning_center_select.item_selected.connect(func(index):remember_center("DC-%02d" % [index+1]))
	command.decision_pages.contact_table.item_selected.connect(func():
		if not command.focused_center.is_empty():remember_center(command.focused_center))
	tactical_console=security_console # One shared instance; no second incident presentation.
	navigation_notice=Label.new();navigation_notice.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;navigation_notice.add_theme_font_override("font",ThemeDB.fallback_font);navigation_notice.add_theme_font_size_override("font_size",18);navigation_notice.modulate=Color("ffc89e");place(shell,navigation_notice,Rect2(24,820,1540,72));navigation_notice.z_index=150;navigation_notice.mouse_filter=Control.MOUSE_FILTER_IGNORE
func incident_rows(center: String) -> Array:
	return IncidentProjection.rows(self,center,navigation_context.mission_id())
func navigation_message(message: String) -> void:
	navigation_notice.text=message
func open_tactical(center: String) -> void:
	if not navigation_context.select_center(center):return
	close_page();command.decision_pages.close_panel("contacts",true);command.decision_pages.close_panel("threat",true);command.decision_pages.close_panel("drawer",true)
	tactical_console.open_console(center);navigation.select(navigation_context.CENTERS.find(center)+1);navigation_notice.text=""
func open_security(center: String="DC-01") -> void:
	open_tactical(center)
func select_group_center(center: String) -> void:
	if not navigation_context.select_center(center):return
	tactical_console.hide();close_page();close_legacy_panels();learning_context=true;explicit_center=center
	navigation.select(navigation_context.CENTERS.find(center)+1)
	group_ui.context_mode="assessment";group_ui.request_layout([center]);update_learning_presentation()
func open_orbital_view() -> void:
	tactical_console.hide();security_console.hide();close_legacy_panels();navigation.select(0);navigation_notice.text="";learning_context=true
	if is_instance_valid(group_ui):group_ui.context_mode="overview";group_ui.request_layout(navigation_context.CENTERS.duplicate())
	update_learning_presentation()
func open_fleet_view() -> void:
	tactical_console.hide();security_console.hide();leave_learning();command.command_level="operations";command.decision_pages.open_panel("contacts");navigation.select(0)
	navigation_message("Legacy Operations Commander / DC-01 through DC-03 operational records. Six-center learning authority remains with the Tactical Group Commander; R opens the learning Report.")
func _input(event: InputEvent) -> void:
	if externally_covered:return
	if is_instance_valid(tactical_console) and tactical_console.visible and event.is_action_pressed("ui_cancel"):
		open_orbital_view();get_viewport().set_input_as_handled()

func request_host(route: String) -> void:
	if host_requested.get_connections().is_empty():navigation_message("Use Launch_Orbital_Defense_Command.bat for Command Desk and resumable training navigation.")
	else:host_requested.emit(route)

func remember_center(center: String) -> void:
	if is_instance_valid(navigation_context) and navigation_context.select_center(center) and is_instance_valid(navigation):navigation.select(navigation_context.CENTERS.find(center)+1)
func focus_contact(id: int,explicit: bool=true) -> void:
	super.focus_contact(id,explicit)
	if explicit and learning_contacts.has(id):remember_center(learning_contacts[id].center_id)

func open_legacy_tactical() -> void:
	if not command.tactical_centers.has(navigation_context.selected_center):
		navigation_message(navigation_context.selected_center+": legacy tactical actors are not implemented. Use A / R / D for this center's learning mission.");return
	tactical_console.hide();security_console.hide();leave_learning()
	var actor=command.tactical_centers[navigation_context.selected_center]
	var id: int=actor.selected_attack_id if actor.selected_attack_id>=0 else actor.encounter.active_contact_id
	command.decision_pages.select_contact(id);command.decision_pages.show_section("threat")
	navigation_message("Legacy tactical tools: existing operational intelligence, evidence, history and confirmation rules. Learning arrivals remain separate records in the shared inspector.")

func update_learning_presentation() -> void:
	super.update_learning_presentation()
	if is_instance_valid(learning_center_select):learning_center_select.hide()
	if is_instance_valid(overview_button):overview_button.hide()
	if learning_context and not session.analyzed:
		orbital_canvas.show();orbital_display.sync(true)
		for actor in command.tactical_centers.values():actor.hide()
		command.decision_pages.deadline_table.hide();world_hidden=true

func close_legacy_panels() -> void:
	for panel in ["contacts","threat","drawer"]:command.decision_pages.close_panel(panel,true)

func reset_view() -> void:
	# A later explicit reset supersedes an earlier deferred navigation request.
	if is_instance_valid(group_ui):group_ui.requested_layout.clear()
	super.reset_view()

func build_learning_presentation() -> void:
	super.build_learning_presentation()
	orbital_canvas.remove_child(orbital_display);orbital_display.queue_free()
	orbital_display=preload("res://script/command_orbital_display.gd").new();orbital_canvas.add_child(orbital_display);orbital_display.configure(self)
