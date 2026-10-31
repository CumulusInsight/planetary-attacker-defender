extends OptionButton
## One center selector. Other command functions live in a separate destination menu.
var game: Node
func configure(owner_game: Node) -> void:
	game=owner_game;name="CommandNavigation";fit_to_longest_item=false;clip_text=true
	add_item("Tactical Group Overview - all six");set_item_metadata(0,{"route":"orbital"})
	for center in preload("res://script/orbital_command_context.gd").CENTERS:
		add_item(center);set_item_metadata(item_count-1,{"route":"center","center":center})
	add_theme_font_override("font",ThemeDB.fallback_font);add_theme_font_size_override("font_size",16)
	get_popup().add_theme_font_override("font",ThemeDB.fallback_font);get_popup().add_theme_font_size_override("font_size",18)
	item_selected.connect(func(index):dispatch(get_item_metadata(index)))
	tooltip_text="Tactical Group Commander / six-center learning mission. Legacy actors exist only for DC-01 through DC-03."
func dispatch(route: Dictionary) -> void:
	if route.route=="center":game.select_group_center(route.center)
	else:game.open_orbital_view()
