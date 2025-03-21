extends Node2D

var area2d_node: Area2D

func _ready() -> void:
	area2d_node = $FlipHelper/Collider
	DataManager.ram["boss_health"] = 101
	print("Boss health set to:")
	print(DataManager.ram["boss_health"])
	$FlipHelper.scale.x = -1
	$AnimationPlayer.speed_scale = 0.6

func _process(delta: float) -> void:
	if DataManager.ram["boss_health"] > 100:
		$AnimationPlayer.speed_scale = 0.3
		$AnimationPlayer.play("Scream")
		await $AnimationPlayer.animation_finished
		DataManager.ram["boss_health"] = 100
	if 99 < DataManager.ram["boss_health"] and DataManager.ram["boss_health"] <= 100:
		$AnimationPlayer.speed_scale = 0.6
		$AnimationPlayer.play("Idle")
	elif 70 < DataManager.ram["boss_health"] and DataManager.ram["boss_health"] <= 99:
		$AnimationPlayer.play("Walk")
		position.x += 1
	elif 40 <DataManager.ram["boss_health"] and DataManager.ram["boss_health"] <= 70:
		$AnimationPlayer.play("Idle")
	elif 0 < DataManager.ram["boss_health"] and DataManager.ram["boss_health"] <= 40:
		pass
	else:
		$FlipHelper/Sprite.modulate.a = 0.5
