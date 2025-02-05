extends CharacterBody2D

# hello world

# This code is for you to edit Jafar, please feel free to edit everything here.
# Task:
# - Create a movable Hercules Character
# - Find a way to organize the hitboxes in the game (players, gates, enemies or whatever we'll need)
# - Create basic Hitbox for the scenery/gate/gate.tscn
# - Make a function to 'enter the gate', which only has to print "entering gate" when the player's 
#	hitbox is hitting the gate's hitbox and a certain button is pushed.

const SPEED := 550.0
const JUMP_VELOCITY := -2000.0
const ACCELERATION := 50.0
const FRICTION := 70.0
const GRAVITY := 120.0
const JUMP_LIMIT = 2
var jump_count = 1

func input() -> Vector2:
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("ui_left", "ui_right")
	input_dir = input_dir.normalized()
	return input_dir

func accelerate(direction):
	velocity = velocity.move_toward(SPEED * direction, ACCELERATION)

func friction():
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)

func player_movement():
	move_and_slide()

func jump():
	if Input.is_action_just_pressed("ui_up"):
		if jump_count < JUMP_LIMIT:
			velocity.y = JUMP_VELOCITY
			jump_count += 1
	else:
		velocity.y += GRAVITY
	
	if is_on_floor():
		jump_count = 1

func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = input()
	
	if input_dir != Vector2.ZERO:
		accelerate(input_dir)
	else:
		friction()
	
	player_movement()
	jump()
	
	#
	#
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
	#
	#for index in get_slide_collision_count():
		#var collision = get_slide_collision(index)
		#
	
