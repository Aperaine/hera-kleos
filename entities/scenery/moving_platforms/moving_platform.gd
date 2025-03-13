extends Node2D

enum MovementStyle {
	sin,
	linear,
}

@export var speed: float = 1.0
@export var distance: float = 500
@export var movement: MovementStyle
#@export var is_jumpable: bool = false

var start_position: Vector2 

func _ready() -> void:
	start_position = position

func _process(delta: float) -> void:
	var t = Time.get_ticks_msec() / 1000.0 * speed
	
	var offset := 0.0

	if movement == MovementStyle.sin:
		offset = sin(t * PI * 2) * (distance / 2)
	elif movement == MovementStyle.linear:
		offset = pingpong(t * distance, distance) - (distance / 2)
	
	#if is_jumpable:
		#pass
	#else:
		#pass
	
	position.x = start_position.x + offset
