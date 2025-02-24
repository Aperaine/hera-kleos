extends Node2D

var menu_hidden = true
@export var button_menu: Button
@export var button_continue: Button
@export var button_castle: Button
@export var button_home: Button

func _ready() -> void:
	button_menu = $UI/Other/Menu
	button_continue = $UI/Other/Continue
	button_castle = $UI/Other/Castle
	button_home = $UI/Other/Home
	update_buttons_visibility()

func update_buttons_visibility() -> void:
	button_continue.visible = not menu_hidden
	button_castle.visible = not menu_hidden
	button_home.visible = not menu_hidden

func _on_menu_pressed() -> void:
	menu_hidden = !menu_hidden
	update_buttons_visibility()

func _on_continue_pressed() -> void:
	menu_hidden = !menu_hidden
	update_buttons_visibility()

func _on_castle_pressed() -> void:
	DataManager.save_game()
	DataManager.change_scene(DataManager.ROOMS.castle)

func _on_home_pressed() -> void:
	DataManager.save_game()
	DataManager.change_scene(DataManager.ROOMS.home)
