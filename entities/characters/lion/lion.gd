extends Node2D

enum attack_patterns {
	IDLE,
	SCREAM,
	WALK,
	ROCKS,
	DASH,
}

var area2d_node: Area2D
var segment: int
var lion_ram = { # these values are all random; adjust whatever you need Jafar
	left_boundary = 0,
	right_boundary = 1920,
	init_pos = Vector2(500,500),
	jump_locations = [Vector2(500,500), Vector2(200,200)] # maybe there'll be two locations into which he's jumping?
}

func _ready() -> void:
	area2d_node = $FlipHelper/Collider
	DataManager.ram["boss_health"] = 101
	print("Boss health set to:")
	print(DataManager.ram["boss_health"])
	$FlipHelper.scale.x = -1
	$AnimationPlayer.speed_scale = 0.6

func _process(delta: float) -> void:
	handle_phases()

func handle_phases():
	var health = DataManager.ram["boss_health"]
	if health in range(70,100):
		phase1()
	elif health in range(40,69):
		phase2()
	elif health in range(1,39):
		phase3()
	elif health <= 0:
		phased()

# battle phases
func stage0():
	scream()

func phase1():
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
	
func phase2():
	$AnimationPlayer.play("Idle")

func phase3():
	pass

func phased():
	$FlipHelper/Sprite.modulate.a = 0.5

# attack patterns
func attack_idle():
	pass

func idle():
	pass

func scream():
	$AnimationPlayer.play("Scream", -1.0, 0.2)
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("Idle", -1.0, 1)
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.stop()
	DataManager.ram["boss_health"] = 100
	segment = 1

func walk():
	pass

func rocks():
	var rock_prefab = preload("res://entities/characters/lion/falling_rock.tscn")
	var one_rock = rock_prefab.instance()
	one_rock.position = Vector2(400, 300)
	get_parent().add_child(one_rock)

func jump():
	pass

func dash():
	pass
