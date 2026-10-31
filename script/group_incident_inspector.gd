extends "res://script/orbital_security_console.gd"
## Shared read-only inspector, using the existing projection and registry only.
var lesson_toggle: CheckButton
var actions: HFlowContainer
var tactical_tools: Button
var training_button: Button
var report_button: Button
var analyze_button: Button
var decide_button: Button
func configure(owner_game: Node) -> void:
	super.configure(owner_game);name="SharedCenterIncidentInspector"
	var subtitle: Label=title_label.get_parent().get_child(1)
	subtitle.text="TACTICAL GROUP COMMANDER / CENTER INCIDENT INSPECTOR"
	lesson_toggle=CheckButton.new();lesson_toggle.text="Expand educational attack definition";detail.get_parent().add_child(lesson_toggle)
	lesson_toggle.toggled.connect(func(_on):render_detail(game.incident_rows(center_id)))
	actions=HFlowContainer.new();actions.add_theme_constant_override("h_separation",10)
	var root_box: Node=back_button.get_parent().get_parent();root_box.add_child(actions)
	analyze_button=action("A - ANALYZE",func():enter_learning("analyze"))
	report_button=action("R - REPORT",func():enter_learning("report"))
	decide_button=action("D - DECIDE / WAIT",func():enter_learning("decide"))
	tactical_tools=action("LEGACY TACTICAL TOOLS",game.open_legacy_tactical)
	training_button=action("FIRST WATCH - TRAINING",func():game.request_host("training"))
	back_button.text="RETURN TO LIVE ORBITAL VIEW";back_button.custom_minimum_size.x=280
func action(caption: String,callback: Callable) -> Button:
	var b:=Button.new();b.text=caption;actions.add_child(b);b.pressed.connect(callback);return b
func enter_learning(key: String) -> void:
	hide();game.learning_context=true;game.show_page(key)
func open_console(center: String="DC-01",return_action: Callable=Callable()) -> void:
	super.open_console(center,return_action)
	tactical_tools.disabled=not game.command.tactical_centers.has(center)
	tactical_tools.tooltip_text="Existing operational actors and command confirmations for "+center if not tactical_tools.disabled else "Not implemented for "+center+". Six-center learning actions A / R / D remain available."
	var subtitle: Label=title_label.get_parent().get_child(1)
	subtitle.text="TACTICAL GROUP COMMANDER / A, R, D available / "+("legacy tactical actors available" if not tactical_tools.disabled else "legacy tactical actors NOT IMPLEMENTED for "+center)
	training_button.tooltip_text=game.navigation_context.training_blocker()
	lesson_toggle.set_pressed_no_signal(false);render_detail(game.incident_rows(center_id))
func dismiss() -> void:
	hide()
	# Return to the exact orbital arrangement; navigation does not reset a view or mission.
	game.learning_context=true;game.update_learning_presentation()
	game.navigation.select(0 if game.orbital_display.centers.size()>1 else game.navigation_context.CENTERS.find(center_id)+1)
	if on_return.is_valid():on_return.call()
func _process(_delta: float) -> void:
	if visible:
		size=Vector2(1600,900)
		station_art.custom_minimum_size.y=90;detail.custom_minimum_size.y=190
		refresh_records()
func render_detail(rows: Array) -> void:
	for row in rows:
		if row.physical_id!=selected_identity:continue
		detail.text="[b][color=#ff7a82]%s[/color][/b]\nRecorded missile outcome: %s / Answer: %s\n%s\nCompromise: %s\n\nCanonical attack: %d / %s\nPhysical target / incident: %s\nCenter: %s / learning question: %s\nArrival cause: %s\nSimulation arrival: %.2f s\nInternal state: %s\nMission: %s\n\n[b]Available evidence[/b]\n%s" % [row.display_name,row.source_outcome,"Correct" if row.answer_correct==true else "Incorrect" if row.answer_correct==false else "Unavailable",row.cause_text,"Confirmed in source record" if row.compromise_confirmed else "NOT CONFIRMED",row.attack_id,row.catalog_name,row.physical_id,row.center_id,row.learning_id,row.arrival_cause,row.simulation_time,row.state,row.mission_id,row.evidence]
		if is_instance_valid(lesson_toggle) and lesson_toggle.button_pressed:detail.text+="\n\n[b]Educational attack definition[/b]\n"+row.definition
