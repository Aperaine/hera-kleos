extends Node2D

var area2d_node: Area2D

func _ready() -> void:
	area2d_node = $Area2D 

func _process(delta: float) -> void:
	for body in area2d_node.get_overlapping_bodies():
		if (body.name == "Heracle") and (self.position != DataManager.ram["camera_pos"]):
			DataManager.ram["camera_pos"] = self.position
			DataManager.hera_safe_pos()
