# lava_rain.gd
extends Node2D

enum lava_type {
	thick,
	medium,
	thin,
}

@export var spawn_interval: float = 0.2
@export var lava_thickness: lava_type = lava_type.medium
@export var droplet_fall_speed: float = 500

var droplet_scene_thick = preload("res://entities/scenery/lava_rain/lava_droplet_thick.tscn")
var droplet_scene_medium = preload("res://entities/scenery/lava_rain/lava_droplet_medium.tscn")
var droplet_scene_thin = preload("res://entities/scenery/lava_rain/lava_droplet_thin.tscn")
var timer: Timer
var z_index_counter: int = 0

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = spawn_interval
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout() -> void:
	spawn_droplet()

func spawn_droplet() -> void:
	var droplet
	match lava_thickness:
		lava_type.thick:
			droplet = droplet_scene_thick.instantiate()
		lava_type.medium:
			droplet = droplet_scene_medium.instantiate()
		lava_type.thin:
			droplet = droplet_scene_thin.instantiate()
	
	droplet.fall_speed = droplet_fall_speed
	add_child(droplet)
