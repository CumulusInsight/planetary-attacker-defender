extends Panel
var game: Node
var model: RefCounted
var grid: GridContainer
var description: Label
var box: Panel
var summary: Label
var buttons: Dictionary={}
var cells: Dictionary={}
var hovered: Button
var finish_button: Button
func configure(owner: Node,review: RefCounted) -> void:
	game=owner;model=review;game.place(game.shell,self,Rect2(20,170,1560,660));z_index=30
	game.label(self,Rect2(18,12,1250,30),20).text="MISSED-QUESTION REVIEW / NO MISSILES"
	game.button(self,"Close",Rect2(1452,10,90,32),game.finish_review)
	var line:=HSeparator.new();game.place(self,line,Rect2(18,50,1524,4))
	summary=game.label(self,Rect2(18,62,1524,44),17)
	var scroll:=ScrollContainer.new();game.place(self,scroll,Rect2(18,112,1524,260));scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
	grid=GridContainer.new();grid.columns=8;grid.add_theme_constant_override("h_separation",8);grid.add_theme_constant_override("v_separation",8);scroll.add_child(grid)
	var widths: Array=[108,88,158,224,224,224,224,120]
	for i in range(8):
		var title:=Label.new();title.text=["DATA CENTER","CONTACT","SUSPECTED ATTACK","OPTION 1","OPTION 2","OPTION 3","OPTION 4","RESULT"][i];title.custom_minimum_size=Vector2(widths[i],26);title.add_theme_font_size_override("font_size",14);grid.add_child(title)
	for q in model.questions:
		var identity: String=q.learning_id
		for text in [q.center_id,"C-%03d" % int(q.contact_id)]:
			var value:=Label.new();value.text=text;value.custom_minimum_size.y=48;value.add_theme_font_size_override("font_size",18);grid.add_child(value)
		var attack:=Button.new();attack.flat=true;attack.text=model.attacks[int(q.attack_id)].attack_name;attack.add_theme_font_size_override("font_size",18);grid.add_child(attack)
		attack.mouse_entered.connect(func():explain(attack,attack.text,model.attacks[int(q.attack_id)].definition));attack.mouse_exited.connect(func():clear_description(attack));attack.pressed.connect(func():explain(attack,attack.text,model.attacks[int(q.attack_id)].definition))
		var options: Array=[]
		for id in q.options:
			var defense: int=int(id);var control:=Button.new();control.text=model.defenses[defense].defense_name;control.custom_minimum_size=Vector2(224,48);control.add_theme_font_size_override("font_size",18);control.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;control.toggle_mode=true
			control.mouse_entered.connect(func():explain(control,control.text,game.command.decision_pages.words(model.defenses[defense].definition,23)));control.mouse_exited.connect(func():clear_description(control))
			control.pressed.connect(func():evaluate(identity,defense));grid.add_child(control);options.append(control)
		buttons[identity]=options
		var result:=Button.new();result.flat=true;result.add_theme_font_size_override("font_size",15);grid.add_child(result);cells[identity]=result
		result.pressed.connect(func():explain_result(identity));result.mouse_entered.connect(func():explain_result(identity));result.mouse_exited.connect(func():clear_description())
	box=Panel.new();game.place(self,box,Rect2(18,388,1524,200));var style:=StyleBoxFlat.new();style.bg_color=Color("111a25");style.border_color=Color("ff4848");style.set_border_width_all(3);box.add_theme_stylebox_override("panel",style)
	description=game.label(box,Rect2(14,10,1496,180),34);description.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;box.hide()
	finish_button=game.button(self,"FINISH REVIEW",Rect2(1190,600,352,40),game.finish_review);refresh()
func explain(control: Button,title: String,text: String) -> void:
	hovered=control;description.text=title+"\n"+(text if not text.is_empty() else "No description available in the current catalog.");box.show()
func clear_description(control: Button=null) -> void:
	if control!=null and control!=hovered:return
	hovered=null;box.hide();description.text=""
func evaluate(identity: String,defense: int) -> void:
	if not model.evaluate(identity,defense):return
	refresh();explain_result(identity)
func explain_result(identity: String) -> void:
	if not model.results.has(identity):return
	var q: Dictionary=model.questions.filter(func(item):return item.learning_id==identity)[0]
	var purpose: String=game.command.decision_pages.words(model.defenses[int(q.correct_defense_id)].definition,23)
	description.text=("Correct - " if model.results[identity].correct else "Incorrect - ")+"Correct countermeasure: "+model.results[identity].correct_name+"\n"+purpose;box.show()
func refresh() -> void:
	var p: Dictionary=model.performance();var score: Dictionary=model.original_score
	summary.text="Original score: %d correct / %d incorrect (%.0f%%)\nReviewed %d/%d | Corrected %d | Still incorrect %d | Unreviewed %d" % [score.correct,score.incorrect,score.percentage,p.reviewed,p.total,p.corrected,p.still_incorrect,p.remaining]
	for q in model.questions:
		var identity: String=q.learning_id;var result: Dictionary=model.results.get(identity,{})
		for i in range(4):
			var b: Button=buttons[identity][i];b.disabled=not result.is_empty();b.set_pressed_no_signal(not result.is_empty() and int(q.options[i])==int(result.answer))
			if b.button_pressed:
				var style:=StyleBoxFlat.new();style.bg_color=Color("234438") if result.correct else Color("482d34");b.add_theme_stylebox_override("disabled",style);b.add_theme_color_override("font_disabled_color",Color.WHITE)
		var cell: Button=cells[identity];cell.text="NOT REVIEWED" if result.is_empty() else "CORRECT" if result.correct else "INCORRECT"
		cell.add_theme_color_override("font_color",Color.WHITE if result.is_empty() else Color("9de3ac") if result.correct else Color("ff9898"))
		cell.tooltip_text="Choose a countermeasure first." if result.is_empty() else "Correct countermeasure: "+result.correct_name
