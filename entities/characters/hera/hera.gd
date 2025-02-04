# hera.gd
extends Node2D

var hera_active: bool = true
var current_ability: int = 0

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("hera-activate"):
		hera_active = false
	if event.is_action_pressed("hera-toggle"):
		DataManager.switch_ability(DataManager.Characters.HERA)

func _physics_process(_delta: float) -> void:
	if hera_active:
		position += (get_global_mouse_position() - position) / 5 # Follows the mouse with delay.
