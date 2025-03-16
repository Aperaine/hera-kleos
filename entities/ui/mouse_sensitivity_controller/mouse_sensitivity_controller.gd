extends Node2D

@export var on: bool = true
var speed_limit: int = 6000

var speed = 0

func _ready():
	pass

func _physics_process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if not DataManager.ram["game_paused"]:
		if event is InputEventMouseMotion:
			speed = Input.get_last_mouse_velocity()
			speed = sqrt(speed.x**2 + speed.y**2)
		if speed > speed_limit:
			DataManager.ram["hera_too_fast"] = true
