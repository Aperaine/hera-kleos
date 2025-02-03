# hera.gd
extends Node2D

var hera_active: bool = true
var current_ability: int = 0

func _ready():
	# Ensure DataManager is properly set up as an autoload
	if DataManager:
		DataManager.unlock_ability(Enums.Characters.HERA, Enums.HeraAbility.STATE_WEAPON)

func _input(event):
	if event.is_action_pressed("hera-activate"):
		hera_active = false
	if event.is_action_pressed("hera-toggle"):
		switch_ability()

func _physics_process(delta: float) -> void:
	if hera_active:
		position += (get_global_mouse_position() - position) / 5 # Follows the mouse with delay.

func switch_ability():
	var unlocked = DataManager.unlocked_abilities[Enums.Characters.HERA]
	if not unlocked.is_empty():
		current_ability = (current_ability + 1) % unlocked.size()
		print("Switched to ability: ", unlocked[current_ability])
