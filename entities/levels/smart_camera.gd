extends Node

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	self.position = DataManager.ram["camera_pos"]
