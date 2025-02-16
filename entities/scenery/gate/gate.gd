extends Node2D

@export var room: DataManager.ROOMS = DataManager.ROOMS.castle
@export var mark: Texture2D

var player_in_area = false
var can_transition = true
var area2d_node: Area2D

func _ready():
	add_to_group("gates")
	area2d_node = $Area2D

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
		if room in DataManager.progress.unlocked_levels:
			can_transition = false
			print("Transitioning to room: ", DataManager.ROOMS.keys()[room])
			DataManager.change_scene(room)
		else:
			print("Room ", DataManager.ROOMS.keys()[room], " is locked!")
