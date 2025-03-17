extends Node2D

var area2d_node: Area2D

func _ready() -> void:
	area2d_node = $Screen
	area2d_node.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Heracle" and DataManager.ram["hera_at_level_end"]:
		if self.position != DataManager.ram["camera_pos"]:
			DataManager.ram["camera_pos"] = self.position
			DataManager.ram["hera_dead"] = true
