extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_menu_pressed() -> void:
	pass # Replace with function body.

func _on_continue_pressed() -> void:
	pass # Replace with function body.-

func _on_castle_pressed() -> void:
	DataManager.save_game()
	DataManager.change_scene(DataManager.ROOMS.castle)

func _on_home_pressed() -> void:
	DataManager.save_game()
	DataManager.change_scene(DataManager.ROOMS.home)
