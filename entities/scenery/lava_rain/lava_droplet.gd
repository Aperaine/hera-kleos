extends Area2D

var fall_speed: float = 500
var active: bool = true

func _physics_process(delta: float) -> void:
	if active: 
		position.y += fall_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Heracle":
		DataManager.game_stats["deaths_heracle"] += 1
		DataManager.ram["heracle_dead"] = true
		queue_free()
	if body.collision_layer & 1:
		active = false
		await get_tree().create_timer(0.2).timeout
		queue_free()
