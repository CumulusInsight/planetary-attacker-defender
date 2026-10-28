extends Panel
var game: Node
var shade: ColorRect
var cards: Array=[]
const PLANS=[
	{"attack_id":77,"exposure":"Untrusted executable content"},
	{"attack_id":64,"exposure":"Reachable software services"},
	{"attack_id":59,"exposure":"File-access and recovery readiness"},
	{"attack_id":2,"exposure":"Privileged software trust"},
	{"attack_id":78,"exposure":"Public-service availability"},
	{"attack_id":83,"exposure":"Message and identity verification"}]
var back_button: Button
var attack_picker: OptionButton
var target_checks: Dictionary={}
var planned_attacks: Dictionary={}
var details: Panel
var detail_text: RichTextLabel
var detail_center:=""
var detail_buttons: Dictionary={}
var overview_button: Button
func configure(owner: Node) -> void:
	game=owner;shade=ColorRect.new();shade.color=Color(0.01,0.01,0.02,0.94);game.place(game.shell,shade,Rect2(0,50,1600,850));shade.z_index=59
	game.place(game.shell,self,Rect2(20,76,1560,754));z_index=60
	game.label(self,Rect2(20,14,1100,36),24).text="MARTIAN WAR ROOM / PLANNING MOCKUP"
	back_button=game.button(self,"EARTH DEFENSE COMMAND",Rect2(1176,12,364,36),close_room)
	game.label(self,Rect2(20,60,1520,44),18).text="Perceived intelligence, not confirmed facts. Catalog-backed planning concepts only. No attacks or operational orders are executed."
	for i in range(6):
		var box:=Panel.new();game.place(self,box,Rect2(20+(i%3)*510,112+(i/3 as int)*242,500,230))
		var label: Label=game.label(box,Rect2(14,12,472,208),18);label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;cards.append(label)
	build_planning_controls()
	shade.hide();hide()
func open_room() -> void:
	refresh_cards()
	details.hide()
	shade.get_parent().move_child(shade,-1);get_parent().move_child(self,-1);shade.show();show()
func refresh_cards() -> void:
	for i in range(6):
		var center: String="DC-%02d" % (i+1);var plan: Dictionary=PLANS[i]
		var lesson: Dictionary=game.loader.rich_attacks[int(planned_attacks.get(center,plan.attack_id))]
		cards[i].tooltip_text=lesson.definition
		cards[i].add_theme_font_override("font",ThemeDB.fallback_font);cards[i].add_theme_font_size_override("font_size",16);cards[i].add_theme_constant_override("line_spacing",0)
		var exposure: String=plan.exposure if int(planned_attacks.get(center,plan.attack_id))==int(plan.attack_id) else "Not established; reconnaissance required"
		cards[i].text=center+"\n\nHypothetical exposure: "+exposure+"\nUNCONFIRMED / no evidence collected\nPlanned attack: "+lesson.display_name+"\nTarget: "+center+" (proposed)\nStatus: DRAFT / NO ORDERS ISSUED"

func build_planning_controls() -> void:
	attack_picker=OptionButton.new();game.place(self,attack_picker,Rect2(20,606,640,34));attack_picker.add_theme_font_override("font",ThemeDB.fallback_font);attack_picker.add_theme_font_size_override("font_size",17)
	var ids: Array=game.loader.attacks.keys();ids.sort()
	for id in ids:
		attack_picker.add_item("%03d / %s" % [id,game.loader.rich_attacks[id].display_name]);attack_picker.set_item_metadata(attack_picker.item_count-1,id)
		attack_picker.set_item_tooltip(attack_picker.item_count-1,game.loader.attacks[id].attack_name+" / "+game.loader.rich_attacks[id].definition)
	game.button(self,"APPLY PLAN TO SELECTED",Rect2(678,606,420,34),apply_plan)
	game.button(self,"SELECT ALL SIX",Rect2(1116,606,424,34),select_all)
	for i in range(6):
		var center: String="DC-%02d" % (i+1);var check:=CheckButton.new();check.text=center;game.place(self,check,Rect2(20+i*250,650,230,34));target_checks[center]=check
		detail_buttons[center]=game.button(cards[i].get_parent(),"DETAILS",Rect2(348,5,146,28),func():target_checks[center].button_pressed=true;open_details(center))
	game.label(self,Rect2(20,696,1520,42),16).text="Planning only / no attack execution. Select centers and a catalog attack, then APPLY PLAN. DETAILS inspects one center."
	details=Panel.new();game.place(self,details,Rect2(12,106,1536,636))
	game.label(details,Rect2(18,10,1000,32),23).text="INDIVIDUAL DATA CENTER / PLANNING DETAILS"
	overview_button=game.button(details,"BACK TO OVERVIEW",Rect2(1170,10,344,34),func():details.hide())
	detail_text=RichTextLabel.new();game.place(details,detail_text,Rect2(22,60,1490,552));detail_text.bbcode_enabled=true;detail_text.selection_enabled=true;detail_text.add_theme_font_override("normal_font",ThemeDB.fallback_font);detail_text.add_theme_font_size_override("normal_font_size",21);details.hide()
func selected_centers() -> Array:
	var result: Array=[]
	for center in target_checks:
		if target_checks[center].button_pressed:result.append(center)
	result.sort();return result
func select_all() -> void:
	for check in target_checks.values():check.button_pressed=true
func apply_plan() -> void:
	if attack_picker.selected<0:return
	var id: int=attack_picker.get_item_metadata(attack_picker.selected)
	for center in selected_centers():planned_attacks[center]=id
	refresh_cards()
func open_details(center: String) -> void:
	if not target_checks.has(center) or not target_checks[center].button_pressed:return
	detail_center=center
	var index: int=int(center.right(2))-1;var id: int=planned_attacks.get(center,PLANS[index].attack_id)
	var attack: Dictionary=game.loader.attacks[id]
	var lesson: Dictionary=game.loader.rich_attacks[id]
	detail_text.text="[b]Selected attack:[/b] %s / canonical ID %d\n[b]Target data center:[/b] %s\n\n[b]Perceived vulnerability:[/b] UNCONFIRMED. Attack prerequisites and exposure have not been established.\n\n[b]Catalog description:[/b]\n%s\n\n[b]Reconnaissance questions (not results):[/b]\nIs the relevant service, user workflow or trust boundary present?\nWhat evidence would establish the attack prerequisites?\nWhich protective controls would need to be verified?\n\n[b]Proposed cyberattack approach:[/b] Consider %s only if reconnaissance establishes its prerequisites. No execution is authorized.\n\n[b]Planning status:[/b] DRAFT / EVIDENCE REQUIRED / NO ORDERS ISSUED\n[b]Proposed timing:[/b] NOT SCHEDULED" % [lesson.display_name+" (catalog: "+attack.attack_name+")",id,center,lesson.definition,lesson.display_name]
	detail_text.text+="\n\n[b]Original catalog note:[/b] "+attack.definition
	detail_text.scroll_to_line(0);details.show()
func close_room() -> void:hide();shade.hide()
func _input(event: InputEvent) -> void:
	if visible and event is InputEventKey and event.pressed and event.keycode==KEY_ESCAPE:
		if details.visible:details.hide()
		else:close_room()
		get_viewport().set_input_as_handled()
