extends Node2D

@export var hera_safe_pos: Vector2 = Vector2(150, 150)

func _ready() -> void:
	DataManager.ram["hera_safe_pos"] = hera_safe_pos
