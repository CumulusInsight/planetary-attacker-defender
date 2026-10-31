extends Control
## Isolated P14 command exercise; hosted navigation never touches P12 incident state.
signal return_requested
const Checklist=preload("res://script/p14/watch_checklist.gd")
const Session=preload("res://script/p14/command_session.gd")
var session: RefCounted
var content: Control
var station: Control
var context: PanelContainer
var context_title: Label
var body: VBoxContainer
var scroll: ScrollContainer
var objective_label: Label
var message_label: Label
var time_label: Label
var incident_button: Button
var debrief_button: Button
var pause_button: Button
var job_label: Label
var crew_buttons: Dictionary={}
var controls: Dictionary={}
var panel_mode:="welcome"
var revision:=-1
var previous_mode:="identity"
var earth_material: ShaderMaterial
func _ready() -> void:
	session=Session.new();session.configure()
	content=Control.new();content.size=Vector2(1600,900);add_child(content)
	var theme_value:=Theme.new();theme_value.default_font=ThemeDB.fallback_font;theme_value.default_font_size=20;content.theme=theme_value
	for kind in ["normal","hover","pressed","disabled","focus"]:
		var style:=StyleBoxFlat.new();style.bg_color=Color("0c2635") if kind=="normal" else Color("193e4b");style.border_color=Color("315461") if kind!="focus" else Color("a1e4e9");style.set_border_width_all(1);style.set_corner_radius_all(4);style.set_content_margin_all(9);theme_value.set_stylebox(kind,"Button",style)
	theme_value.set_color("font_disabled_color","Button",Color("78939f"))
	var bg:=TextureRect.new();bg.texture=preload("res://images/space.jpg");bg.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;bg.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_COVERED;bg.mouse_filter=Control.MOUSE_FILTER_IGNORE;place(content,bg,Rect2(0,0,1600,900))
	var shade:=ColorRect.new();shade.color=Color(0.012,0.025,0.055,0.88);shade.mouse_filter=Control.MOUSE_FILTER_IGNORE;place(content,shade,Rect2(0,0,1600,900))
	var earth:=ColorRect.new();earth.mouse_filter=Control.MOUSE_FILTER_IGNORE;earth_material=ShaderMaterial.new();earth_material.shader=preload("res://script/p14/earth_limb.gdshader");earth.material=earth_material;place(content,earth,Rect2(0,0,1600,900))
	station=preload("res://script/p14/station_view.gd").new();station.session=session;place(content,station,Rect2(0,0,1600,900));station.module_selected.connect(open_module)
	label(content,"MERIDIAN / ORBITAL DEFENSE COMMAND",Rect2(30,23,780,24),17,Color("83acbb"))
	label(content,"THE FIRST WATCH / TRAINING",Rect2(30,53,670,46),36)
	label(content,"ORBITAL DATA CENTER 01 / SIMULATED TRAINING WATCH",Rect2(30,108,1000,30),19,Color("86b8c5"))
	time_label=label(content,"",Rect2(790,33,290,30),19)
	button(content,"Company / 15",Rect2(1090,31,180,46),func():open_panel("company"),"company")
	debrief_button=button(content,"Watch report",Rect2(1285,31,185,46),func():open_panel("debrief"),"debrief")
	pause_button=button(content,"Pause",Rect2(1484,31,92,46),toggle_pause,"pause")
	label(content,"YOUR WATCH",Rect2(30,184,240,30),17,Color("719eac"))
	for i in range(session.scenario.crew.size()):
		var crew: Dictionary=session.scenario.crew[i];var b:=button(content,session.personnel_name(crew.id)+"\n"+crew.role,Rect2(30,210+i*106,250,94),func():open_crew(crew.id),"crew_"+crew.id);b.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;b.alignment=HORIZONTAL_ALIGNMENT_LEFT;b.add_theme_font_size_override("font_size",18);crew_buttons[crew.id]=b
	button(content,"Commission upgrade",Rect2(30,542,250,48),func():open_panel("upgrade" if session.started else "welcome"),"upgrades")
	button(content,"Watch journal",Rect2(30,600,250,45),func():open_panel("log"),"journal")
	button(content,"Watch Officer's Checklist",Rect2(30,707,310,38),func():open_panel("checklist"),"checklist")
	button(content,"Return to Command Desk",Rect2(350,707,280,38),request_return,"return")
	objective_label=label(content,"",Rect2(30,752,1040,62),24)
	job_label=label(content,"",Rect2(310,195,770,48),18,Color("83ddcb"))
	incident_button=button(content,"Inspect unusual activity",Rect2(30,656,250,45),func():open_module("identity" if session.upgrade=="identity" else "network"),"incident")
	message_label=label(content,"",Rect2(30,835,1528,42),18,Color("a2c4ce"))
	context=PanelContainer.new();var style:=StyleBoxFlat.new();style.bg_color=Color(0.018,0.045,0.064,0.96);style.border_color=Color("325967");style.set_border_width_all(1);style.set_corner_radius_all(6);style.set_content_margin_all(20);context.add_theme_stylebox_override("panel",style);place(content,context,Rect2(1120,161,456,650))
	var col:=VBoxContainer.new();col.add_theme_constant_override("separation",16);context.add_child(col)
	var heading:=HBoxContainer.new();col.add_child(heading);context_title=Label.new();context_title.size_flags_horizontal=Control.SIZE_EXPAND_FILL;context_title.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;context_title.add_theme_font_size_override("font_size",24);heading.add_child(context_title)
	var close:=Button.new();close.text="Close";close.add_theme_font_size_override("font_size",17);heading.add_child(close);close.pressed.connect(func():panel_mode="";render_context())
	col.add_child(HSeparator.new());scroll=ScrollContainer.new();scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;scroll.size_flags_vertical=Control.SIZE_EXPAND_FILL;col.add_child(scroll);body=VBoxContainer.new();body.size_flags_horizontal=Control.SIZE_EXPAND_FILL;body.add_theme_constant_override("separation",14);scroll.add_child(body)
	render_context();resize_content()
