# hera.gd
extends Node2D

var hera_active: bool = true

func testHera():
	DataManager.reset_game()
	DataManager.unlock_ability(DataManager.Characters.HERA, DataManager.HeraAbility.STATE_WEAPON)
	DataManager.unlock_ability(DataManager.Characters.HERA, DataManager.HeraAbility.STATE_SHIELD)
	DataManager.unlock_ability(DataManager.Characters.HERA, DataManager.HeraAbility.STATE_PLATFORM)
	DataManager.progress.selected_abilities[DataManager.Characters.HERA] = DataManager.HeraAbility.STATE_PLATFORM

func _ready():
	# Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	testHera()

func _input(event):
	if event.is_action_pressed("hera-activate"):
		if DataManager.progress.selected_abilities[DataManager.Characters.HERA] == DataManager.HeraAbility.STATE_PLATFORM:
			hera_platform()
		if DataManager.progress.selected_abilities[DataManager.Characters.HERA] == DataManager.HeraAbility.STATE_SHIELD:
			SceneManager.change_scene(SceneManager.ROOMS.level1)
		if DataManager.progress.selected_abilities[DataManager.Characters.HERA] == DataManager.HeraAbility.STATE_WEAPON:
			SceneManager.change_scene(SceneManager.ROOMS.castle)
	if event.is_action_pressed("hera-toggle"):
		DataManager.switch_ability(DataManager.Characters.HERA)

func hera_platform():
	hera_active = false
	await get_tree().create_timer(0.5).timeout
	hera_active = true

func _physics_process(_delta: float) -> void:
	if hera_active:
		position += (get_global_mouse_position() - position) / 5
