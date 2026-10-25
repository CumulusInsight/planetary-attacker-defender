extends "res://tests/prototype4_test.gd"
const Data = preload("res://script/cyber_data.gd")
const Session = preload("res://script/cyber_session.gd")
var command: Node
func run() -> void:
	models()
	await integration()
	print("PROTOTYPE 9 CYBER: ","PASS" if failures==0 else "FAIL"," (",failures," failures; ",checks," checks)")
	quit(0 if failures==0 else 1)
func models() -> void:
	var loaded: Dictionary = Data.load_data()
	check(loaded.error.is_empty(),"Owner catalog/scenarios load")
	for profile in loaded.scenarios:
		for index in range(3):
			var model = Session.new()
			model.configure(loaded)
			var id: int = profile.contact_id
			var view: Dictionary = model.public_view(id)
			check(view.choices.size()==3,"Three real choices")
			var public_json := JSON.stringify(view)
			for secret in ["private_attack_id","required_conditions","final","outcome","peaceful_survey_probe","covert_relay"]:
				check(not public_json.contains('"'+secret+'"'),"No private evaluator rule in public view")
			var response: int = view.choices[index].defense_id
			check(not model.evaluate(id,response,"unconfirmed",false).ok,"Explicit escalation required")
			var result: Dictionary = model.evaluate(id,response,"decision",true)
			check(result.ok and result.outcome==profile.responses[index].outcome,"Authored deterministic outcome")
			check(result.final==(result.outcome=="contained"),"Only modeled observable containment finalizes")
			check(result==model.evaluate(id,response,"decision",true),"Token redelivery deterministic")
			check(not model.evaluate(id,response,"repeat",true).ok,"No repeated execution of used defense")
			check(result.execution.contains("movement unchanged"),"Cyber execution distinct from spacecraft destruction")
			var second = Session.new(); second.configure(loaded)
			check(second.evaluate(id,response,"same",true)==result,"Same authored conditions reproduce outcome")
	var bad: Dictionary = loaded.catalog.duplicate(true)
	bad.attack_defenses[0].attack_id = 999999
	check(not Data.validate(bad,{"schema_version":1,"scenarios":loaded.scenarios}).is_empty(),"Broken mapping rejected")
	bad = loaded.catalog.duplicate(true); bad.defenses[0].definition = ""
	check(not Data.validate(bad,{"schema_version":1,"scenarios":loaded.scenarios}).is_empty(),"Missing defense definition rejected")
	var scenarios: Array = loaded.scenarios.duplicate(true); scenarios[0].private_attack_id = 999
	check(not Data.validate(loaded.catalog,{"schema_version":1,"scenarios":scenarios}).is_empty(),"Missing attack reference rejected")
	scenarios = loaded.scenarios.duplicate(true); scenarios[0].responses[0].defense_id = 999
	check(not Data.validate(loaded.catalog,{"schema_version":1,"scenarios":scenarios}).is_empty(),"Missing defense reference rejected")
	check(not Data.load_data("user://missing_cyber_catalog.json").error.is_empty(),"Missing catalog diagnostic")
	var malformed := FileAccess.open("user://malformed_cyber.json",FileAccess.WRITE); malformed.store_string("["); malformed.close()
	check(not Data.load_data("user://malformed_cyber.json").error.is_empty(),"Invalid catalog diagnostic")
	DirAccess.remove_absolute("user://malformed_cyber.json")
