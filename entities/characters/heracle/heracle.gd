extends CharacterBody2D

# Exported Variables
@export var arrow_scene: PackedScene = preload("res://entities/scenery/arrow/arrow.tscn")
@export var SPEED: float = 550.0

# Onready variables
@onready var timer: Timer = $Timer
@onready var coyote: Timer = $Coyote
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

# Constants
const JUMP_VELOCITY: float = -2000.0
const FRICTION: float = 70.0
const GRAVITY: float = 200.0
const MAX_GRAVITY: float = 3000.0
const JUMP_LIMIT: int = 1

# State Variables
var coyote_flag: int = 0
var jump_buffer: int = 0
var jump_count: int = 0
var last_direction: Vector2 = Vector2.RIGHT

# Input handling for ability toggle
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("heracle-toggle"):
		DataManager.switch_ability(DataManager.Characters.HERACLE)
		if DataManager.progress["selected_abilities"][DataManager.Characters.HERACLE] == DataManager.HeracleAbility.BOW:
			DataManager.ram["hera_active"] = true

# Main physics process
func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = get_input_direction()
	move_character(input_dir)
	apply_gravity()
	handle_jump()
	move_and_slide()
	update_animation()
	# Arrow shooting
	if Input.is_action_just_pressed("shoot") and DataManager.progress.selected_abilities[DataManager.Characters.HERACLE] == DataManager.HeracleAbility.BOW:
		shoot_arrow()

# Get the input direction for movement
func get_input_direction() -> Vector2:
	return Vector2(Input.get_axis("heracle-left", "heracle-right"), Input.get_axis("ui_up", "ui_down"))

# Handle character movement
func move_character(direction: Vector2) -> void:
	if direction.x != 0:
		velocity.x = SPEED * direction.x
		last_direction.x = direction.x
		sprite.flip_h = direction.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)

# Apply gravity to the character
func apply_gravity() -> void:
	if not is_on_floor() and velocity.y < MAX_GRAVITY:
		velocity.y += GRAVITY

# Handle jump logic
func handle_jump() -> void:
	# Jump trigger
	if (Input.is_action_just_pressed("heracle-jump") and jump_count < JUMP_LIMIT) or (jump_buffer == 1 and is_on_floor()):
		velocity.y = JUMP_VELOCITY
		jump_count = 1

	# Coyote time logic
	if not is_on_floor() and jump_count == 0 and coyote_flag == 0:
		coyote_flag = 1
		coyote.start()

	# Jump buffer logic
	if Input.is_action_just_pressed("heracle-jump") and jump_count > 0:
		jump_buffer = 1
		timer.start()

	if Input.is_action_just_released("heracle-jump"):
		jump_buffer = 0

	# Reset jump when landing
	if is_on_floor() and velocity.y >= 0:
		coyote_flag = 0
		jump_count = 0

# Update the animation based on movement state
func update_animation() -> void:
	if not is_on_floor():
		if abs(velocity.x) > 0:
			animation.play("RunJump")
		else:
			animation.play("IdleJump")
	else:
		if abs(velocity.x) > 0:
			animation.play("Run")
		else:
			animation.play("Idle")

# Timer timeout for jump buffer
func _on_timer_timeout() -> void:
	jump_buffer = 0

# Coyote timeout for jump count reset
func _on_coyote_timeout() -> void:
	jump_count = 1

# Get the shooting direction based on input
func get_shoot_direction() -> Vector2:
	var shoot_dir: Vector2 = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	return shoot_dir if shoot_dir != Vector2.ZERO else last_direction.normalized()

# Shoot an arrow in the given direction
func shoot_arrow() -> void:
	if DataManager.ram["arrows"] <= 0:
		return

	var arrow = arrow_scene.instantiate()
	DataManager.ram["arrows"] -= 1
	get_tree().current_scene.add_child(arrow)
	arrow.global_position = global_position

	var shoot_dir: Vector2 = get_shoot_direction()
	var is_hera_arrow: bool = (DataManager.progress.selected_abilities[DataManager.Characters.HERA] == DataManager.HeraAbility.STATE_WEAPON)
	arrow.initialize(shoot_dir, is_hera_arrow)
