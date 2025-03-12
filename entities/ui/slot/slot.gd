extends Control

@export var slot_num: DataManager.SLOTS
@onready var empty_container = $Empty
@onready var created_container = $Created
@onready var name_input = $Empty/NameInput
@onready var add_button = $Empty/Add
@onready var name_label = $Created/Info/Name

func _ready() -> void:
	empty_container.hide()
	created_container.hide()
	add_button.hide()
	update_data()

func update_data() -> void:
	if DataManager.slot_exists(slot_num):
		empty_container.hide()
		created_container.show()
		
		var data = DataManager.get_game_stats(slot_num)
		
		var time = data["play_time"]
		var minutes = int(time / 60)
		var seconds = int(time) % 60
		var time_string = "%02d:%02d" % [minutes, seconds]
		get_node("Created/Info/Stats/Time").text = time_string
		
		get_node("Created/Info/Stats/DeathHeracle").text = str(data["deaths_heracle"])
		get_node("Created/Info/Stats/DeathHera").text = str(data["deaths_hera"])
		
		var slot_name = DataManager.get_slot_name(slot_num)
		name_label.text = slot_name
	else:
		empty_container.show()
		created_container.hide()

func _on_play_pressed() -> void:
	DataManager.ram["slot"] = slot_num
	DataManager.load_game()
	DataManager.change_scene(DataManager.ROOMS.castle)

func _on_delete_pressed() -> void:
	DataManager.ram["slot"] = slot_num
	DataManager.delete_slot(slot_num)
	update_data()

func _on_name_input_text_changed(new_text: String) -> void:
	if new_text.length() > 0:
		add_button.visible = true
	else:
		add_button.visible = false

func _on_add_pressed() -> void:
	if name_input.text.length() > 0:
		DataManager.ram["slot"] = slot_num
		DataManager.game_stats["name"] = name_input.text
		DataManager.reset_game()
		DataManager.save_game()
		name_input.text = ""
		update_data()

func button_add_visibility():
	if name_input.text.length() > 0:
		DataManager.ram["slot"] = slot_num
		DataManager.game_stats["name"] = name_input.text
		DataManager.reset_game()
		DataManager.save_game()
		name_input.text = ""
		update_data()
