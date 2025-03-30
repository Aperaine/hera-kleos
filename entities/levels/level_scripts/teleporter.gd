extends Node

@export var teleport_to: DataManager.ROOMS
var area2d_node: Area2D

func _ready():
	add_to_group("gates")
	area2d_node = $Area2D
	$ColorRect.modulate.a = 0.0

func _process(_delta):
	for body in area2d_node.get_overlapping_bodies():
		if body.name == "Heracle":
			DataManager.change_scene(teleport_to)
