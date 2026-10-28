extends "res://script/missed_question_review_panel.gd"
func configure(owner: Node,review: RefCounted) -> void:
	super.configure(owner,review);box.hide()
	for child in get_children():
		if child is ScrollContainer:child.size.y=470
	for i in range(3,7):grid.get_child(i).text="ANSWER OPTION %d" % (i-2)
	for index in range(model.questions.size()):
		var q: Dictionary=model.questions[index];var attack: Button=grid.get_child(8+index*8+2)
		attack.text=game.loader.rich_attacks[int(q.attack_id)].display_name;attack.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;attack.add_theme_font_size_override("font_size",16)
		for j in range(8):grid.get_child(8+index*8+j).custom_minimum_size.y=80
		attack.pressed.connect(func():game.detail_panel.open_question(q,false,true))
		for i in range(4):game.AnswerControls.install(game,q,buttons[q.learning_id][i],int(q.options[i]),true)
	refresh()
func explain(control: Button,title: String,_text: String) -> void:
	control.tooltip_text=title+" — select a question to read its full lesson."
func explain_result(identity: String) -> void:
	if model.results.has(identity):cells[identity].tooltip_text="Review evaluated. Click the attack to read the full explanation."
func evaluate(identity: String,defense: int) -> void:
	if not model.evaluate(identity,defense):return
	refresh()
	var q: Dictionary=model.questions.filter(func(r):return r.learning_id==identity)[0]
	# Selection/evaluation does not open a lesson; each info button remains independent.

func refresh() -> void:
	super.refresh()
	for q in model.questions:
		var result: Dictionary=model.results.get(q.learning_id,{})
		for i in range(4):game.AnswerControls.update(buttons[q.learning_id][i],not result.is_empty() and int(result.answer)==int(q.options[i]),not result.is_empty(),not result.is_empty(),int(q.options[i])==int(q.correct_defense_id))
