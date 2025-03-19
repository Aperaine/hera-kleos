extends Node2D

enum MovementStyle {
	sin,
	linear,
}

enum MovementDirection {
	horizontal,
	vertical,
}

enum ContainerShape {
	Brick,
	Stick,
	Brick_Stand,
}

@export var speed: float = 1.0
@export var distance: float = 500
@export var movement: MovementStyle
@export var movement_direction: MovementDirection = MovementDirection.horizontal
@export var shape: ContainerShape = ContainerShape.Brick
@export var damages_heracles: bool = true
@export var damages_hera: bool = false

var start_position: Vector2 

func _ready() -> void:
	start_position = position
	if damages_hera:
		if (shape == ContainerShape.Brick) or (shape == ContainerShape.Brick_Stand):
			$"Obstacle Hera/Horizontal".disabled = false
			$"Obstacle Hera/Vertical".disabled = true
		else:
			$"Obstacle Hera/Horizontal".disabled = false
			$"Obstacle Hera/Vertical".disabled = true
	else:
		$"Obstacle Hera/Horizontal".disabled = true
		$"Obstacle Hera/Vertical".disabled = true
	if damages_heracles:
		if shape == ContainerShape.Brick:
			$"Obstacle Heracle/Horizontal".disabled = false
			$"Obstacle Heracle/Vertical".disabled = true
			$"Obstacle Heracle/HolderLeft".disabled = true
			$"Obstacle Heracle/HolderRight".disabled = true
		elif shape == ContainerShape.Stick:
			$"Obstacle Heracle/Horizontal".disabled = true
			$"Obstacle Heracle/Vertical".disabled = false
			$"Obstacle Heracle/HolderLeft".disabled = true
			$"Obstacle Heracle/HolderRight".disabled = true
		elif shape == ContainerShape.Brick_Stand:
			$"Obstacle Heracle/Horizontal".disabled = false
			$"Obstacle Heracle/Vertical".disabled = true
			$"Obstacle Heracle/HolderLeft".disabled = false
			$"Obstacle Heracle/HolderRight".disabled = false
	else:
		$"Obstacle Heracle/Horizontal".disabled = true
		$"Obstacle Heracle/Vertical".disabled = true
		$"Obstacle Heracle/HolderLeft".disabled = true
		$"Obstacle Heracle/HolderRight".disabled = true

func _process(delta: float) -> void:
	var t = Time.get_ticks_msec() / 1000.0 * speed
	
	var offset := 0.0

	if movement == MovementStyle.sin:
		offset = sin(t * PI * 2) * (distance / 2)
	elif movement == MovementStyle.linear:
		offset = pingpong(t * distance, distance) - (distance / 2)
	
	if movement_direction == MovementDirection.horizontal:
		position.x = start_position.x + offset
	else:
		position.y = start_position.y + offset
