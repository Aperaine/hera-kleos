extends Node2D

var player_is_in_area = false
var player_was_in_area = false
var area2d_node: Area2D
@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	area2d_node = $Area2D

func _process(delta: float) -> void:
	player_is_in_area = false
	for body in area2d_node.get_overlapping_bodies():
		if body.name == "Heracle":
			player_is_in_area = true
			if not player_was_in_area and player_is_in_area: # player entered the king
				animation.play("angry")
	
	if player_was_in_area and not player_is_in_area: # player left the king
		animation.play("surprised")
	player_was_in_area = player_is_in_area