func place(parent: Node,node: Control,bounds: Rect2) -> void:
	parent.add_child(node);node.position=bounds.position;node.size=bounds.size
func label(parent: Node,value: String,bounds: Rect2,font_size: int,color: Color=Color("dce8ec")) -> Label:
	var l:=Label.new();l.text=value;l.add_theme_font_size_override("font_size",font_size);l.add_theme_color_override("font_color",color);l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;place(parent,l,bounds);return l
func button(parent: Node,value: String,bounds: Rect2,action: Callable,id: String="") -> Button:
	var b:=Button.new();b.text=value;place(parent,b,bounds);b.pressed.connect(action)
	if not id.is_empty():controls[id]=b
	return b
func paragraph(value: String,color: Color=Color("c4d5dc"),font_size: int=21) -> Label:
	var l:=Label.new();l.text=value;l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;l.size_flags_horizontal=Control.SIZE_EXPAND_FILL;l.add_theme_font_size_override("font_size",font_size);l.add_theme_color_override("font_color",color);body.add_child(l);return l
func action(value: String,callback: Callable,id: String,enabled: bool=true) -> Button:
	var b:=Button.new();b.text=value;b.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;b.custom_minimum_size.y=48;b.disabled=not enabled;body.add_child(b);b.pressed.connect(func():callback.call();render_context());controls[id]=b;return b
func subtitle(value: String) -> void:
	paragraph(value,Color("86d2d7"),18)
func open_panel(mode: String) -> void:
	panel_mode=mode
	if is_instance_valid(scroll):scroll.scroll_vertical=0
	render_context()
func open_module(id: String) -> void:
	session.inspect_module(id);session.review_evidence(id);station.selected=id;open_panel(id)
func open_crew(id: String) -> void:
	session.talk(id);open_panel("crew:"+id)
func toggle_pause() -> void:
	session.paused=not session.paused;pause_button.text="Resume" if session.paused else "Pause"
