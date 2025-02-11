extends Node2D

@onready var arrow_body = $RigidBody2D

var arrow_speed = 500
var direction = Vector2.ZERO
var has_been_shot = false

func _ready():
	arrow_body.gravity_scale = 0

func _physics_process(delta):
	if !has_been_shot:
		# Get direction to mouse
		direction = (get_global_mouse_position() - global_position).normalized()
		 # Rotate arrow to face movement direction
		rotation = direction.angle()
		 # Move arrow
		position += direction * arrow_speed * delta
		
		# Optional: If you want the arrow to be destroyed when it goes off screen
		if position.x < -1000 or position.x > 1000 or position.y < -1000 or position.y > 1000:
			queue_free()

func shoot():
	has_been_shot = true
	# Lock in the current direction when shot
	direction = (get_global_mouse_position() - global_position)
