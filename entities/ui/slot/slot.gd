extends Container

@export var slot_num: DataManager.SLOTS

func _ready() -> void:
	get_node("HBoxContainer/Time").text = str(DataManager.game_stats["play_time"]) + "s"
	get_node("HBoxContainer/Death").text = str(DataManager.game_stats["deaths"]) + "💀"


func _process(delta: float) -> void:
	pass

func _on_play_pressed() -> void:
	DataManager.ram["slot"] = slot_num
	DataManager.change_scene(DataManager.ROOMS.castle)

func _on_delete_pressed() -> void:
	DataManager.ram["slot"] = slot_num
	DataManager.reset_game()