func resize_content() -> void:
	var available:=get_viewport_rect().size;var factor:=minf(available.x/1600,available.y/900);content.scale=Vector2.ONE*factor;content.position=(available-Vector2(1600,900)*factor)/2
func _process(delta: float) -> void:
	if session==null:return
	session.step(delta);resize_content();objective_label.text=session.objective();message_label.text=session.last_message
	earth_material.set_shader_parameter("drift",station.animation_time*0.001)
	controls.upgrades.text="Commission upgrade" if session.started else "Take command"
	time_label.text="WATCH %02d:%02d%s" % [int(session.clock)/60,int(session.clock)%60," / PAUSED" if session.paused else ""]
	incident_button.visible=session.incident!="QUIET" and not session.finished
	debrief_button.disabled=false
	controls.checklist.text="Checklist / "+("Handover complete" if session.finished else "Ready to file" if session.ready_to_finish() else "%d outstanding" % session.handover_blockers().size())
	var jobs: Array=[]
	for key in session.jobs:jobs.append("%s  %02ds" % [key.capitalize(),ceili(session.remaining(key))])
	job_label.text="  /  ".join(jobs)
	if session.commissioning=="personal" and not session.upgrade_ready and session.remaining("commission")<=0 and (not session.inspected.has("identity") or not session.inspected.has("network")):job_label.text="Personal check: inspect Identity and Network to sign off."
	if revision!=session.revision:revision=session.revision;render_context()
func render_context() -> void:
	if not is_instance_valid(body):return
	body.add_theme_constant_override("separation",14)
	var saved_scroll:=scroll.scroll_vertical
	for node in body.get_children():body.remove_child(node);node.queue_free()
	# Remove retired contextual controls; fixed HUD controls retain their identity.
	for key in controls.keys():
		if not is_instance_valid(controls[key]) or controls[key].is_queued_for_deletion():controls.erase(key)
	context.visible=not panel_mode.is_empty()
	if panel_mode.is_empty():return
	if panel_mode.begins_with("crew:"):render_crew(panel_mode.get_slice(":",1))
	else:
		match panel_mode:
			"welcome":
				context_title.text="Your installation."
				subtitle("DC-01 / FIRST ASSIGNMENT")
				paragraph("Fifteen stations. Fifteen lieutenants. No fleet commander. Your first watch starts here.")
				paragraph("Meet the crew, commission one improvement and protect the maintenance window. Click station modules to work.")
				action("Take command",func():session.start();panel_mode="", "start")
			"upgrade","commission":render_upgrade()
			"checklist":render_checklist()
			"core":render_core()
			"identity":render_identity()
			"network":render_network()
			"company":render_company()
			"debrief":render_debrief()
			"adversary":render_adversary()
			"lesson":render_lesson()
			"log":
				context_title.text="Watch journal";subtitle("YOUR P14 COMMAND RECORD / SIMULATION")
				if session.events.is_empty():paragraph("Your watch has not started.")
				for event in session.events:
					paragraph("%02d:%02d  %s" % [int(event.time)/60,int(event.time)%60,event.message],Color("bacdd5"),19)
	scroll.set_deferred("scroll_vertical",saved_scroll)
func render_crew(id: String) -> void:
	var crew: Dictionary=session.scenario.crew.filter(func(c):return c.id==id)[0];context_title.text=session.personnel_name(id);subtitle(crew.role.to_upper())
	paragraph(crew.line,Color(crew.color),23)
	if session.followed.has(id):
		paragraph(crew.followup)
		if id=="eli":
			paragraph("Unusual interest is not proof of hostile intent. Retain the messages privately; verify outside requests.",Color("9db7c4"),18)
			action("Keep messages. Brief the watch.",func():session.brief_crew(),"brief",not session.crew_briefed and not session.finished)
			if session.crew_briefed:subtitle("CREW REASSURED / COVERAGE DETAILS KEPT PRIVATE")
	else:action("Hear more",func():session.follow_up(id),"follow_"+id,session.started and not session.finished)
	if id=="mara":action("Review the upgrade allocation",func():open_panel("upgrade"),"crew_upgrade",session.started and not session.finished)
	if id=="imani" and session.incident!="QUIET":action("Inspect the vendor account",func():open_module("identity"),"crew_identity")
