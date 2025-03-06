extends Node

func _ready() -> void:
	DataManager.ram["camera_pos"] = DataManager.ram["camera_default"]

func _process(delta: float) -> void:
	self.position = DataManager.ram["camera_pos"]
