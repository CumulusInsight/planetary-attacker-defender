extends "res://tests/prototype4_test.gd"
var command: Node
var ui: CanvasLayer
var clicks:=0
var metrics: Array=[]
func settle() -> void:await create_timer(0.22).timeout
func press(button: Button) -> void:
	clicks+=1;await click_at(button.get_global_rect().get_center());await settle()
func spawn_direct(custom: bool=false) -> void:
	command=load("res://scene/direct_command.tscn").instantiate();game=command
	if custom:
		var data: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/contact_operations.json"))
		for record in data.contacts:
			if int(record.contact_id) in [10,15]:record.operational_deadline_seconds=20.0
		var file=FileAccess.open("user://p10s4_operations_fixture.json",FileAccess.WRITE);file.store_string(JSON.stringify(data));file.close()
		command.operations_data_path="user://p10s4_operations_fixture.json"
	test_viewport.add_child(command);pointer_at(Vector2(800,100));await frames()
	ui=command.decision_pages;clicks=0
func tree_pick(tree: Tree,item: TreeItem) -> void:
	tree.scroll_to_item(item);await frames();clicks+=1
	await click_at(tree.get_global_rect().position+tree.get_item_area_rect(item).get_center());await settle()
func type_reason() -> void:
	for character in "Public report warrants operational review":
		var event:=InputEventKey.new();event.pressed=true;event.unicode=character.unicode_at(0);test_viewport.push_input(event,true)
	await frames()
	check(ui.reason_input.text.length()>=3 and not ui.confirmation.get_ok_button().disabled,"Real keyboard reason satisfies existing escalation authorization")
func mapped_button(defense: int) -> Button:
	var index: int=ui.mapped_options.find(ui.mapped_options.filter(func(o):return o.defense_id==defense)[0])
	return ui.mapped_list.get_child(index).get_children().filter(func(n):return n is Button)[0]