func render_upgrade() -> void:
	context_title.text="One improvement"
	if session.upgrade.is_empty():
		subtitle("ONE ALLOCATION / BOTH OPTIONS ARE USEFUL")
		paragraph("Identity Security",Color("91ded1"),24);paragraph("Flag legacy credentials earlier and slow repeated attempts. Account repair still needs your order.",Color("b7cbd4"),20)
		action("Install identity module",func():session.choose_upgrade("identity"),"choose_identity",session.started)
		paragraph("Network Monitoring",Color("91ded1"),24);paragraph("Reveal the service path earlier. Isolation can buy time, but it does not fix an account.",Color("b7cbd4"),20)
		action("Install monitoring dish",func():session.choose_upgrade("network"),"choose_network",session.started)
	elif session.commissioning.is_empty():
		subtitle(session.upgrade.to_upper()+" SELECTED")
		paragraph("Chief Petty Officer Mara Voss: I can commission it. Or you can verify the modules yourself while I keep customer traffic steady.")
		action("Delegate to Chief Petty Officer Mara Voss / 50s",func():session.commission("delegate"),"delegate")
		action("Handle personally / 35 seconds",func():session.commission("personal"),"personal")
		paragraph("Personal sign-off also requires inspecting Identity and Network. Delegation builds crew responsibility.",Color("96afbc"),18)
	else:
		subtitle("MODULE ONLINE" if session.upgrade_ready else "COMMISSIONING IN PROGRESS")
		paragraph("Your %s upgrade is %s." % [session.upgrade,"operational" if session.upgrade_ready else "being brought online"])
		paragraph("A lit ring identifies the improved station module. You can continue speaking with the crew or inspecting the installation.")
		if session.commissioning=="personal" and not session.upgrade_ready:paragraph("Inspect both Identity and Network to sign the commissioning baseline.",Color("e6be86"))
func render_core() -> void:
	context_title.text="Station operations";subtitle("ORBITAL INFRASTRUCTURE / DC-01")
	paragraph("Customer service: ONLINE",Color("9ad9c4"),24)
	paragraph("Power and cooling: "+("baseline verified" if session.completed_jobs.has("health") else "nominal; commissioning check available"))
	action("Run power & cooling check",func():session.health_check(),"health",session.started and not session.finished and not session.jobs.has("health") and not session.completed_jobs.has("health"))
	paragraph("Vendor maintenance: "+("route available" if session.route_open else "held at gateway"))
	paragraph("Recovery verification: "+("VERIFIED" if session.service_verified else "IN PROGRESS" if session.jobs.has("verify") else "PENDING"),Color("90e2cd") if session.service_verified else Color("e6be86"),20)
	action("Verify service restoration",func():session.verify_service(),"verify",not session.finished and session.credentials_retired and session.route_open and (not session.unauthorized or session.session_revoked) and not session.service_verified and not session.jobs.has("verify"))
	for reason in session.recovery_blockers():paragraph("Verification blocked - "+str(reason),Color("e6be86"),18)
	if session.jobs.has("verify"):paragraph("Verification in progress. Wait for its measured completion.",Color("83ddcb"),18)
	if session.ready_to_finish():action("File watch report",func():open_panel("debrief"),"file")
func evidence_heading() -> void:
	subtitle("SIMULATED EXERCISE EVIDENCE")
	if session.incident!="QUIET":
		paragraph("SUSPECTED ATTACK",Color("dcb685"),17);paragraph(session.attack.display_name,Color("f0d7b1"),24)
