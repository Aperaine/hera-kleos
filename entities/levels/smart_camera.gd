extends Node

func _process(delta: float) -> void:
	self.position = DataManager.ram["camera_pos"]
