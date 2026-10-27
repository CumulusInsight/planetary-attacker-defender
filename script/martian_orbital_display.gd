extends "res://script/learning_orbital_display.gd"
## A correct but evaded learning answer must not hide its target.
func sync(enabled: bool) -> void:
	active=enabled;visible=enabled
	if not enabled:
		if hovered>=0:exit_contact(hovered)
		return
	ensure_markers()
	for id in markers:
		var c: String=owner_game.command.registry.contacts[id].center_id
		var actor=sources[id];var marker=markers[id]
		if c not in centers:
			marker.hide()
			if hovered==id:exit_contact(id)
			continue
		marker.position=origins[c]+(actor.position-actor.center_position)*float(ratios[c])
		marker.visible=physical_alive(id)
		if not marker.visible and hovered==id:exit_contact(id)
		if marker.has_node("Artwork"):marker.get_node("Artwork").scale=actor.get_node("Sprite2D").scale*maxf(0.5,ratios[c])*actor.scale
	queue_redraw()

func physical_alive(slot: int) -> bool:
	var identity: String=owner_game.session.physical_slots.get(slot,"")
	return identity.is_empty() or owner_game.session.physical_targets[identity].alive
func ensure_markers() -> void:
	super.ensure_markers()
	for slot in markers.keys():
		var identity: String=owner_game.session.physical_slots.get(slot,"")
		if identity.is_empty():continue
		var marker: Node2D=markers[slot]
		# A replacement is a newly introduced physical target, never a revived node.
		if marker.has_meta("physical_id") and marker.get_meta("physical_id")!=identity:
			marker.hide();remove_child(marker);marker.queue_free()
			markers.erase(slot);interactions.erase(slot);sources.erase(slot)
			super.ensure_markers()
			marker=markers[slot]
		marker.set_meta("physical_id",identity)
		marker.get_node("Identifier").text="C-%03d / P%d" % [slot,owner_game.session.physical_targets[identity].version]
		interactions[slot].tooltip_text="Physical target: "+identity

func configure(game: Node) -> void:
	super.configure(game)
	# Later rounds add targets to the existing learning environment, not a fresh view.
	for identity in game.session.question_targets.values():
		var center: String=game.session.physical_targets[identity].center_id
		if center not in centers:centers.append(center)
	centers.sort();layout_centers(centers)