func render_identity() -> void:
	session.review_evidence("identity")
	context_title.text="Identity & access";evidence_heading()
	if session.incident=="QUIET":paragraph("Maintenance service is scheduled. Lieutenant Junior Grade Imani Rao recommends checking the legacy vendor account when the window opens.");return
	if not session.account_known:
		paragraph("Unusual service activity. Audit the vendor account before changing its policy.")
		action("Audit service accounts / 22s",func():session.audit_account(),"audit",not session.jobs.has("account") and not session.finished);return
	paragraph("vendor-maint / service account",Color("a9d9dc"),22)
	paragraph("Credential: "+("unique replacement active" if session.credentials_retired else "factory credential remains active"))
	paragraph("Session: "+("revoked" if session.session_revoked else "unauthorized login confirmed" if session.unauthorized else "no accepted sign-in observed"),Color("f1ac9d") if session.unauthorized and not session.session_revoked else Color("bad5d6"))
	paragraph("No data compromise has been established. A sign-in is not evidence of every possible attacker action.",Color("9aafbb"),18)
	action("Retire factory credential / 18s",func():session.rotate_credential(),"rotate",not session.credentials_retired and not session.jobs.has("rotate") and not session.finished)
	if session.unauthorized:action("Revoke vendor session",func():session.revoke_session(),"revoke",not session.session_revoked and not session.finished)
	action("Read the attack lesson",func():previous_mode="identity";open_panel("lesson"),"lesson")
	if session.credentials_retired:action("Verify in station operations",func():open_module("core"),"go_verify")
func render_network() -> void:
	session.review_evidence("network")
	context_title.text="Network defense";evidence_heading()
	if session.incident=="QUIET":paragraph("Customer routes are stable. The maintenance gateway opens during commissioning. No suspicious activity has been observed.");return
	if not session.connection_known:
		paragraph("Establish the service path before changing gateway access.")
		action("Trace maintenance connection / 16s",func():session.trace_connection(),"trace",not session.jobs.has("connection") and not session.finished);return
	paragraph("External source → maintenance gateway → vendor service",Color("a9d9dc"),23)
	paragraph("Repeated sign-in attempts target the vendor service. The source is not attributed.")
	paragraph("Route: "+("OPEN" if session.route_open else "ISOLATED"),Color("b4dacd") if session.route_open else Color("e6bd88"),24)
	action("Isolate maintenance route" if session.route_open else "Restore maintenance route",func():session.set_route(not session.route_open),"route",not session.finished)
	paragraph("This affects vendor maintenance, not customer traffic. Isolation blocks this path; it does not retire the credential or revoke a session.",Color("9aafbb"),18)
	action("Inspect the vendor identity",func():open_module("identity"),"go_identity")
func render_company() -> void:
	context_title.text="Fifteen lieutenants";subtitle("MERIDIAN ORBITAL / COMPANY AMBITIONS")
	paragraph("Lieutenant: command one station.\nCommander: future oversight of five.\nFleet Commander: future oversight of fifteen.",Color("b9d5dc"),20)
	paragraph("Senior posts are unfilled. Competitors below are simulated reference profiles, not live installations.",Color("91aebc"),17)
	var rank:=0
	for row in session.standings():
		rank+=1;paragraph("%02d  %s / %s   %d" % [rank,row.center,row.name,row.score],Color("90e2cd") if row.get("player",false) else Color("adbec9"),19)
func render_debrief() -> void:
	context_title.text="The watch report"
	if not session.finished:
		paragraph("Ready for handover." if session.ready_to_finish() else "Handover blocked - complete the outstanding procedures.")
		for reason in session.handover_blockers():paragraph("- "+str(reason),Color("e6be86"),18)
		action("File this watch",func():session.finish(),"finish",session.ready_to_finish());return
	subtitle("YOUR FIRST WATCH / COMMAND PERFORMANCE")
	paragraph("Installation ready.\nCommand rating: %d / 100" % session.score(),Color("98e1cb"),25)
	for key in session.metrics:
		paragraph(key,Color("bacdd7"),18);var bar:=ProgressBar.new();bar.value=session.metrics[key];bar.custom_minimum_size.y=19;bar.tooltip_text=str(session.metrics[key])+" / 100";body.add_child(bar)
	paragraph("Factory access retired. "+("An unauthorized session was revoked; service was recovered." if session.unauthorized else "No unauthorized sign-in was accepted before the repair."),Color("bed8d7"),20)
	var mara: String="Chief Petty Officer Mara Voss: Thanks for trusting me with commissioning." if session.commissioning=="delegate" else "Chief Petty Officer Mara Voss: Your sign-off was quick. Let me take the next one."
	var eli: String="Ensign Eli Chen: Thanks for checking without blaming me." if session.crew_briefed else "Ensign Eli Chen: I kept the messages. We should talk about that contact."
	paragraph(mara+"\nLieutenant Junior Grade Imani Rao: We repaired an access path, not every threat in the universe.\n"+eli,Color("a7bbc8"),18)
	action("Compare company standings",func():open_panel("company"),"results_company")
	action("Optional adversary debrief / spoilers",func():open_panel("adversary"),"adversary")
	action("Start a new P14 watch",restart_watch,"restart")
