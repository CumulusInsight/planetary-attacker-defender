extends ColorRect
signal confirmed
var text: Label
var ok: Button
var dialog_text := "":
	set(value):
		dialog_text=value
		if text!=null: text.text=value
func _ready() -> void:
	color=Color(0.01,0.02,0.03,0.97)
	size=Vector2(1600,900)
	var panel:=Panel.new()
	add_child(panel)
	panel.position=Vector2(300,210)
	panel.size=Vector2(1000,480)
	text=Label.new()
	text.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	text.add_theme_font_size_override("font_size",20)
	panel.add_child(text)
	text.position=Vector2(28,24)
	text.size=Vector2(944,340)
	ok=Button.new()
	ok.text="Confirm existing action"
	panel.add_child(ok)
	ok.position=Vector2(28,402)
	ok.size=Vector2(450,44)
	ok.pressed.connect(func(): hide(); confirmed.emit())
	var cancel:=Button.new()
	cancel.text="Cancel / continue monitoring"
	panel.add_child(cancel)
	cancel.position=Vector2(522,402)
	cancel.size=Vector2(450,44)
	cancel.pressed.connect(hide)
	hide()
func get_ok_button() -> Button: return ok
func popup_centered() -> void:
	text.text=dialog_text
	show()
