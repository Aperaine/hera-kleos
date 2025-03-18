extends CharacterBody2D

@export var arrow_scene: PackedScene = preload("res://entities/scenery/arrow/arrow.tscn")
@export var SPEED: float = 100.0
@export var attacking: bool = false

@onready var jumpheight: Timer = $Jumpheight
@onready var timer: Timer = $Timer
@onready var coyote: Timer = $Coyote
@onready var animation: AnimationPlayer = $FlipHelper/AnimationPlayer
@onready var sprite: Sprite2D = $FlipHelper/Sprite2D
@onready var flip_helper: Node2D = $FlipHelper
@onready var hitbox: CollisionShape2D = $Hitbox
@onready var hitbox_damage: Area2D = $FlipHelper/HitboxDamage
@onready var hitbox_attack: Area2D = $HitboxAttack

const MAX_SPEED := 600.0
const JUMP_VELOCITY: float = -2200.0
const FRICTION: float = 70.0
const GRAVITY: float = 190.0
const MAX_GRAVITY: float = 3000.0
const JUMP_LIMIT: int = 1
const damage_cooldown = 100

var coyote_flag: int = 0
var jump_buffer: int = 0
var jump_count: int = 0
var last_direction: Vector2 = Vector2.RIGHT
var just_got_damage_counter = 0
var just_got_damage: bool = false

func _ready():
	pass

func _physics_process(delta: float) -> void:
	if not DataManager.ram["game_paused"]:
		var input_dir: Vector2 = get_input_direction()
		if not attacking:
			apply_gravity()
			move_and_slide()
			move_character(input_dir)
			handle_jump()
			update_animation()
			handle_death()
		
		collision_manager()
		damage_manager()
		
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

func collision_manager():
	for body in hitbox_attack.get_overlapping_areas():
		if body.collision_layer & 10:
			DataManager.ram["boss_health"] -= 1
			print(DataManager.ram["boss_health"])
	for body in hitbox_damage.get_overlapping_areas():
		if body.collision_layer & 10 and (not just_got_damage):
			DataManager.ram["heracle_hearts"] -= 1
			just_got_damage = true
			sprite.modulate.a = 0.5

func damage_manager():
	if just_got_damage == true:
		if just_got_damage_counter > damage_cooldown:
			just_got_damage = false
			just_got_damage_counter = 0
			sprite.modulate.a = 1.0
		else:
			just_got_damage_counter += 1

func get_input_direction() -> Vector2:
	return Vector2(Input.get_axis("heracle-left", "heracle-right"), Input.get_axis("ui_up", "ui_down"))

func move_character(direction: Vector2) -> void:
	if is_on_floor() and test_move(global_transform, Vector2(0, -4)):
		position.y -= 4
	if direction.x != 0:
		if velocity.x < MAX_SPEED and direction.x > 0:
			velocity.x += SPEED
		if velocity.x > MAX_SPEED * -1 and direction.x < 0:
			velocity.x -= SPEED
		last_direction.x = direction.x
		flip_visuals(direction.x < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)

func flip_visuals(face_left: bool) -> void:
	flip_helper.scale.x = -1 if face_left else 1
	hitbox_attack.scale.x = -1 if face_left else 1
	var offset = hitbox.position.x
	if face_left:
		hitbox.position.x = -abs(offset)
	else:
		hitbox.position.x = abs(offset)

func apply_gravity() -> void:
	if not is_on_floor() and velocity.y < MAX_GRAVITY:
		velocity.y += GRAVITY

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

func _on_jumpheight_timeout() -> void:
	pass

func _on_timer_timeout() -> void:
	jump_buffer = 0

func _on_coyote_timeout() -> void:
	jump_count = 1

func get_shoot_direction() -> Vector2:
	var shoot_dir: Vector2 = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	return shoot_dir if shoot_dir != Vector2.ZERO else last_direction.normalized()

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

func handle_death() -> void:
	if DataManager.ram["heracle_dead"] == true:
		DataManager.ram["heracle_dead"] = false
		heracle_restart()
		attacking = true
		await get_tree().create_timer(0.1).timeout 
		attacking = false

func heracle_restart() -> void:
	position = DataManager.ram["heracle_safe_pos"]
