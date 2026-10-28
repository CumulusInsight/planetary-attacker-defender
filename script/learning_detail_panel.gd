extends Panel
## Scrollable teaching view; all commands delegate to the existing selection path.
var game: Node
var question: Dictionary={}
var historical:=false
var review_mode:=false
var title: Label
var prompt: Label
var body: RichTextLabel
var close_button: Button
var choices: Array=[]
var shade: ColorRect
var old_focus: WeakRef
var lesson_scroll: ScrollContainer
var attack_body: RichTextLabel
var preview_defense: Variant=null
func configure(owner: Node) -> void:
	game=owner;shade=ColorRect.new();shade.color=Color(0,0,0,0.82);game.place(game.shell,shade,Rect2(0,50,1600,850));shade.z_index=49
	game.place(game.shell,self,Rect2(100,75,1400,750));z_index=50
	title=game.label(self,Rect2(24,12,1200,32),22)
	game.label(self,Rect2(24,48,1350,22),15).text="EDITORIAL REVIEW BUILD — content awaits owner acceptance. Learning choices do not reveal private encounter truth."
	close_button=game.button(self,"CLOSE",Rect2(1262,10,114,34),dismiss)
	lesson_scroll=ScrollContainer.new();game.place(self,lesson_scroll,Rect2(24,80,1352,646));lesson_scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
	var column:=VBoxContainer.new();column.size_flags_horizontal=Control.SIZE_EXPAND_FILL;column.add_theme_constant_override("separation",18);lesson_scroll.add_child(column)
	attack_body=RichTextLabel.new();column.add_child(attack_body);prepare_text(attack_body)
	var question_heading:=RichTextLabel.new();column.add_child(question_heading);prepare_text(question_heading);question_heading.text="[b][u]Question[/u][/b]"
	prompt=Label.new();column.add_child(prompt);prompt.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;prompt.add_theme_font_size_override("font_size",22)
	var options_heading:=Label.new();options_heading.text="Answer Options";column.add_child(options_heading)
	var grid:=GridContainer.new();grid.columns=2;grid.add_theme_constant_override("h_separation",12);grid.add_theme_constant_override("v_separation",8);column.add_child(grid)
	for i in range(4):
		var control:=Button.new();grid.add_child(control);control.custom_minimum_size=Vector2(658,68);control.size_flags_horizontal=Control.SIZE_EXPAND_FILL;control.pressed.connect(func():choose(i))
		var info=preload("res://script/learning_action_icon.gd").new();info.kind="book";info.tooltip_text="Read this control without selecting";info.flat=true;info.position=Vector2(630,2);info.size=Vector2(30,28);control.add_child(info);info.pressed.connect(func():preview_choice(i))
		control.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;control.toggle_mode=true;choices.append(control)
	body=RichTextLabel.new();column.add_child(body);prepare_text(body)
	shade.hide();hide()
func prepare_text(control: RichTextLabel) -> void:
	control.bbcode_enabled=true;control.fit_content=true;control.scroll_active=false;control.selection_enabled=true;control.size_flags_horizontal=Control.SIZE_EXPAND_FILL
	control.add_theme_font_size_override("normal_font_size",20);control.add_theme_font_size_override("bold_font_size",21)
func safe(value: String) -> String:return value.replace("[","[lb]")
func section(heading: String,text: String) -> String:return "[b][u]"+safe(heading)+"[/u][/b]\n"+safe(text)+"\n\n"
func open_question(q: Dictionary,history: bool=false,review: bool=false) -> void:
	question=q;historical=history;review_mode=review;preview_defense=null
	var focus=get_viewport().gui_get_focus_owner();old_focus=weakref(focus) if focus!=null else null
	# GUI hit-testing follows sibling order, not just z_index; review is created later.
	shade.get_parent().move_child(shade,-1);get_parent().move_child(self,-1)
	shade.show();show();render_content();lesson_scroll.scroll_vertical=0;close_button.grab_focus()
