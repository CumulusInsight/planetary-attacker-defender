extends Control
## Persistent host. Views retain one live instance; training is separately pause-gated.
var watch: Control
var desk: Control
var saved_pause:=false
var leave_dialog: ConfirmationDialog
var overlay: CanvasLayer
var live_game: Node
var mission_sequence:=0
var run_id:=""
var notice: Label
var covered_layers: Dictionary={}
func _ready() -> void:
	process_priority=200;mouse_filter=Control.MOUSE_FILTER_IGNORE # Live orbital clicks pass through the host, not through UI buttons.
	overlay=CanvasLayer.new();overlay.layer=200;add_child(overlay);run_id="RUN-%d" % Time.get_ticks_usec()
	var ui_theme:=Theme.new();ui_theme.default_font_size=20;theme=ui_theme
	for kind in ["normal","hover","pressed","focus"]:
		var style:=StyleBoxFlat.new();style.bg_color=Color("0c2635") if kind=="normal" else Color("193e4b");style.border_color=Color("315461") if kind!="focus" else Color("a1e4e9");style.set_border_width_all(1);style.set_corner_radius_all(4);style.set_content_margin_all(10);ui_theme.set_stylebox(kind,"Button",style)
	desk=Control.new();desk.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);overlay.add_child(desk)
	var bg:=TextureRect.new();bg.texture=preload("res://images/space.jpg");bg.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;bg.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_COVERED;bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);desk.add_child(bg)
	var shade:=ColorRect.new();shade.color=Color(0.01,0.025,0.05,0.88);shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);desk.add_child(shade)
	var center:=CenterContainer.new();center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);desk.add_child(center)
	var col:=VBoxContainer.new();col.custom_minimum_size=Vector2(620,0);col.add_theme_constant_override("separation",22);center.add_child(col)
	for text in ["ORBITAL DEFENSE COMMAND","COMMAND DESK"]:
		var title:=Label.new();title.text=text;title.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;title.add_theme_font_size_override("font_size",30);title.add_theme_color_override("font_color",Color("9edce5"));col.add_child(title)
	var first:=Button.new();first.name="FirstWatch";first.text="The First Watch - DC-01 TRAINING exercise";first.custom_minimum_size.y=64;first.pressed.connect(open_watch);col.add_child(first)
	var live:=Button.new();live.name="OrbitalCommand";live.text="Open / Resume Orbital Command";live.custom_minimum_size.y=64;live.pressed.connect(request_orbital);col.add_child(live)
	var fresh:=Button.new();fresh.text="NEW MISSION";fresh.custom_minimum_size.y=52;fresh.pressed.connect(request_new_mission);col.add_child(fresh)
	notice=Label.new();notice.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;notice.custom_minimum_size.x=620;notice.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;notice.add_theme_font_size_override("font_size",18);col.add_child(notice)
	leave_dialog=ConfirmationDialog.new();leave_dialog.title="Initialize a new mission?";leave_dialog.dialog_text="Replace the current live mission? Its incidents, answers and launches will be discarded.\nFirst Watch training remains separate and will be preserved.";leave_dialog.confirmed.connect(new_mission);add_child(leave_dialog)
	call_deferred("open_orbital") # Command workspace is the landing view; Desk remains in COMMAND.
func training_blocker() -> String:
	return live_game.navigation_context.training_blocker() if is_instance_valid(live_game) else ""
func open_watch() -> void:
	var reason:=training_blocker()
	if not reason.is_empty():
		notice.text=reason
		if is_instance_valid(live_game):live_game.navigation_message(reason)
		return
	if is_instance_valid(live_game):cover_live()
	overlay.show()
	if not is_instance_valid(watch):
		watch=preload("res://scene/prototype14_commanders_experience.tscn").instantiate();overlay.add_child(watch);watch.return_requested.connect(return_to_desk)
	else:
		watch.show();watch.process_mode=Node.PROCESS_MODE_INHERIT;watch.session.paused=saved_pause;watch.pause_button.text="Resume" if saved_pause else "Pause"
	desk.hide()
	if watch.controls.has("start"):watch.controls.start.grab_focus()
	else:watch.controls.checklist.grab_focus()
func suspend_watch() -> void:
	if is_instance_valid(watch) and watch.visible:
		saved_pause=watch.session.paused;watch.session.paused=true;watch.hide();watch.process_mode=Node.PROCESS_MODE_DISABLED
func return_to_desk() -> void:
	suspend_watch()
	if is_instance_valid(live_game):cover_live()
	overlay.show();desk.show();notice.text="First Watch is separate TRAINING. No live mission has been initialized." if not is_instance_valid(live_game) else "Live mission retained. Resume Orbital Command to view it.\nTraining requires a safe, explicitly paused Learning Mode mission."
	if is_instance_valid(watch):desk.find_child("FirstWatch",true,false).text=("Review" if watch.session.finished else "Resume")+" First Watch - TRAINING"
func request_orbital() -> void:open_orbital()
func open_orbital() -> void:
	suspend_watch()
	if not is_instance_valid(live_game):create_live()
	uncover_live();overlay.hide();desk.hide()
func create_live() -> void:
	mission_sequence+=1;live_game=preload("res://scene/prototype13_command.tscn").instantiate();add_child(live_game)
	live_game.navigation_context.configure(live_game,mission_sequence,run_id);live_game.host_requested.connect(host_route)
func host_route(route: String) -> void:
	if route=="training":open_watch()
	elif route=="desk":return_to_desk()
func request_new_mission() -> void:
	if is_instance_valid(live_game):leave_dialog.popup_centered()
	else:new_mission()
func new_mission() -> void:
	suspend_watch()
	if is_instance_valid(live_game):remove_child(live_game);live_game.queue_free();live_game=null;covered_layers.clear()
	create_live();uncover_live();overlay.hide();desk.hide()
func _process(_delta: float) -> void:
	if is_instance_valid(live_game) and live_game.externally_covered:mask_live_layers()
	if not is_instance_valid(notice) or not desk.visible:return
	if is_instance_valid(live_game):
		var warning: String=training_blocker()
		notice.text="%s / %s / simulation %.1fs\n%s" % [live_game.navigation_context.mission_id(),"PAUSED" if live_game.command.strategic_paused else "LIVE MISSION RUNNING",live_game.session.now,warning if not warning.is_empty() else "Training available. The live mission stays explicitly paused until you resume it."]
	else:notice.text="First Watch is a separate TRAINING exercise.\nOpen Orbital Command to initialize the six-center mission."

func cover_live() -> void:
	live_game.externally_covered=true;mask_live_layers()
func mask_live_layers() -> void:
	for layer in live_game.find_children("*","CanvasLayer",true,false):
		if not covered_layers.has(layer):covered_layers[layer]=layer.visible
		layer.hide()
func uncover_live() -> void:
	live_game.externally_covered=false
	for layer in covered_layers:
		if is_instance_valid(layer):layer.visible=covered_layers[layer]
	covered_layers.clear()
