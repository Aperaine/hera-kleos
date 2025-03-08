extends Node2D

var area2d_node: Area2D

func _ready() -> void:
	area2d_node = $CheckPoint
	area2d_node.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	DataManager.ram["heracle_safe_pos"] = self.position
	print("new checkpoint: " + str(DataManager.ram["heracle_safe_pos"]))
