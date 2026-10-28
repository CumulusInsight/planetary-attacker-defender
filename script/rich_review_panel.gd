extends "res://script/missed_question_review_panel.gd"
func configure(owner: Node,review: RefCounted) -> void:
	super.configure(owner,review);box.hide()
	for child in get_children():
		if child is ScrollContainer:child.size.y=470
	for index in range(model.questions.size()):
		var q: Dictionary=model.questions[index];var attack: Button=grid.get_child(8+index*8+2)
		attack.text=game.loader.rich_attacks[int(q.attack_id)].display_name;attack.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;attack.add_theme_font_size_override("font_size",16)
		for j in range(8):grid.get_child(8+index*8+j).custom_minimum_size.y=80
		attack.pressed.connect(func():game.detail_panel.open_question(q,false,true))
func explain(control: Button,title: String,_text: String) -> void:
	control.tooltip_text=title+" — select a question to read its full lesson."
func explain_result(identity: String) -> void:
	if model.results.has(identity):cells[identity].tooltip_text="Review evaluated. Click the attack to read the full explanation."
func evaluate(identity: String,defense: int) -> void:
	if not model.evaluate(identity,defense):return
	refresh()
	var q: Dictionary=model.questions.filter(func(r):return r.learning_id==identity)[0]
	game.detail_panel.open_question(q,false,true)
