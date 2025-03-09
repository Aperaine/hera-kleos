extends Node2D

func _on_damage_collider_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Heracle":
		DataManager.game_stats["deaths"] += 1
		print("damage!")
		DataManager.ram["heracle_dead"] = true
