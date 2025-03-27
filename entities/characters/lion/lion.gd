extends Node2D

enum attack_patterns {
	IDLE,
	SCREAM,
	WALK,
	ROCKS,
	DASH,
}

var area2d_node: Area2D
var segment: int = 1
# these values are all random; adjust whatever you need Jafar
const left_boundary = -655
const right_boundary = 712
const init_pos = Vector2(500,500)
const jump_locations = [Vector2(500,500), Vector2(200,200)] # maybe there'll be two locations into which he's jumping?


func _ready() -> void:
	area2d_node = $FlipHelper/Collider
	DataManager.ram["boss_health"] = 101
	print("Boss health set to:")
	print(DataManager.ram["boss_health"])
	$FlipHelper.scale.x = -1
	scream()
	DataManager.ram["boss_health"] = 100
	segment = 1

func _process(delta: float) -> void:
	handle_phases()

func handle_phases():
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
	if segment == 1:
		walk()
	elif segment == 2:
		$AnimationPlayer.play("Walk")
		position.x += 1
	
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

func walk():
	$AnimationPlayer.play("Walk")
	while position.x > left_boundary:
		position.x -= 1
		await get_tree().process_frame 
	$AnimationPlayer.play("Idle")
	await get_tree().create_timer(0.5).timeout
	$FlipHelper.scale.x = 1
	await get_tree().create_timer(0.5).timeout
	$AnimationPlayer.stop()

func rocks():
	var rock_prefab = preload("res://entities/characters/lion/falling_rock.tscn")
	var one_rock = rock_prefab.instance()
	one_rock.position = Vector2(400, 300)
	get_parent().add_child(one_rock)

func jump():
	pass

func dash():
	pass
