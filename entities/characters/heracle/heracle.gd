extends CharacterBody2D

@export var arrow_scene: PackedScene = preload("res://entities/scenery/arrow/arrow.tscn")
@export var SPEED := 550.0

@onready var timer: Timer = $Timer

const JUMP_VELOCITY := -2000.0
const FRICTION := 70.0
const GRAVITY := 200.0
const JUMP_LIMIT := 1

var jump_buffer := 0
var jump_count := 0
var last_direction = Vector2.RIGHT

func input() -> Vector2:
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("heracle-left", "heracle-right")
	input_dir.y = Input.get_axis("ui_up", "ui_down")
	return input_dir

func _input(event):
	if event.is_action_pressed("heracle-toggle"):
		DataManager.switch_ability(DataManager.Characters.HERACLE)
		if DataManager.progress["selected_abilities"][DataManager.Characters.HERACLE] == DataManager.HeracleAbility.BOW:
			DataManager.ram["hera_active"] = true

func move_character(direction):
	if direction.x != 0:
		velocity.x = SPEED * direction.x
		last_direction.x = direction.x  # Update last direction
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)

func apply_gravity():
	if not is_on_floor():
		velocity.y += GRAVITY

func jump():
	if (Input.is_action_just_pressed("heracle-jump") and jump_count < JUMP_LIMIT) or (jump_buffer == 1 and is_on_floor()):
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		
	#jump buffering
	if Input.is_action_just_pressed("heracle-jump") and jump_count > 0:
		jump_buffer = 1
		timer.start()
		
	if Input.is_action_just_released("heracle-jump"):
		jump_buffer = 0
	
	if is_on_floor() and velocity.y >= 0:
		jump_count = 0
		
func _on_timer_timeout() -> void:
	jump_buffer = 0

func get_shoot_direction() -> Vector2:
	# Get input direction for shooting
	var shoot_dir = Vector2.ZERO
	shoot_dir.x = Input.get_axis("ui_left", "ui_right")
	shoot_dir.y = Input.get_axis("ui_up", "ui_down")
	
	# If no direction pressed, use last movement direction
	if shoot_dir == Vector2.ZERO:
		shoot_dir = last_direction
	
	return shoot_dir.normalized()

func _physics_process(delta):
	var input_dir = input()
	move_character(input_dir)
	apply_gravity()
	jump()
	move_and_slide()
	
	# Handle shooting
	if Input.is_action_just_pressed("shoot") and DataManager.progress.selected_abilities[DataManager.Characters.HERACLE] == DataManager.HeracleAbility.BOW:# and DataManager.ram["hera_active"] == true:
		shoot_arrow()

func shoot_arrow():
	if DataManager.ram["arrows"] <= 0:
		return  # Don't shoot if no arrows left
		
	var arrow = arrow_scene.instantiate()
	DataManager.ram["arrows"] -= 1
	get_tree().current_scene.add_child(arrow)
	arrow.global_position = global_position
	
	var shoot_dir = get_shoot_direction()
	var is_hera_arrow = (DataManager.progress.selected_abilities[DataManager.Characters.HERA] == DataManager.HeraAbility.STATE_WEAPON)
	arrow.initialize(shoot_dir, is_hera_arrow)
