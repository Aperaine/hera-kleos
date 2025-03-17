extends Node2D

var area2d_node: Area2D
var health: int = 100

func _ready() -> void:
	area2d_node = $Collider

func _process(delta: float) -> void:
	for body in area2d_node.get_overlapping_bodies():
		if body.collision_layer & 7:
			DataManager.ram["heracle_hearts"] -= 1
			print("touched heracle")
		elif body.collision_layer & 9:
			health -= 10
			print("health:")
			print(health)
