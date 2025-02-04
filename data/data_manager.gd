extends Node

const SAVE_PATH = "user://save_data.json"

# Enums
enum HeraAbility {
	STATE_WEAPON,
	STATE_SHIELD,
	STATE_PLATFORM,
}

enum HeracleAbility {
	CLUB,
	SWORD,
	BOW,
}

enum Characters {
	HERA,
	HERACLE,
}

# Game Data
var game_stats = {
	"play_time": 0.0,
	"deaths": 0,
}

var progress = {
	"unlocked_levels": [1],
	"unlocked_abilities": {
		Characters.HERA: [],
		Characters.HERACLE: [],
	},
	"selected_abilities": {
		Characters.HERA: null,
		Characters.HERACLE: null,
	}
}

func _ready():
	load_game()
	output_data()


func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		save_game()
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		printerr("Failed to open save file for reading.")
		return
	
	var json_text = file.get_as_text()
	var data = JSON.parse_string(json_text)

	# Ensure parsing was successful (Godot 4's JSON.parse_string() returns directly)
	if typeof(data) != TYPE_DICTIONARY:
		printerr("Failed to parse save file JSON. Raw text:", json_text)
		return
	
	# Update game stats
	game_stats.play_time = data.get("play_time", 0.0)
	game_stats.deaths = data.get("deaths", 0)
	progress.unlocked_levels = data.get("unlocked_levels", [1])
	
	# Convert string dictionary keys back to integers
	var loaded_unlocked = data.get("unlocked_abilities", {})
	var new_unlocked = {}
	for key in loaded_unlocked.keys():
		new_unlocked[int(key)] = loaded_unlocked[key]
	progress.unlocked_abilities = new_unlocked
	
	var loaded_selected = data.get("selected_abilities", {})
	var new_selected = {}
	for key in loaded_selected.keys():
		new_selected[int(key)] = loaded_selected[key]
	progress.selected_abilities = new_selected

func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		printerr("Failed to open save file for writing.")
		return
	
	var save_data = {
		"play_time": game_stats.play_time,
		"deaths": game_stats.deaths,
		"unlocked_levels": progress.unlocked_levels,
		"unlocked_abilities": progress.unlocked_abilities,
		"selected_abilities": progress.selected_abilities,
	}
	
	file.store_string(JSON.stringify(save_data))

func reset_game():
	if FileAccess.file_exists(SAVE_PATH):
		var err = DirAccess.remove_absolute(SAVE_PATH)
		if err != OK:
			printerr("Failed to delete save file.")
			return
	
	game_stats.play_time = 0.0
	game_stats.deaths = 0
	progress.unlocked_levels = [1]
	progress.unlocked_abilities = {
		Characters.HERA: [],
		Characters.HERACLE: []
	}
	progress.selected_abilities = {
		Characters.HERA: null,
		Characters.HERACLE: null
	}
	
	save_game()
	print("Game data has been successfully reset.")

func unlock_ability(character: int, ability: int):
	if not progress.unlocked_abilities.has(character):
		progress.unlocked_abilities[character] = []
	
	if ability not in progress.unlocked_abilities[character]:
		progress.unlocked_abilities[character].append(ability)
		save_game()
		print("Ability ", ability, " was successfully added for character ", character)
	else:
		print("Ability ", ability, " is already unlocked for character ", character)
		
func switch_ability(character: int):
	if not progress.unlocked_abilities.has(character):
		print("Error: No unlocked abilities for character: ", character)
		return
	
	var unlocked = progress.unlocked_abilities[character]
	
	if unlocked.is_empty():
		print("No unlocked abilities for character: ", character)
		return
	
	if progress.selected_abilities[character] == null or progress.selected_abilities[character] not in unlocked:
		progress.selected_abilities[character] = unlocked[0]
	else:
		var current_index = unlocked.find(progress.selected_abilities[character])
		if current_index == -1:
			progress.selected_abilities[character] = unlocked[0]
		else:
			var next_index = (current_index + 1) % unlocked.size()
			progress.selected_abilities[character] = unlocked[next_index]
	
	print(str(character) + " switched ability to " + str(progress.selected_abilities[character]))
	
func unlock_level(level: int):
	if level not in progress.unlocked_levels:
		progress.unlocked_levels.append(level)
		save_game()
		print("Level " + str(level) + " is unlocked.")

func record_death(deaths: int):
	game_stats.deaths += deaths
	save_game()
	print("Died " + str(deaths) + " times this level.")
	print("Died " + str(game_stats.deaths) + " times in general.")

func record_time(delta: float):
	game_stats.play_time += delta
	save_game()
	print("Played for " + str(delta) + " this level.")
	print("Played for " + str(game_stats.play_time) + " in general.")

func output_data():
	print("""
--------DATA--------
unlocked_levels:
{levels}

unlocked_abilities:
{abilities}

selected_abilities:
{weapons}

play_time:
{time}

deaths:
{deaths}
--------------------""".format({
		"levels": progress.unlocked_levels,
		"abilities": progress.unlocked_abilities,
		"weapons": progress.selected_abilities,
		"time": game_stats.play_time,
		"deaths": game_stats.deaths
	}))
