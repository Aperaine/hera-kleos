# hera.gd
extends Node2D

var hera_active: bool = true
var touching_heracle: bool = false
var collision_platform: CollisionShape2D
var collision_hummingbird: CollisionShape2D
var area_hummingbird: Area2D
var ability: DataManager.HeraAbility
var static_body: StaticBody2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	ability = DataManager.progress.selected_abilities[DataManager.Characters.HERA]
	static_body = $StaticBody2D
	static_body.collision_layer = 8
	collision_platform = $StaticBody2D/collision_platform
	collision_hummingbird = $Area2D/collision_hummingbird
	area_hummingbird = $Area2D
	area_hummingbird.monitoring = true
	area_hummingbird.collision_layer = 8

func _input(event):
	if event.is_action_pressed("hera-activate"):
		match ability:
			DataManager.HeraAbility.STATE_PLATFORM:
				hera_platform()
			DataManager.HeraAbility.STATE_SHIELD:
				hera_sheild()
			DataManager.HeraAbility.STATE_WEAPON:
				hera_weapon()
	if event.is_action_pressed("hera-toggle"):
		hera_active = true
		DataManager.switch_ability(DataManager.Characters.HERA)
		ability = DataManager.progress.selected_abilities[DataManager.Characters.HERA]

# Platform
func hera_platform():
	hera_active = false
	static_body.collision_layer = 1
	await get_tree().create_timer(1).timeout
	static_body.collision_layer = 8
	hera_active = true

# Shield
func hera_sheild():
	pass

# Weapon
func hera_weapon():
	if touching_heracle:
		hera_active = false
		if DataManager.progress.selected_abilities[DataManager.Characters.HERACLE] == DataManager.HeracleAbility.CLUB:
			print("Hera Enters the Club")

# Other
func collision_manager():
	collision_platform.disabled = true
	collision_hummingbird.disabled = true
	if hera_active:
		collision_hummingbird.disabled = false
	else:
		match ability:
			DataManager.HeraAbility.STATE_PLATFORM:
				collision_platform.disabled = false
			DataManager.HeraAbility.STATE_WEAPON:
				pass
			DataManager.HeraAbility.STATE_SHIELD:
				pass
			DataManager.HeraAbility.STATE_LEVELIO:
				pass

func _physics_process(_delta: float) -> void:
	collision_manager()
	if hera_active:
		position += (get_global_mouse_position() - position) / 5


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Heracle":
		touching_heracle = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Heracle":
		touching_heracle = false