func render_adversary() -> void:
	context_title.text="Martian War Room"
	if not session.finished:paragraph("Adversary perspective unlocks after the watch.");return
	subtitle("SIMULATED ADVERSARY DEBRIEF / SPOILERS")
	paragraph(session.scenario.adversary_objective)
	paragraph("The lieutenant repaired the access path. The leave conversation remains an ambiguous contact in the human record.",Color("d8b9b0"))
	paragraph("Intent is not proof. The lieutenant never saw this planning assessment.",Color("96afbc"),18)
	action("Return to command report",func():open_panel("debrief"),"adversary_back")
func render_lesson() -> void:
	context_title.text=session.attack.display_name;subtitle("OPTIONAL ATTACK LESSON / CATALOG ID %d" % int(session.attack.attack_id))
	paragraph(session.attack.definition);subtitle("REALISTIC EXAMPLE");paragraph(session.attack.example)
	paragraph("In this exercise: rotating the factory credential prevents new default-credential sign-ins. Existing sessions need separate revocation; isolation buys time but does not repair identity policy.",Color("a4c5ce"),20)
	action("Return to the account",func():open_panel(previous_mode),"lesson_back")
func restart_watch() -> void:
	session=Session.new();session.configure();station.session=session;station.selected="";panel_mode="welcome";revision=-1;pause_button.text="Pause"
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		panel_mode="";render_context();get_viewport().set_input_as_handled()

func request_return() -> void:
	if not return_requested.get_connections().is_empty():return_requested.emit()
	else:
		if session.started and not session.finished:
			var confirm:=ConfirmationDialog.new();confirm.title="Leave this standalone watch?";confirm.dialog_text="This direct-launch watch will be left behind. Return to Command Desk?";add_child(confirm)
			confirm.confirmed.connect(func():get_tree().change_scene_to_file("res://scene/odc_entry.tscn"));confirm.canceled.connect(confirm.queue_free);confirm.popup_centered()
		else:get_tree().change_scene_to_file("res://scene/odc_entry.tscn")
func render_checklist() -> void:
	context_title.text="Watch Officer's Checklist"
	body.add_theme_constant_override("separation",8)
	subtitle("MANDATORY PROCEDURES / LIVE WATCH STATE")
	for row in Checklist.rows(session):
		var procedure:=action(row.title+" / "+row.status,func():
			if row.destination.begins_with("crew:"):open_crew(row.destination.get_slice(":",1))
			elif row.destination in ["core","identity","network"]:open_module(row.destination)
			else:open_panel(row.destination),"procedure_"+row.destination)
		procedure.add_theme_font_size_override("font_size",18);procedure.add_theme_color_override("font_color",Color("90e2cd") if row.status=="Verified" else Color("e6be86"));procedure.tooltip_text=row.reason
		if row.status=="Blocked":paragraph(row.reason if row.destination!="debrief" else str(session.handover_blockers()[0]),Color("b7cbd4"),18)
	subtitle("OPTIONAL / LEADERSHIP")
	paragraph("Hear follow-up concerns and privately brief the watch. Useful leadership actions; not handover prerequisites.",Color("9db7c4"),18)
