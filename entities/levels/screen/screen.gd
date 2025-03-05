extends Node2D

var area2d_node: Area2D

func _ready() -> void:
	area2d_node = $Area2D
	area2d_node.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Heracle":
		if self.position != DataManager.ram["camera_pos"]:
			DataManager.ram["camera_pos"] = self.position
			DataManager.hera_safe_pos()
