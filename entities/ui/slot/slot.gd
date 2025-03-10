extends Container

@export var slot_num: DataManager.SLOTS
@onready var name_input = $Display/New/NameInput
@onready var add_button = $Display/New/Add
@onready var name_label = $Display/Name

func _ready() -> void:
	if not name_input:
		push_error("NameInput node not found in path: " + str(get_path()))
		return
	
	update_data()
	add_button.hide()

func _on_play_pressed() -> void:
	DataManager.ram["slot"] = slot_num
	DataManager.load_game()
	DataManager.change_scene(DataManager.ROOMS.castle)

func _on_delete_pressed() -> void:
	DataManager.ram["slot"] = slot_num
	DataManager.delete_slot(slot_num)
	update_data()

func update_data() -> void:
	if DataManager.slot_exists(slot_num):
		get_node("Display/New").hide()
		get_node("Display/Play").show()
		get_node("Display/Delete").show()
		
		var data = DataManager.get_game_stats(slot_num)
		
		# Format time nicely
		var time = data["play_time"]
		var minutes = int(time / 60)
		var seconds = int(time) % 60
		var time_string = "%02d:%02d" % [minutes, seconds]
		get_node("Display/Time").text = time_string
		
		# Format death count
		get_node("Display/DeathHeracle").text = str(data["deaths_heracle"]) + " 🕺💀"
		get_node("Display/DeathHera").text = str(data["deaths_hera"]) + " 🪽💀"
		
		get_node("Display/Time").show()
		get_node("Display/DeathHeracle").show()
		get_node("Display/DeathHera").show()
		
		var slot_name = DataManager.get_slot_name(slot_num)
		name_label.text = slot_name
		name_label.show()
	else:
		get_node("Display/New").show()
		get_node("Display/Play").hide()
		get_node("Display/Delete").hide()
		get_node("Display/DeathHeracle").hide()
		get_node("Display/DeathHera").hide()
		get_node("Display/Time").hide()
		name_label.hide()

func _on_add_pressed() -> void:
	if name_input.text.length() > 0:
		DataManager.ram["slot"] = slot_num
		DataManager.game_stats["name"] = name_input.text
		DataManager.reset_game()
		DataManager.save_game()
		name_input.text = ""
		update_data()

func _on_name_input_text_changed(new_text: String) -> void:
	add_button.visible = new_text.length() > 0