func run() -> void:
	for entry in ["deadline","contacts","alerts","overview","orbital"]:
		await spawn_direct()
		var t=command.tactical_centers["DC-01"]
		check(t.deadline.capture(t.active_contact,20.0),"Explicit test-only short original deadline")
		command.set_learning_mode(false);await frames();ui.refresh_status()
		var start: float=command.operations.session.now
		var travel: float=t.active_contact.total_orbit_travel
		var window_before: float=t.deadline.remaining(t.active_contact)
		check(ui.top_buttons.alerts.text=="1 Urgent","Clear urgent count uses real public criteria")
		match entry:
			"deadline":await tree_pick(ui.deadline_table,ui.deadline_items[1])
			"contacts":await press(ui.top_buttons.contacts);await tree_pick(ui.contact_table,ui.table_rows[1])
			"alerts":
				await press(ui.top_buttons.alerts)
				check(ui.public_rows().size()==1,"Alerts filters only applicable urgent contacts")
				await tree_pick(ui.contact_table,ui.table_rows[1])
			"overview":await press(ui.top_buttons.overview);await press(ui.overview_cards.attention);await tree_pick(ui.contact_table,ui.table_rows[1])
			"orbital":
				clicks+=1;await click_at(t.active_contact.global_position);await settle()
		check(ui.opened.threat and ui.section=="response" and ui.selected==1,"Every entry opens the single persistent response home: "+entry)
		check(t.deadline.remaining(t.active_contact)<20.01,"Navigation does not restart/extend deadline")
		check(not ui.primary_response.disabled and not ui.response_actions.hold.disabled,"Original urgent contact has prominent executable response and deliberate Hold Fire")
		await press(ui.primary_response)
		check(ui.confirmation.visible and not ui.confirmation.get_ok_button().disabled,"One supported action goes directly to existing confirmation")
		check(not t.encounter.resolved,"Selecting response alone never executes")
		await press(ui.confirmation.get_ok_button())
		check(t.encounter.resolved and t.after_actions.back().acceptance=="COMMAND ACCEPTED" and t.closed_remaining>0,"Defense accepted and resolved before short deadline")
		check(ui.home_receipt.is_visible_in_tree() and ui.home_receipt.text.contains("COMMAND ACCEPTED") and ui.home_receipt.text.contains("Deploy defense") and ui.home_receipt.text.contains("At "),"Immediate persistent result has actual action, acceptance, timestamp")
		check(command.cyber.journal.any(func(e):return e.contact_id==1 and e.kind=="original encounter decision"),"Canonical event source records actual original decision")
		var count: int=command.cyber.journal.size();ui.confirm_action();ui.confirmation.confirmed.emit();await frames()
		check(count==command.cyber.journal.size(),"Double confirmation cannot duplicate events or score")
		metrics.append({"path":entry,"clicks":clicks,"simulation_seconds_until_acceptance":ui.receipt_entry().simulation_elapsed-start,"movement_seconds_until_acceptance":window_before-t.closed_remaining,"simulation_seconds_through_result":command.operations.session.now-start,"movement_seconds":(t.active_contact.total_orbit_travel-travel)/t.active_contact.move_speed,"remaining_at_acceptance":t.closed_remaining})
		if entry=="deadline":
			await capture("p10s4_original_result")
			var scored: Dictionary=command.mission.public_snapshot()
			ui.review_replay();await press(ui.confirmation.get_ok_button())
			check(not t.encounter.resolved and ui.receipt_entry().is_empty(),"Replay clears current-attempt result without erasing old canonical history")
			check(command.mission.public_snapshot()==scored,"Replay cannot farm or reset official points")
		await close_game()
	await spawn_direct(true)
	command.set_strategic_pause(true);await frames()
	var official: Dictionary=command.mission.public_snapshot()
	await press(ui.top_buttons.contacts);await tree_pick(ui.contact_table,ui.table_rows[10]);await capture("p10s4_home")
	await press(ui.attack_choices[0])
	check(mapped_button(138).text=="Escalate","Validated control exposes required next step, not hidden menu")
	await press(mapped_button(138))
	check(ui.confirmation.get_ok_button().disabled and ui.reason_input.visible,"Escalation requires reason and confirmation; no bypass")
	await type_reason();await capture("p10s4_escalation")
	await press(ui.confirmation.get_ok_button())
	check(command.operations.session.view(10).state=="ESCALATED" and ui.section=="cyber","Existing escalation executes and returns directly to same mapped controls")
	check(command.operations.session.view(10).remaining!=null and command.operations.session.view(10).remaining<=20.0,"Configured test-only cyber deadline starts only at escalation")
	var start: float=command.operations.session.now;command.set_learning_mode(false);await frames()
	check(mapped_button(138).text=="Deploy","Actually executable defense has prominent Deploy control")
	await capture("p10s4_cyber_controls")
	await press(mapped_button(138));check(ui.confirmation.visible,"Defense still requires confirmation")
	await press(ui.confirmation.get_ok_button())
	check(command.cyber.session.public_view(10).result.outcome=="contained","Existing Antivirus 138 against VIRUS 77 produces its accepted containment outcome")
	check(ui.home_receipt.text.contains("Antivirus") and ui.home_receipt.text.contains("COMMAND ACCEPTED") and command.operations.session.view(10).state=="RESOLVED","Cyber decision-action-result persistent and accurate")
	check(command.mission.public_snapshot()==official,"Cyber response introduces no official mission points")
	metrics.append({"path":"cyber via Contacts, reason typed without extra focus click","clicks":clicks,"simulation_seconds_until_acceptance":ui.receipt_entry().simulation_elapsed-start,"remaining_at_acceptance":ui.receipt_entry().remaining_at_acceptance})
	await capture("p10s4_cyber_result")
	var count: int=command.cyber.journal.size();ui.confirm_action();check(command.cyber.journal.size()==count,"No duplicate cyber command")
	var physical_start: float=command.operations.session.now
	clicks=0;await press(ui.top_buttons.contacts);await tree_pick(ui.contact_table,ui.table_rows[15]);await press(ui.primary_response)
	await type_reason();await press(ui.confirmation.get_ok_button())
	check(not ui.response_actions.physical.disabled,"Existing non-cyber abstract interceptor becomes available after escalation")
	await press(ui.response_actions.physical);await press(ui.confirmation.get_ok_button())
	check(command.operations.session.view(15).state=="RESOLVED" and command.operations.session.statistics().interceptors_deployed==1,"Existing abstract physical deployment is recorded once, not claimed as a kill")
	check(ui.home_receipt.text.contains("unverified") or ui.home_receipt.text.contains("Unverified") or ui.home_receipt.text.contains("UNVERIFIED"),"Physical result explicitly unverified")
	metrics.append({"path":"abstract interceptor via Contacts","clicks":clicks,"simulation_seconds_until_acceptance":ui.receipt_entry().simulation_elapsed-physical_start,"remaining_at_acceptance":ui.receipt_entry().remaining_at_acceptance})
	await capture("p10s4_physical_result")
	# Existing original investigation and deliberate hold-fire path.
	ui.select_contact(4);await settle()
	await press(ui.response_actions.investigate);await press(ui.confirmation.get_ok_button())
	check(command.tactical_centers["DC-02"].encounter.investigated and not command.tactical_centers["DC-02"].encounter.resolved,"Investigation follows original authored path, not a defensive resolution")
	await press(ui.response_actions.hold);await press(ui.confirmation.get_ok_button())
	check(ui.home_receipt.text.contains("Hold fire") and not ui.home_receipt.text.contains("DEADLINE EXPIRED"),"Deliberate hold fire is distinct from expiry")
	ui.select_contact(7);ui.primary_review();command.tactical_centers["DC-03"].deadline.capture(command.tactical_centers["DC-03"].active_contact,0.01);await frames(5)
	check(ui.primary_response.disabled and ui.home_receipt.text.contains("DEADLINE EXPIRED"),"Actual deadline expiration visible, no false deployment success")
	var expired_score: Dictionary=command.mission.public_snapshot()
	await press(ui.confirmation.get_ok_button())
	check(ui.home_receipt.text.contains("COMMAND REJECTED") and ui.home_receipt.text.contains("Deadline expired"),"Late confirmation rejected with expired state, never false success")
	check(command.mission.public_snapshot()==expired_score,"Late rejection cannot duplicate official resolution or score")
	ui.select_contact(16);await press(ui.primary_response)
	check(ui.confirmation.get_ok_button().disabled,"Missing reason cannot authorize escalation")
	var cancelled_count: int=command.cyber.journal.size()
	var cancel: Button=ui.confirmation.get_child(0).get_children().filter(func(n):return n is Button and n.text.begins_with("Cancel"))[0]
	await press(cancel);ui.confirmation.confirmed.emit();await frames()
	check(command.cyber.journal.size()==cancelled_count and command.operations.session.view(16).state=="MONITORED","Cancellation disarms command; stale confirmation cannot execute")
	ui.select_contact(11);await press(ui.attack_choices[2])
	var reference=ui.mapped_options.filter(func(o):return not o.executable)[0]
	ui.inspect_defense(reference)
	check(ui.confirmation.get_ok_button().disabled,"Catalog reference cannot deploy")
	ui.confirmation.hide();ui.command_armed=false
	for value in ["private_attack_id","actual_result","peaceful_survey_probe"]:check(not ui.home_receipt.text.contains(value),"No private truth in immediate receipt")
	var file=FileAccess.open("user://p10s4_metrics.json",FileAccess.WRITE);file.store_string(JSON.stringify(metrics,"\t"));file.close()
	print("CLICK METRICS ",JSON.stringify(metrics))
	await close_game()
	print("PROTOTYPE 10 STAGE 4: ","PASS" if failures==0 else "FAIL"," (",failures," failures; ",checks," checks)")
	quit(0 if failures==0 else 1)
