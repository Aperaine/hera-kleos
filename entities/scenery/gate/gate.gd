extends Node2D

@export var room: DataManager.ROOMS
@export var mark: Texture2D

var player_in_area = false
var can_transition = true
var area2d_node: Area2D

func _ready():
	add_to_group("gates")
	area2d_node = $Area2D
	var room_unlocked = false
	for room_num in DataManager.progress["unlocked_levels"]:
		if room_num == room:
			room_unlocked = true
	if room_unlocked:
		$Area2D/Gate.modulate.a = 1.0
	else:
		$Area2D/Gate.modulate.a = 0.7

func _process(_delta):
	var was_in_area = player_in_area
	player_in_area = false
	
	for body in area2d_node.get_overlapping_bodies():
		if body.name == "Heracle":
			player_in_area = true

			if not was_in_area:
				print("Player entered gate for room: ", DataManager.ROOMS.keys()[room])
			break

	if was_in_area and not player_in_area:
		print("Player exited gate for room: ", DataManager.ROOMS.keys()[room])
		can_transition = true


	if player_in_area and Input.is_action_just_pressed("ui_down") and can_transition:
		print("Unlocked levels: ", DataManager.progress["unlocked_levels"])
		print("Current room enum value: ", room)

		var room_unlocked = false
		for room_num in DataManager.progress["unlocked_levels"]:
			if room_num == room:
				room_unlocked = true
		if room_unlocked:
			can_transition = false
			print("Transitioning to room: ", DataManager.ROOMS.keys()[room])
			DataManager.change_scene(room)
		else:
			print("Room ", DataManager.ROOMS.keys()[room], " is locked!")
