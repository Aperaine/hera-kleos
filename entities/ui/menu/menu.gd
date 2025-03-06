extends Node2D

var menu_hidden = true
@onready var button_menu: Button
@onready var button_continue: Button
@onready var button_castle: Button
@onready var button_home: Button

@onready var heracle_abilities = {
	DataManager.HeracleAbility.EMPTY: TextureRect,
	DataManager.HeracleAbility.CLUB: TextureRect,
	DataManager.HeracleAbility.SWORD: TextureRect,
	DataManager.HeracleAbility.BOW: TextureRect,
}

@onready var hera_abilities = {
	DataManager.HeraAbility.STATE_EMPTY: TextureRect,
	DataManager.HeraAbility.STATE_PLATFORM: TextureRect,
	DataManager.HeraAbility.STATE_WEAPON: TextureRect,
	DataManager.HeraAbility.STATE_LEVELIO: TextureRect,
}

@onready var heracle_abilities2 = {
	DataManager.HeracleAbility.EMPTY: TextureRect,
	DataManager.HeracleAbility.CLUB: TextureRect,
	DataManager.HeracleAbility.SWORD: TextureRect,
	DataManager.HeracleAbility.BOW: TextureRect,
}

@onready var hera_abilities2 = {
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
	
	heracle_abilities[DataManager.HeracleAbility.EMPTY] = $UI/HeracleEmpty
	heracle_abilities[DataManager.HeracleAbility.CLUB] = $UI/HeracleClub
	heracle_abilities[DataManager.HeracleAbility.SWORD] = $UI/HeracleSword
	heracle_abilities[DataManager.HeracleAbility.BOW] = $UI/HeracleBow
	
	hera_abilities[DataManager.HeraAbility.STATE_EMPTY] = $UI/HeraEmpty
	hera_abilities[DataManager.HeraAbility.STATE_PLATFORM] = $UI/HeraPlatform
	hera_abilities[DataManager.HeraAbility.STATE_WEAPON] = $UI/HeraWeapon
	hera_abilities[DataManager.HeraAbility.STATE_LEVELIO] = $UI/HeraLevelio

	heracle_abilities2[DataManager.HeracleAbility.EMPTY] = $UI2/HeracleEmpty
	heracle_abilities2[DataManager.HeracleAbility.CLUB] = $UI2/HeracleClub
	heracle_abilities2[DataManager.HeracleAbility.SWORD] = $UI2/HeracleSword
	heracle_abilities2[DataManager.HeracleAbility.BOW] = $UI2/HeracleBow
	
	hera_abilities2[DataManager.HeraAbility.STATE_EMPTY] = $UI2/HeraEmpty
	hera_abilities2[DataManager.HeraAbility.STATE_PLATFORM] = $UI2/HeraPlatform
	hera_abilities2[DataManager.HeraAbility.STATE_WEAPON] = $UI2/HeraWeapon
	hera_abilities2[DataManager.HeraAbility.STATE_LEVELIO] = $UI2/HeraLevelio

func _physics_process(delta: float) -> void:
	# Hera: Hiding the locked abilities
	var unlocked_abilities_hera = DataManager.progress["unlocked_abilities"].get(DataManager.Characters.HERA, [])
	for hera_ability_key in hera_abilities.keys():
		if hera_ability_key in unlocked_abilities_hera:
			hera_abilities[hera_ability_key].modulate.a = 1.0
		else:
			hera_abilities[hera_ability_key].modulate.a = 0.5
	
	# Heracle: Hiding the locked abilities
	var unlocked_abilities_heracle = DataManager.progress["unlocked_abilities"].get(DataManager.Characters.HERACLE, [])
	for heracle_ability_key in heracle_abilities.keys():
		if heracle_ability_key in unlocked_abilities_heracle:
			heracle_abilities[heracle_ability_key].modulate.a = 1.0
		else:
			heracle_abilities[heracle_ability_key].modulate.a = 0.5
	
	# Hera: Make chosen ability visible
	var selected_ability_hera = DataManager.progress["selected_abilities"].get(DataManager.Characters.HERA, DataManager.HeraAbility.STATE_EMPTY)
	for hera_ability_key in hera_abilities2.keys():
		if hera_ability_key == selected_ability_hera:
			hera_abilities2[hera_ability_key].modulate.a = 1.0
		else:
			hera_abilities2[hera_ability_key].modulate.a = 0.0
	
	# Heracle: Make chosen ability visible
	#var unlocked_abilities_heracle = DataManager.progress["unlocked_abilities"].get(DataManager.Characters.HERACLE, [])
	var selected_ability_heracle = DataManager.progress["selected_abilities"].get(DataManager.Characters.HERACLE, DataManager.HeracleAbility.EMPTY)
	for heracle_ability_key in heracle_abilities2.keys():
		if heracle_ability_key == selected_ability_heracle:
			heracle_abilities2[heracle_ability_key].modulate.a = 1.0
		else:
			heracle_abilities2[heracle_ability_key].modulate.a = 0.0

func update_buttons_visibility() -> void:
	button_continue.visible = not menu_hidden
	button_castle.visible = not menu_hidden
	button_home.visible = not menu_hidden

func _on_menu_pressed() -> void:	
	menu_hidden = !menu_hidden
	DataManager.ram["hera_active"] = menu_hidden
	update_buttons_visibility()

func _on_continue_pressed() -> void:
	DataManager.ram["hera_active"] = true
	menu_hidden = !menu_hidden
	update_buttons_visibility()

func _on_castle_pressed() -> void:
	DataManager.ram["hera_active"] = true
	DataManager.save_game()
	DataManager.change_scene(DataManager.ROOMS.castle)

func _on_home_pressed() -> void:
	DataManager.ram["hera_active"] = true
	DataManager.save_game()
	DataManager.change_scene(DataManager.ROOMS.home)
