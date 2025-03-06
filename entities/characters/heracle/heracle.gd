extends CharacterBody2D

# Exported Variables
@export var arrow_scene: PackedScene = preload("res://entities/scenery/arrow/arrow.tscn")
@export var SPEED: float = 100.0
@export var attacking: bool = false

# Onready Variables
@onready var jumpheight: Timer = $Jumpheight
@onready var timer: Timer = $Timer
@onready var coyote: Timer = $Coyote
@onready var animation: AnimationPlayer = $FlipHelper/AnimationPlayer
@onready var sprite: Sprite2D = $FlipHelper/Sprite2D
@onready var flip_helper: Node2D = $FlipHelper
@onready var hitbox: CollisionShape2D = $Hitbox
@onready var hitbox_attack: Area2D = $HitboxAttack

# Constants
const MAX_SPEED := 600.0
const JUMP_VELOCITY: float = -2200.0
const FRICTION: float = 70.0
const GRAVITY: float = 200.0
const MAX_GRAVITY: float = 3000.0
const JUMP_LIMIT: int = 1

# State Variables
var coyote_flag: int = 0
var jump_buffer: int = 0
var jump_count: int = 0
var last_direction: Vector2 = Vector2.RIGHT

# Main physics process
func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = get_input_direction()
	if not attacking:
		move_character(input_dir)
		apply_gravity()
		handle_jump()
		move_and_slide()
		update_animation()
	
	if Input.is_action_just_pressed("heracle-toggle"):
		DataManager.switch_ability(DataManager.Characters.HERACLE)
	
	if Input.is_action_just_pressed("heracle-attack"):
		var ability = DataManager.progress.selected_abilities[DataManager.Characters.HERACLE]
		match ability:
			DataManager.HeracleAbility.EMPTY:
				animation.play("Punch")
			DataManager.HeracleAbility.CLUB:
				pass
			DataManager.HeracleAbility.SWORD:
				pass
			DataManager.HeracleAbility.BOW: 
				shoot_arrow()

# Get input direction
func get_input_direction() -> Vector2:
	return Vector2(Input.get_axis("heracle-left", "heracle-right"), Input.get_axis("ui_up", "ui_down"))

# Move character
func move_character(direction: Vector2) -> void:
	if direction.x != 0:
		if velocity.x < MAX_SPEED and direction.x > 0:
			velocity.x += SPEED
		if velocity.x > MAX_SPEED * -1 and direction.x < 0:
			velocity.x -= SPEED
		last_direction.x = direction.x
		flip_visuals(direction.x < 0)  # Flip sprite properly
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)

# Flip sprite while keeping collider in place
func flip_visuals(face_left: bool) -> void:
	flip_helper.scale.x = -1 if face_left else 1
	hitbox.scale.x = -1 if face_left else 1
	hitbox_attack.scale.x = -1 if face_left else 1

# Apply gravity
func apply_gravity() -> void:
	if not is_on_floor() and velocity.y < MAX_GRAVITY:
		velocity.y += GRAVITY

# Handle jump logic
func handle_jump() -> void:
	if (Input.is_action_just_pressed("heracle-jump") and jump_count < JUMP_LIMIT) or (jump_buffer == 1 and is_on_floor()):
		velocity.y = JUMP_VELOCITY
		jumpheight.start()
		jump_count = 1

	if not is_on_floor() and jump_count == 0 and coyote_flag == 0:
		coyote_flag = 1
		coyote.start()

	if Input.is_action_just_pressed("heracle-jump") and jump_count > 0:
		jump_buffer = 1
		timer.start()

	if Input.is_action_just_released("heracle-jump"):
		jump_buffer = 0

	if is_on_floor() and velocity.y >= 0:
		coyote_flag = 0
		jump_count = 0

# Update animation based on state
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

# Timer handlers
func _on_jumpheight_timeout() -> void:
	pass

func _on_timer_timeout() -> void:
	jump_buffer = 0

func _on_coyote_timeout() -> void:
	jump_count = 1

# Get shooting direction
func get_shoot_direction() -> Vector2:
	var shoot_dir: Vector2 = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	return shoot_dir if shoot_dir != Vector2.ZERO else last_direction.normalized()

# Shoot an arrow
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
