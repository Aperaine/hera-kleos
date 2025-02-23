extends Container

@export var slot_num: DataManager.SLOTS

func _ready() -> void:
	update_data()

func _process(delta: float) -> void:
	pass

func _on_play_pressed() -> void:
	DataManager.ram["slot"] = slot_num
	DataManager.change_scene(DataManager.ROOMS.castle)
	update_data()

func _on_delete_pressed() -> void:
	DataManager.ram["slot"] = slot_num
	DataManager.reset_game()
	update_data()

func update_data():
	var data = DataManager.get_game_stats(slot_num)
	get_node("HBoxContainer/Time").text = str(data["play_time"]) + "s"
	get_node("HBoxContainer/Death").text = str(data["deaths"]) + "💀"
