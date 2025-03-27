extends Node2D

var area2d_node: Area2D
var segment: int

func _ready() -> void:
	area2d_node = $FlipHelper/Collider
	DataManager.ram["boss_health"] = 101
	print("Boss health set to:")
	print(DataManager.ram["boss_health"])
	$FlipHelper.scale.x = -1
	$AnimationPlayer.speed_scale = 0.6

func _process(delta: float) -> void:
	if DataManager.ram["boss_health"] > 100:
		$AnimationPlayer.play("Scream", -1.0, 0.2)
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("Idle", -1.0, 1)
		await get_tree().create_timer(1).timeout
		$AnimationPlayer.stop()
		DataManager.ram["boss_health"] = 100
		segment = 1
	elif 70 < DataManager.ram["boss_health"] and DataManager.ram["boss_health"] <= 100:
		if segment == 1:
			if not $AnimationPlayer.is_playing():
				$AnimationPlayer.play("Walk")
			position.x -= 10
			if position.x <= -655:
				$AnimationPlayer.play("Idle")
				await get_tree().create_timer(0.5).timeout
				$FlipHelper.scale.x = 1
				await get_tree().create_timer(0.5).timeout
				$AnimationPlayer.stop()
				segment = 2
		elif segment == 2:
			$AnimationPlayer.play("Walk")
			position.x += 10
	elif 40 <DataManager.ram["boss_health"] and DataManager.ram["boss_health"] <= 70:
		$AnimationPlayer.play("Idle")
	elif 0 < DataManager.ram["boss_health"] and DataManager.ram["boss_health"] <= 40:
		pass
	else:
		$FlipHelper/Sprite.modulate.a = 0.5