func render_content() -> void:
	if question.is_empty():return
	var lesson: Dictionary=game.loader.rich_attacks[int(question.attack_id)]
	title.text="%s / C-%03d — %s" % [question.center_id,question.contact_id,lesson.display_name]
	prompt.text=lesson.question
	var rows: Array=game.session.public_rows(game.review_index if historical else -1)
	if review_mode:
		var result: Dictionary=game.review_model.results.get(question.learning_id,{})
		rows=[{"learning_id":question.learning_id,"selected":result.get("answer"),"answered":not result.is_empty(),"result":result}]
	var matches: Array=rows.filter(func(r):return r.learning_id==question.learning_id)
	if matches.is_empty():dismiss();return
	var row: Dictionary=matches[0];var selected: Variant=row.result.get("answer",row.selected)
	var submitted: bool=row.answered or (not historical and not review_mode and (game.session.is_pending(int(question.contact_id)) or game.session.flights.has(int(question.contact_id))))
	var evaluated: bool=row.answered
	for i in range(4):
		var id:=int(question.options[i]);var defense: Dictionary=game.loader.rich_defenses[id]
		choices[i].text=("This is the correct answer\n" if evaluated and id==int(lesson.correct_defense_id) else "Your incorrect answer\n" if evaluated and selected!=null and int(selected)==id else "")+defense.display_name;choices[i].set_pressed_no_signal(selected!=null and int(selected)==id)
		choices[i].disabled=historical or submitted or (not review_mode and game.session.submitted_questions.has(question.learning_id))
		choices[i].tooltip_text=defense.display_name+"\n"+defense.definition
		choices[i].add_theme_color_override("font_disabled_color",Color("9de3ac") if evaluated and id==int(lesson.correct_defense_id) else Color.WHITE)
		if evaluated:
			var style:=StyleBoxFlat.new();style.bg_color=Color("163b2b") if id==int(lesson.correct_defense_id) else Color("482d34") if selected!=null and int(selected)==id else Color("182632")
			if id==int(lesson.correct_defense_id):style.border_color=Color("64e692");style.set_border_width_all(2)
			choices[i].add_theme_stylebox_override("disabled",style)
		else:choices[i].remove_theme_stylebox_override("disabled")
	var attack_text:=section("Definition",lesson.definition)+section("Realistic Example",lesson.example)
	if attack_body.text!=attack_text:attack_body.text=attack_text
	var text:=""
	var shown: Variant=preview_defense if preview_defense!=null else selected
	if shown!=null:
		var defense: Dictionary=game.loader.rich_defenses[int(shown)]
		text+="[b]Defense lesson: "+safe(defense.display_name)+"[/b]\n\n"+section("Definition",defense.definition)+section("How It Works",defense.mechanism)+section("When It Applies",defense.conditions)+section("Limitations",defense.limitations)+section("Realistic Example",defense.example)
	else:text+=section("Choose a control", "Select one of the four controls above. You can read its complete mechanism and limitations before submitting through Report or D. No selection fires a missile.")
	if evaluated:
		if shown!=null and int(shown)!=int(lesson.correct_defense_id):text+=section("Why this offered option does not meet the scenario",lesson.distractor_reasoning)
		var correct: Dictionary=game.loader.rich_defenses[int(lesson.correct_defense_id)]
		text+=section("Answer reasoning — "+correct.display_name,lesson.explanation)+section("Why the other offered controls do not meet this scenario",lesson.distractor_reasoning)
		var mapped: Array=game.loader.rich_mappings.values().filter(func(r):return int(r.attack_id)==int(question.attack_id))
		for mapping in mapped:
			var d: Dictionary=game.loader.rich_defenses[int(mapping.defense_id)]
			text+=section("Catalog relationship: "+d.display_name+" / "+mapping.role+" / "+mapping.decision,mapping.applicability+"\nLimitation: "+mapping.limitations)
	else:text+=section("Reasoning after submission", "The designated answer and response reasoning remain hidden until submission/evaluation. Other valid mapped defenses were excluded from the incorrect options.")
	if lesson.kind not in ["attack","category"]:text+=section("Classification",str(lesson.kind).replace("_"," "))
	if body.text!=text:body.text=text
func choose(index: int) -> void:
	if historical:return
	if review_mode:
		game.review_panel.evaluate(question.learning_id,int(question.options[index]));render_content();return
	preview_defense=question.options[index];game.select_answer(int(question.contact_id),int(question.options[index]));render_content()
func preview_choice(index: int) -> void:
	preview_defense=question.options[index];render_content();call_deferred("show_defense")
func show_defense() -> void:
	# Allow wrapped text/container heights to settle before jumping to this defense.
	await get_tree().process_frame
	await get_tree().process_frame
	if visible:lesson_scroll.scroll_vertical=int(body.position.y)
func dismiss() -> void:
	hide();shade.hide()
	if old_focus!=null and is_instance_valid(old_focus.get_ref()):old_focus.get_ref().grab_focus()
func _input(event: InputEvent) -> void:
	if visible and event is InputEventKey and event.pressed and event.keycode==KEY_ESCAPE:
		dismiss();get_viewport().set_input_as_handled()
