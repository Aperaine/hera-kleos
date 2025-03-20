extends Node2D

var area2d_node: Area2D

func _ready() -> void:
	area2d_node = $FlipHelper/Collider
	DataManager.ram["boss_health"] = 100
	print("Boss health set to:")
	print(DataManager.ram["boss_health"])
	$FlipHelper.scale.x = -1

func _process(delta: float) -> void:
	if 99 < DataManager.ram["boss_health"] and DataManager.ram["boss_health"] <= 100:
		$AnimationPlayer.play("Scream")
	elif 90 < DataManager.ram["boss_health"] and DataManager.ram["boss_health"] <= 99:
		$AnimationPlayer.play("Walk")
		position.x += 10
	elif 40 <DataManager.ram["boss_health"] and DataManager.ram["boss_health"] <= 90:
		$AnimationPlayer.play("Idle")
	elif 0 < DataManager.ram["boss_health"] and DataManager.ram["boss_health"] <= 40:
		pass
	else:
		$FlipHelper/Sprite.modulate.a = 0.5