func integration() -> void:
	command = load("res://scene/cyber_command.tscn").instantiate()
	game = command
	test_viewport.add_child(command)
	pointer_at(Vector2(10,880))
	await frames()
	var host = command.cyber
	check(host.error.is_empty() and command.registry.contacts.size()==18,"Main cyber command has eighteen contacts")
	command.set_strategic_pause(true)
	var official: Dictionary = command.mission.public_snapshot()
	for id in range(10,15):
		command.focus_center(command.registry.contacts[id].center_id,id)
		var tactical = command.registry.contacts[id].tactical
		var contact: Node
		for item in tactical.get_node("EnemyContainer").get_children():
			if item.attack_id==id: contact=item
		var object_id: int = contact.get_instance_id()
		var path: String = tactical.contact_context(id).path_id
		var truth: Dictionary = tactical.intelligence.debug_truth(id)
		var initial: Dictionary = command.operations.session.view(id)
		check(initial.state=="MONITORED" and initial.remaining==null,"Cyber capability never auto escalates or creates deadline")
		if id == 10:
			await frames()
			await click_at(command.operations.ui.local_button.get_global_rect().get_center())
			check(host.modal.visible,"Tactical card opens cyber choices by actual mouse input")
		else: host.open_contact(id)
		check(host.choice_buttons.all(func(b): return b.disabled),"Choices visibly unavailable until explicit escalation")
		var escalation: Dictionary = command.operations.execute(id,"escalate","Review observed cyber anomaly",command.operations.evidence(id))
		check(escalation.ok,"Existing explicit escalation path")
		host.render()
		var count: int = host.journal.size()
		var failed := 2 if id in [10,12,13] else 1
		if id==11: failed=2
		await click_at(host.choice_buttons[failed].get_global_rect().get_center())
		check(command.operations.session.view(id).state=="ESCALATED","Incomplete response leaves operational concern unresolved")
		check(host.journal.size()==count+1,"One canonical cyber event per accepted response")
		check(host.receipt.text.contains("COMMAND ACCEPTED") and host.receipt.text.contains("unresolved"),"Immediate meaningful failure feedback")
		var success := 1 if id==13 else 0
		await click_at(host.choice_buttons[success].get_global_rect().get_center())
		check(command.operations.session.view(id).state=="RESOLVED","Observed containment visibly resolves cyber operation")
		check(host.receipt.text.contains("Spacecraft remains in orbit"),"No invented spacecraft kill")
		check(tactical.intelligence.debug_truth(id)==truth,"Cyber decisions never rewrite accepted P8 truth")
		check(contact.get_instance_id()==object_id and tactical.contact_context(id).path_id==path,"Identity and orbital path stable through action/navigation")
		if id==10: await capture("p9_cyber_response")
		host.close()
		if id == 10:
			await frames()
			await capture("p9_cyber_contained_tactical")
			await click_at(host.history_button.get_global_rect().get_center())
			check(host.history.visible,"Tactical Officer has network after-action access")
			host.history.hide()
		command.show_overview()
		command.focus_center(command.registry.contacts[id].center_id,id)
		check(tactical.contact_context(id).path_id==path,"Return navigation keeps same path")
	check(command.mission.public_snapshot()==official,"All cyber decisions leave official mission scoring unchanged")
	for entry in host.journal:
		check(entry.local_datetime.contains("T") and (entry.local_datetime.right(6).begins_with("-") or entry.local_datetime.right(6).begins_with("+")),"Wall datetime includes timezone offset")
		check(entry.has("simulation_elapsed") and entry.has("center_id") and entry.has("path_id") and entry.has("assessment"),"Complete public event context")
		check(not JSON.stringify(entry).contains("private_attack_id"),"No hidden attack ID in event history")
	var count: int = host.journal.size()
	command.show_overview(); command.focus_center("DC-01",10); command.show_overview()
	await frames()
	check(host.journal.size()==count,"Navigation does not duplicate events")
	await click_at(host.history_button.get_global_rect().get_center())
	check(host.history.visible and host.history_text.text.contains("cyber_response"),"Operations Commander can inspect persistent after action")
	await capture("p9_cyber_history")
	host.history.hide()
	command.focus_center("DC-01",1)
	var original = command.tactical_centers["DC-01"]
	original.active_contact.total_orbit_travel=original.deadline.initial.travel+original.deadline.budget-original.active_contact.move_speed*0.001
	original._on_command_requested("deploy")
	check(original.encounter.resolved and host.journal.back().acceptance=="COMMAND ACCEPTED","Original just-before-expiry uses same authoritative journal")
	check(host.journal.back().remaining>0,"Original acceptance time recorded")
	original._sync_deadline()
	check(host.journal.filter(func(e): return e.kind=="original encounter decision").size()==1,"No duplicate original resolution")
	var now: float = command.operations.session.now
	await frames(10)
	check(is_equal_approx(command.operations.session.now,now),"Learning strategic pause freezes authoritative event clock")
	command.set_learning_mode(false)
	await frames(10)
	check(command.operations.session.now>now,"Challenge clock resumes with no catch-up")
	command.focus_center("DC-01",10)
	var elliptical: Node
	for item in command.tactical_centers["DC-01"].get_node("EnemyContainer").get_children():
		if item.attack_id==10: elliptical=item
	var position_before: Vector2 = elliptical.position
	var progress: float = elliptical.total_orbit_travel
	pointer_at(position_before)
	await frames(5)
	progress = elliptical.total_orbit_travel
	await frames(10)
	check(is_equal_approx(elliptical.total_orbit_travel,progress),"Actual rendered hover still freezes only selected ellipse")
	pointer_at(Vector2(10,880))
	await frames(5)
	check(elliptical.total_orbit_travel>progress,"Mouse exit resumes same path")
	var simulation_before: float = command.operations.session.now
	host.open_contact(10)
	await frames(8)
	check(command.operations.session.now>simulation_before,"Opening cyber reports does not stop Challenge clock or duplicate timers")
	host.close()
	command.focus_center("DC-01",1)
	await capture("p9_cyber_tactical_result")
	var sample := FileAccess.open("user://prototype9_cyber_after_action_sample.json",FileAccess.WRITE)
	sample.store_string(JSON.stringify(host.journal,"\t"))
	sample.close()
	await close_game()
