extends Node2D

@export var spawn_interval: float = .2
var droplet_scene = preload("res://entities/scenery/lava_rain/lava_droplet.tscn")
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
	var droplet = droplet_scene.instantiate()
	add_child(droplet)
