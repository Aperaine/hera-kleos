extends Area2D

const ARROW_SPEED = 1200.0
const ARROW_GRAVITY = 1500.0
const MAX_FALL_SPEED = 2000.0

var velocity = Vector2.ZERO
var is_hera_controlled = false

func _ready():
	add_to_group("arrows")
	# Ensure the VisibleOnScreenNotifier2D signal is connected
	rotation = velocity.angle()

func initialize(direction: Vector2, hera_arrow: bool = false):
	is_hera_controlled = hera_arrow
	if !is_hera_controlled:
		velocity = direction.normalized() * ARROW_SPEED
	rotation = velocity.angle()

func _physics_process(delta):
	if is_hera_controlled:
		# Continuously update direction to follow mouse
		var target_pos = get_global_mouse_position()
		velocity = (target_pos - global_position).normalized() * ARROW_SPEED
		rotation = velocity.angle()
	else:
		# Heracle's arrows with gravity
		velocity.y += ARROW_GRAVITY * delta
		velocity.y = min(velocity.y, MAX_FALL_SPEED)
		rotation = velocity.angle()
	
	position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()  # Clean up arrow when it leaves the screen
