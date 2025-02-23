extends Node2D

@export var ability_hera: DataManager.HeraAbility
@export var ability_heracle: DataManager.HeracleAbility
@export var icon: Texture2D
var area2d_node: Area2D
var player_in_area = false

func _ready() -> void:
	add_to_group("gates")
	area2d_node = $Area2D

func _process(delta: float) -> void:
	player_in_area = false
	for body in area2d_node.get_overlapping_bodies():
		if body.name == "Heracle":
			print("Power-up taken!")
			player_in_area = true
			if ability_hera:
				DataManager.unlock_ability(DataManager.Characters.HERA, ability_hera)
			if ability_heracle:
				DataManager.unlock_ability(DataManager.Characters.HERACLE, ability_heracle)
			queue_free()
