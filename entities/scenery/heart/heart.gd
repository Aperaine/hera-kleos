extends Control

@export var heart_num: int

func _physics_process(delta: float) -> void:
	if DataManager.ram["heracle_hearts"] < heart_num:
		$TextureRect.modulate.a = 0.5
	else:
		$TextureRect.modulate.a = 1.0
