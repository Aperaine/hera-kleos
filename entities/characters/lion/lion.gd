extends Node2D

enum attack_patterns {
	IDLE,
	SCREAM,
	WALK,
	ROCKS,
	DASH,
}

var area2d_node: Area2D
var stage: int = 1
const left_boundary = -655
const right_boundary = 712
const init_pos = Vector2(500,500)
var moving = false
const speed = 10

func _ready() -> void:
	area2d_node = $FlipHelper/Collider
	DataManager.ram["boss_health"] = 101
	print("Boss health set to:")
	print(DataManager.ram["boss_health"])
	$FlipHelper.scale.x = -1
	#dumb_process()

func dumb_process():
	scream()
	walk("right")
	walk("left")

func _process(delta: float) -> void:
	handle_phases()

func handle_phases():
	if not moving:
		var health = DataManager.ram["boss_health"]
		if health in range(70,101):
			phase1()
		elif health in range(40,70):
			phase2()
		elif health in range(1,40):
			phase3()
		elif health <= 0:
			phased()

# battle phases
func stage0():
	scream()

func phase1():
	if stage == 1:
		scream()
		stage += 1
	elif stage == 2:
		walk("right")
		stage += 1

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
	moving = true
	$AnimationPlayer.play("Scream", -1.0, 0.2)
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("Idle", -1.0, 1)
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.stop()
	moving = false

func walk(direction):
	if direction == "right":
		$FlipHelper.scale.x = -1
		moving = true
		$FlipHelper/Body/Head1.disabled = true
		$FlipHelper/Body/Head2.disabled = true
		$AnimationPlayer.play("Walk", -1, 0.7)
		while position.x > left_boundary:
			position.x -= speed
			await get_tree().process_frame
		$FlipHelper/Body/Head1.disabled = false
		$FlipHelper/Body/Head2.disabled = false
		$AnimationPlayer.play("Idle")
		await get_tree().create_timer(0.5).timeout
		$FlipHelper.scale.x = 1
		await get_tree().create_timer(0.5).timeout
		$AnimationPlayer.stop()
		moving = false
	elif direction == "left":
		$FlipHelper.scale.x = 1
		moving = true
		$FlipHelper/Body/Head1.disabled = true
		$FlipHelper/Body/Head2.disabled = true
		$AnimationPlayer.play("Walk", -1, 0.7)
		while position.x < right_boundary:
			position.x += speed
			await get_tree().process_frame
		$FlipHelper/Body/Head1.disabled = false
		$FlipHelper/Body/Head2.disabled = false
		$AnimationPlayer.play("Idle")
		await get_tree().create_timer(0.5).timeout
		$FlipHelper.scale.x = -1
		await get_tree().create_timer(0.5).timeout
		$AnimationPlayer.stop()
		moving = false

func rocks():
	moving = true
	var rock_prefab = preload("res://entities/characters/lion/falling_rock.tscn")
	var one_rock = rock_prefab.instance()
	one_rock.position = Vector2(400, 300)
	get_parent().add_child(one_rock)
	moving = false

func jump():
	moving = true
	
	moving = false

func dash():
	pass
