extends Node2D

var menu_hidden = true
@export var button_menu: Button
@export var button_continue: Button
@export var button_castle: Button
@export var button_home: Button

@export var heracle_abilities = {
	DataManager.HeracleAbility.EMPTY: TextureRect,
	DataManager.HeracleAbility.CLUB: TextureRect,
	DataManager.HeracleAbility.SWORD: TextureRect,
	DataManager.HeracleAbility.BOW: TextureRect,
}

@export var hera_abilities = {
	DataManager.HeraAbility.STATE_EMPTY: TextureRect,
	DataManager.HeraAbility.STATE_PLATFORM: TextureRect,
	DataManager.HeraAbility.STATE_WEAPON: TextureRect,
	DataManager.HeraAbility.STATE_LEVELIO: TextureRect,
}

func _ready() -> void:
	button_menu = $UI/Menu
	button_continue = $Other/Continue
	button_castle = $Other/Castle
	button_home = $Other/Home
	update_buttons_visibility()

	heracle_abilities[DataManager.HeracleAbility.EMPTY] = $UI2/HeracleEmpty
	heracle_abilities[DataManager.HeracleAbility.CLUB] = $UI2/HeracleClub
	heracle_abilities[DataManager.HeracleAbility.SWORD] = $UI2/HeracleSword
	heracle_abilities[DataManager.HeracleAbility.BOW] = $UI2/HeracleBow
	
	hera_abilities[DataManager.HeraAbility.STATE_EMPTY] = $UI2/HeraEmpty
	hera_abilities[DataManager.HeraAbility.STATE_PLATFORM] = $UI2/HeraPlatform
	hera_abilities[DataManager.HeraAbility.STATE_WEAPON] = $UI2/HeraWeapon
	hera_abilities[DataManager.HeraAbility.STATE_LEVELIO] = $UI2/HeraLevelio

func _physics_process(delta: float) -> void:
	var unlocked_abilities_hera = DataManager.progress["unlocked_abilities"].get(DataManager.Characters.HERA, [])
	for hera_ability_key in hera_abilities.keys():
		if hera_ability_key in unlocked_abilities_hera:
			hera_abilities[hera_ability_key].visible = true
			#hera_abilities[hera_ability_key].texture = load()
		else:
			hera_abilities[hera_ability_key].visible = false
	
	var unlocked_abilities_heracle = DataManager.progress["unlocked_abilities"].get(DataManager.Characters.HERACLE, [])
	for heracle_ability_key in heracle_abilities.keys():
		if heracle_ability_key in unlocked_abilities_heracle:
			heracle_abilities[heracle_ability_key].visible = true
		else:
			heracle_abilities[heracle_ability_key].visible = false

func update_buttons_visibility() -> void:
	button_continue.visible = not menu_hidden
	button_castle.visible = not menu_hidden
	button_home.visible = not menu_hidden

func _on_menu_pressed() -> void:	
	menu_hidden = !menu_hidden
	update_buttons_visibility()

func _on_continue_pressed() -> void:
	menu_hidden = !menu_hidden
	update_buttons_visibility()

func _on_castle_pressed() -> void:
	DataManager.save_game()
	DataManager.change_scene(DataManager.ROOMS.castle)

func _on_home_pressed() -> void:
	DataManager.save_game()
	DataManager.change_scene(DataManager.ROOMS.home)
