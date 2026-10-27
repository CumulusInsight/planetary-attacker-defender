extends "res://script/martian_defense_panel.gd"
func configure(owner: Node) -> void:
	super.configure(owner)
	remove_child(selector);selector.queue_free();selector=null
	evade_button.text="EVADE ALL PROJECTILES"
	shot_list.position.y=178;shot_list.size.y=270
func evade_selected() -> void:
	var ids:=incoming();ids.sort();var attempted:=0
	for id in ids:
		var p=records[id].get_ref()
		if game.session.evade_shot(id,p.generation):
			game.session.flights[id].evasion_started=game.session.now
			p.order_evasion(game.session.now,game.session.flights[id].evasion_success);attempted+=1
	result_label.text="%d targets attempting evasion" % attempted;refresh()
func refresh() -> void:
	if not is_instance_valid(game):return
	var active:=incoming();var ids: Array=records.keys();ids.sort()
	count_label.text="Active incoming projectiles: %d" % active.size()
	incoming_label.text="INCOMING PROJECTILE" if not active.is_empty() else "INCOMING FIRE RESOLVED"
	flash_on=fmod(game.session.now,1.0)<0.5;warning.visible=not active.is_empty();warning.modulate.a=1.0 if flash_on or game.command.strategic_paused else 0.35
	var lines: Array=[];var attempts:=0;var successes:=0;var failures:=0;var hits:=0;var eligible:=0
	for id in ids:
		var result: Dictionary=game.session.results.get(id,{})
		var flight: Dictionary=game.session.flights.get(id,{})
		var record: Dictionary=result if not result.is_empty() else flight
		var tried: bool=record.get("evasion_attempted",false)
		if tried:
			attempts+=1
			if not result.is_empty():
				if record.evasion_success:successes+=1
				else:failures+=1
		if result.get("projectile_outcome","")=="HIT":hits+=1
		if id in active and not tried:eligible+=1
		var state: String=result.get("projectile_outcome","EVADING" if tried else "APPROACHING")
		lines.append("%s / C-%03d: %s" % [game.learning_contacts[id].center_id,id,state])
		if not result.is_empty():
			lines.append("  "+("Correct" if result.answer_correct else "Incorrect; use "+result.correct_name)+(" / evade succeeded" if tried and result.evasion_success else " / evade failed" if tried else " / no evasion"))
	shot_list.text="\n".join(lines);evade_button.disabled=eligible==0
	result_label.text="%d incoming / %d attempts\n%d successful / %d failed\n%d physical hits" % [ids.size(),attempts,successes,failures,hits]
	close_button.disabled=not active.is_empty();mute_button.text="UNMUTE" if muted else "MUTE"
	if active.is_empty() or muted:alarm.stop()
	else:
		if not alarm.playing:alarm.play()
		alarm.stream_paused=game.command.strategic_paused or not game.learning_context
