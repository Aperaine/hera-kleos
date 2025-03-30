extends Node

@export var teleport_to: DataManager.ROOMS
@export var unlock: DataManager.ROOMS
var area2d_node: Area2D
var sound_file = "res://sounds/music/city_choir.mp3"

func _ready():
	add_to_group("gates")
	area2d_node = $Area2D
	$ColorRect.modulate.a = 0.0

func _process(_delta):
	for body in area2d_node.get_overlapping_bodies():
		if body.name == "Heracle":
			DataManager.unlock_level(unlock)
			teleport()

func teleport():
	await get_tree().process_frame

	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 1.0, 1.5)
	await tween.finished

	await DataManager.change_scene(teleport_to)
