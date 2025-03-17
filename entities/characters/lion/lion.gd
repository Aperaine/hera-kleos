extends Node2D

var area2d_node: Area2D

func _ready() -> void:
	area2d_node = $FlipHelper/Collider
	DataManager.ram["boss_health"] = 100
	print("Boss health set to:")
	print(DataManager.ram["boss_health"])
	$FlipHelper.scale.x = -1

func _process(delta: float) -> void:
	if DataManager.ram["boss_health"] < 0:
		$FlipHelper/Sprite.modulate.a = 0.5
