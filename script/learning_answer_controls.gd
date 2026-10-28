extends RefCounted
static func install(game: Node,q: Dictionary,control: Button,defense: int,review: bool=false) -> void:
	if control.has_node("AnswerInfo"):return
	var choose=preload("res://script/learning_action_icon.gd").new();choose.name="AnswerCheck";choose.kind="check";choose.tooltip_text="Select this answer";choose.flat=true
	game.place(control,choose,Rect2(2,2,30,28));choose.pressed.connect(func():
		if review:game.review_panel.evaluate(q.learning_id,defense)
		else:game.select_answer(int(q.contact_id),defense))
	var info=preload("res://script/learning_action_icon.gd").new();info.name="AnswerInfo";info.kind="book";info.tooltip_text="Read this answer's complete lesson; does not select or submit";info.flat=true;info.add_theme_font_size_override("font_size",18)
	game.place(control,info,Rect2(192,2,30,28));info.pressed.connect(func():game.open_answer_lesson(q,defense,review))
	var tag:=Label.new();tag.name="CorrectDesignator";tag.text="This is the correct answer";tag.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;tag.add_theme_font_override("font",ThemeDB.fallback_font);tag.add_theme_font_size_override("font_size",12);tag.add_theme_color_override("font_color",Color("9de3ac"));tag.mouse_filter=Control.MOUSE_FILTER_IGNORE
	game.place(control,tag,Rect2(32,1,160,18));tag.hide()
static func update(control: Button,selected: bool,locked: bool,evaluated: bool,correct: bool) -> void:
	if not control.has_node("AnswerInfo"):return
	var choose: Button=control.get_node("AnswerCheck");choose.disabled=locked;choose.selected_answer=selected;choose.queue_redraw()
	control.get_node("AnswerInfo").disabled=false
	var tag: Label=control.get_node("CorrectDesignator")
	tag.visible=evaluated and (correct or selected)
	tag.text="This is the correct answer" if correct else "Your incorrect answer"
	tag.add_theme_color_override("font_color",Color("9de3ac") if correct else Color("ff9898"))
	if evaluated and correct:
		var style:=StyleBoxFlat.new();style.bg_color=Color("163b2b");style.border_color=Color("64e692");style.set_border_width_all(2);control.add_theme_stylebox_override("disabled",style)
