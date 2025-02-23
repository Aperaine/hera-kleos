extends Node2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	DataManager.game_stats["play_time"] += delta
