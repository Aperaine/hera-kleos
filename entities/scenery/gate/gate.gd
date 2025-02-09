extends Node2D

@export var room: SceneManager.ROOMS = SceneManager.ROOMS.castle
@export var mark: Texture2D

var unlocked: bool = false
var player_in_area = false
var area2d_node

func _ready():
	area2d_node = $Area2D
	area2d_node.connect("body_entered", Callable(self, "_on_Gate_body_entered"))
	area2d_node.connect("body_exited", Callable(self, "_on_Gate_body_exited"))
	if room in DataManager.progress.unlocked_levels:
		unlocked = true

func _on_Gate_body_entered(body):
	if body.name == "Heracle":
		player_in_area = true
		print("Player has entered the gate area")

func _on_Gate_body_exited(body):
	if body.name == "Heracle":
		player_in_area = false
		print("Player has exited the gate area")

func _process(delta):
	if player_in_area and Input.is_action_just_pressed("ui_down") and unlocked:
		SceneManager.change_scene(room)
		print("Player pressed down while in the gate area")
