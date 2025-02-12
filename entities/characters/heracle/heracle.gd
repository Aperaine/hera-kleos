extends CharacterBody2D

@export var arrow_scene: PackedScene
var arrow_speed = 500
var shoot_direction = Vector2.ZERO

const SPEED := 550.0
const JUMP_VELOCITY := -2000.0
const ACCELERATION := 25.0
const FRICTION := 70.0
const GRAVITY := 200.0
const JUMP_LIMIT := 1 
var jump_count := 0

func _ready() -> void:
	pass

# Player movement input (Left / Right)
func input() -> Vector2:
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("ui_left", "ui_right")
	input_dir = input_dir.normalized()
	return input_dir

# Accelerate player movement in the input direction
func accelerate(direction):
	velocity = velocity.move_toward(Vector2(SPEED * direction.x, velocity.y), ACCELERATION)

# Apply friction to slow down the player when no input is given
func friction():
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)

# Handles the movement of the player (with collision)
func player_movement():
	move_and_slide()  # No need to specify the up vector anymore

# Jump logic: Only allow jumping if on the floor and under the jump limit
func jump():
	# Check if jump button is pressed and jump limit hasn't been reached
	if Input.is_action_just_pressed("ui_up") and jump_count < JUMP_LIMIT:
		velocity.y = JUMP_VELOCITY  # Apply jump velocity
		jump_count += 1  # Increment jump count when jumping

	# Apply gravity when in the air
	if not is_on_floor():
		velocity.y += GRAVITY

	# Reset jump count when on the floor
	if is_on_floor():
		jump_count = 0  # Reset jump count to allow jumping again

# Main physics process where movement and jumps are updated
func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = input()
	
	# Handle player movement: accelerate if input is given, apply friction if not
	if input_dir != Vector2.ZERO:
		accelerate(input_dir)
	else:
		friction()
	
	player_movement()  # Move the player with collision handling
	jump()  # Handle jumping
		
	if Input.is_action_just_pressed("shoot"):
		shoot_arrow()

func shoot_arrow():
	var arrow = arrow_scene.instantiate()
	add_child(arrow)
	arrow.launch(Vector2(500 , -5000))
