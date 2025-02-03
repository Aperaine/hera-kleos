extends Node


const SAVE_PATH = "user://save_data.json"

var unlocked_levels = [1]
var unlocked_abilities = { Enums.Characters.HERACLE: [], Enums.Characters.HERA: [] }
var selected_weapons = { Enums.Characters.HERACLE: null, Enums.Characters.HERA: null }
var play_time = 0.0
var deaths = 0

# Load game progress
func load_game():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())

		if data:
			unlocked_levels = data.get("unlocked_levels", unlocked_levels)
			unlocked_abilities = data.get("unlocked_abilities", unlocked_abilities)
			selected_weapons = data.get("selected_weapons", selected_weapons)
			play_time = data.get("play_time", 0.0)
			deaths = data.get("deaths", 0)
	
# Save game progress
func save_game():
	var data = {
		"unlocked_levels": unlocked_levels,
		"unlocked_abilities": unlocked_abilities,
		"selected_weapons": selected_weapons,
		"play_time": play_time,
		"deaths": deaths
	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))

# Unlock an ability
func unlock_ability(character: int, ability: int):
	if ability not in unlocked_abilities[character]:
		unlocked_abilities[character].append(ability)
		save_game()

# Change selected weapon
func select_weapon(character: int, weapon: int):
	selected_weapons[character] = weapon
	save_game()

# Unlock a new level
func unlock_level(level: int):
	if level not in unlocked_levels:
		unlocked_levels.append(level)
		save_game()

# Track deaths and playtime
func record_death():
	deaths += 1
	save_game()

func update_play_time(delta: float):
	play_time += delta
	save_game()
