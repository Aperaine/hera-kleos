extends Node2D
var touching_heracle: bool = false
var collision_platform: CollisionShape2D
var collision_hummingbird: CollisionShape2D
var ability: DataManager.HeraAbility
var area2d_node: Area2D
var static_body: StaticBody2D
var hera_bow: bool = false
var animation_free: bool = true
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
var able_to_move = true
var last_direction = false
var hera_mouse_pos: Vector2
var prev_mouse_pos: Vector2
var collision_normal: Vector2 = Vector2.ZERO
var stuck_time: float = 0.0
var is_stuck: bool = false

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if DataManager.progress.selected_abilities[DataManager.Characters.HERA]:
		ability = DataManager.progress.selected_abilities[DataManager.Characters.HERA]
	static_body = $StaticBody2D
	area2d_node = $Area2D
	static_body.collision_layer = 8
	collision_platform = $StaticBody2D/collision_platform
	collision_hummingbird = $Area2D/collision_hummingbird
	prev_mouse_pos = get_global_mouse_position()

func _input(event):
	if event.is_action_pressed("hera-activate"):
		match ability:
			DataManager.HeraAbility.STATE_PLATFORM:
				hera_platform()
			DataManager.HeraAbility.STATE_WEAPON:
				hera_weapon()
	if event.is_action_pressed("hera-toggle"):
		DataManager.ram["hera_active"] = true
		DataManager.switch_ability(DataManager.Characters.HERA)
		ability = DataManager.progress.selected_abilities[DataManager.Characters.HERA]

func hera_platform():
	DataManager.ram["hera_active"] = false
	static_body.collision_layer = 1
	await get_tree().create_timer(2).timeout
	static_body.collision_layer = 8
	DataManager.ram["hera_active"] = true

func hera_weapon():
	var heracle_ability = DataManager.progress["selected_abilities"][DataManager.Characters.HERACLE]
	match heracle_ability:
		DataManager.HeracleAbility.CLUB:
			if touching_heracle:
				DataManager.ram["hera_active"] = false
				print("Hera Enters the Club")
		DataManager.HeracleAbility.SWORD:
			if touching_heracle:
				DataManager.ram["hera_active"] = false
				print("Hera Enters the Sword")
		DataManager.HeracleAbility.BOW:
			hera_bow = true

func collision_manager():
	collision_platform.disabled = true
	collision_hummingbird.disabled = true
	if DataManager.ram["hera_active"]:
		collision_hummingbird.disabled = false
		play_animations("idle")
		animation_free = true
	else:
		match ability:
			DataManager.HeraAbility.STATE_PLATFORM:
				collision_platform.disabled = false
				play_animations("platform")
				animation_free = false
			DataManager.HeraAbility.STATE_WEAPON:
				pass
			DataManager.HeraAbility.STATE_LEVELIO:
				pass

func play_animations(animation_name):
	if animation_free:
		animation.play(animation_name)

func movement():
	if animation_free:
		if hera_mouse_pos.x < position.x:
			last_direction = false
			sprite.flip_h = true
		else:
			last_direction = true
			sprite.flip_h = false
	
	if DataManager.ram["hera_active"]:
		var mouse_direction = (hera_mouse_pos - position).normalized()
		var prev_mouse_direction = (prev_mouse_pos - position).normalized()
		
		# When not able to move, check if mouse direction has changed significantly
		if not able_to_move:
			# Increment stuck timer
			stuck_time += 0.016  # Assuming 60 FPS
			
			# After being stuck for a short time
			if stuck_time > 0.5:
				is_stuck = true
				
				# Check if mouse is now moving away from obstacle
				var dot_product = mouse_direction.dot(collision_normal)
				
				# If mouse is moving away from obstacle or significantly changed direction
				if dot_product > 0 or mouse_direction.dot(prev_mouse_direction) < 0.7:
					# Help Hera escape
					position += collision_normal * 5
					able_to_move = true
					is_stuck = false
					stuck_time = 0.0
		else:
			stuck_time = 0.0
			is_stuck = false
			position += (hera_mouse_pos - position) / 10
	
	prev_mouse_pos = hera_mouse_pos

func collision_check():
	var was_colliding = not able_to_move
	able_to_move = true
	collision_normal = Vector2.ZERO
	
	for body in area2d_node.get_overlapping_bodies():
		if body.name == "Heracle":
			touching_heracle = true
			print("touching Heracle")
		
		if body.name == "Obstacle Hera":
			able_to_move = false
			print("Obstacle detected!")
			
			# Calculate collision normal (direction to push away from obstacle)
			collision_normal = (position - body.position).normalized()
			
			# If we just started colliding, reset stuck timer
			if not was_colliding:
				stuck_time = 0.0
				is_stuck = false

func _physics_process(_delta: float) -> void:
	hera_mouse_pos = get_global_mouse_position()
	collision_manager()
	collision_check()
	movement()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Heracle":
		touching_heracle = false
	if body.name == "Obstacle Hera":
		is_stuck = false
		stuck_time = 0.0
