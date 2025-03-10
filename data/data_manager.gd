extends Node

enum SLOTS {
	SLOT1,
	SLOT2,
	SLOT3,
	SLOT4,
}

const SLOT_PATHS = {
	SLOTS.SLOT1: "user://save_data1.json",
	SLOTS.SLOT2: "user://save_data2.json",
	SLOTS.SLOT3: "user://save_data3.json",
	SLOTS.SLOT4: "user://save_data4.json",
}

enum ROOMS {
	tutorial,
	home,
	castle,
	level1,
	level1_1,
	level2,
	level3,
	level4,
	level5,
}

const ROOM_PATHS = {
	ROOMS.tutorial: "res://entities/levels/tutorial/tutorial.tscn",
	ROOMS.home: "res://entities/levels/home/home.tscn",
	ROOMS.castle: "res://entities/levels/castle/castle.tscn",
	ROOMS.level1: "res://entities/levels/level1 - lion/level1.0.tscn",
	ROOMS.level1_1: "res://entities/levels/level1 - lion/level1.1.tscn",
	ROOMS.level2: "res://entities/levels/level2 - hydra/level2.tscn",
	ROOMS.level3: "res://entities/levels/level3 - hind/level3.tscn",
	ROOMS.level4: "res://entities/levels/level4 - boar/level4.tscn",
	ROOMS.level5: "res://entities/levels/level5 - stables/level5.tscn",
}

var game_stats = {
	"play_time": 0.0,
	"deaths_heracle": 0,
	"deaths_hera": 0,
	"name": "",
}

var progress = {
	"unlocked_levels": [ROOMS.tutorial, ROOMS.castle, ROOMS.level1],
	"unlocked_abilities": {
		Characters.HERA: [HeraAbility.STATE_EMPTY],
		Characters.HERACLE: [HeracleAbility.EMPTY],
	},
	"selected_abilities": {
		Characters.HERA: HeraAbility.STATE_EMPTY,
		Characters.HERACLE: HeracleAbility.EMPTY,
	}
}

var ram = {
	"slot": SLOTS.SLOT1,
	"arrows": 3,
	"hera_active": true,
	"hera_safe_pos": Vector2(100, 100),
	"camera_pos": Vector2(960, 540),
	"camera_default": Vector2(960, 540),
	"hera_at_level_end": false,
	"game_paused": false,
	"heracle_safe_pos": Vector2(250, 600),
	"heracle_dead": false,
}

enum Characters {
	HERA,
	HERACLE,
}

enum HeraAbility {
	STATE_EMPTY,
	STATE_PLATFORM,
	STATE_WEAPON,
	STATE_LEVELIO,
}

enum HeracleAbility {
	EMPTY,
	CLUB,
	SWORD,
	BOW,
}

func debug():
	self.delete_slot(SLOTS.SLOT1)
	self.delete_slot(SLOTS.SLOT2)
	self.delete_slot(SLOTS.SLOT3)
	self.delete_slot(SLOTS.SLOT4)
	self.game_stats["name"] = "AJU Testing Lands"
	self.progress.selected_abilities[self.Characters.HERA] = self.HeraAbility.STATE_EMPTY
	#self.unlock_ability(self.Characters.HERA, self.HeraAbility.STATE_PLATFORM)
	#self.unlock_ability(self.Characters.HERA, self.HeraAbility.STATE_WEAPON)
	#self.unlock_ability(self.Characters.HERA, self.HeraAbility.STATE_LEVELIO)
	#self.progress.selected_abilities[self.Characters.HERA] = self.HeraAbility.STATE_PLATFORM
	#self.unlock_ability(self.Characters.HERACLE, self.HeracleAbility.CLUB)
	#self.unlock_ability(self.Characters.HERACLE, self.HeracleAbility.SWORD)
	#self.unlock_ability(self.Characters.HERACLE, self.HeracleAbility.BOW)
	#self.progress.selected_abilities[self.Characters.HERACLE] = self.HeracleAbility.BOW
	self.unlock_level(self.ROOMS.castle)
	self.unlock_level(self.ROOMS.level1)
	self.unlock_level(self.ROOMS.level1_1)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	output_data()

func _ready():
	Engine.max_fps = 60
	debug()

func change_scene(room: ROOMS):
	save_game()
	get_tree().change_scene_to_file(ROOM_PATHS[room])
	print("Changed to room: " + str(room))

func load_game():
	if not FileAccess.file_exists(SLOT_PATHS[ram["slot"]]):
		reset_game()
		save_game()
		return
	
	var file = FileAccess.open(SLOT_PATHS[ram["slot"]], FileAccess.READ)
	if file == null:
		printerr("Failed to open save file for reading.")
		return
	
	var json_text = file.get_as_text()
	var data = JSON.parse_string(json_text)
	
	if typeof(data) != TYPE_DICTIONARY:
		printerr("Failed to parse save file JSON.")
		return
	
	# Load game stats
	game_stats.play_time = data.get("play_time", 0.0)
	game_stats.deaths_heracle = data.get("deaths_heracle", 0)
	game_stats.deaths_hera = data.get("deaths_hera", 0)
	game_stats.name = data.get("name", "")
	
	# Load progress
	progress.unlocked_levels = data.get("unlocked_levels", [ROOMS.tutorial, ROOMS.castle, ROOMS.level1])
	
	# Load abilities with proper type conversion
	var loaded_unlocked = data.get("unlocked_abilities", {})
	progress.unlocked_abilities = {
		Characters.HERA: [HeraAbility.STATE_EMPTY],
		Characters.HERACLE: [HeracleAbility.EMPTY],
	}
	
	for key in loaded_unlocked.keys():
		var char_key = int(key)
		progress.unlocked_abilities[char_key] = []
		for ability in loaded_unlocked[key]:
			progress.unlocked_abilities[char_key].append(int(ability))
	
	# Load selected abilities
	var loaded_selected = data.get("selected_abilities", {})
	progress.selected_abilities = {
		Characters.HERA: HeraAbility.STATE_EMPTY,
		Characters.HERACLE: HeracleAbility.EMPTY,
	}
	
	for key in loaded_selected.keys():
		var char_key = int(key)
		progress.selected_abilities[char_key] = int(loaded_selected[key])

func save_game():
	var file = FileAccess.open(SLOT_PATHS[ram["slot"]], FileAccess.WRITE)
	if file == null:
		printerr("Failed to open save file for writing.")
		return
	
	var save_data = {
		"play_time": game_stats.play_time,
		"deaths_heracle": game_stats.deaths_heracle,
		"deaths_hera": game_stats.deaths_hera,
		"name": game_stats.name,
		"unlocked_levels": progress.unlocked_levels,
		"unlocked_abilities": progress.unlocked_abilities,
		"selected_abilities": progress.selected_abilities,
	}
	
	file.store_string(JSON.stringify(save_data))

func reset_game():
	if FileAccess.file_exists(SLOT_PATHS[ram["slot"]]):
		var err = DirAccess.remove_absolute(SLOT_PATHS[ram["slot"]])
		if err != OK:
			printerr("Failed to delete save file.")
			return
	
	game_stats.play_time = 0.0
	game_stats.deaths_heracle = 0
	game_stats.deaths_hera = 0
	progress.unlocked_levels = [self.ROOMS.tutorial, self.ROOMS.castle, self.ROOMS.level1]
	progress.unlocked_abilities = {
		Characters.HERA: [self.HeraAbility.STATE_EMPTY],
		Characters.HERACLE: [self.HeracleAbility.EMPTY],
	}
	progress.selected_abilities = {
		Characters.HERA: self.HeraAbility.STATE_EMPTY,
		Characters.HERACLE: self.HeracleAbility.EMPTY,
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

func record_death(deaths: int, character: Characters):
	if character == Characters.HERA:
		game_stats.deaths_heracle += deaths
	elif character == Characters.HERACLE:
		game_stats.deaths_hera += deaths
	save_game()

func record_time(time: float):
	game_stats.play_time += time
	save_game()
	print("Played for " + str(time) + " this level.")
	print("Played for " + str(game_stats.play_time) + " in general.")

func convert_time(time):
	var sec = fmod(time, 60)
	var minimum = time / 60
	print(minimum)
	print(sec)

func get_game_stats(slot: SLOTS) -> Dictionary:
	if not SLOT_PATHS.has(slot):
		printerr("Invalid slot.")
		return {}

	if not FileAccess.file_exists(SLOT_PATHS[slot]):
		return {
			"play_time": 0.0,
			"deaths_heracle": 0,
			"deaths_hera": 0,
		}

	var file = FileAccess.open(SLOT_PATHS[slot], FileAccess.READ)
	if file == null:
		printerr("Failed to open save file for reading.")
		return {}

	var json_text = file.get_as_text()
	var data = JSON.parse_string(json_text)

	if typeof(data) != TYPE_DICTIONARY:
		printerr("Failed to parse save file JSON. Raw text:", json_text)
		return {}

	return {
		"play_time": data.get("play_time", 0.0),
		"deaths_heracle": data.get("deaths_heracle", 0),
		"deaths_hera": data.get("deaths_hera", 0),
	}

func slot_exists(slot: SLOTS) -> bool:
	if not SLOT_PATHS.has(slot):
		printerr("Invalid slot.")
		return false
	return FileAccess.file_exists(SLOT_PATHS[slot])

func delete_slot(slot: SLOTS):
	if not SLOT_PATHS.has(slot):
		printerr("Invalid slot.")
		return
	
	if not slot_exists(slot):
		print("Slot does not exist, nothing to delete.")
		return
	
	var err = DirAccess.remove_absolute(SLOT_PATHS[slot])
	if err != OK:
		printerr("Failed to delete save file for slot ", slot)
	else:
		print("Successfully deleted save file for slot ", slot)

func get_slot_name(slot: SLOTS) -> String:
	if not SLOT_PATHS.has(slot):
		return ""
	
	if not FileAccess.file_exists(SLOT_PATHS[slot]):
		return ""
	
	var file = FileAccess.open(SLOT_PATHS[slot], FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	
	#var json_text = file.get_as_text()
	#var data2 = JSON.parse_string(json_text)
	return data.get("name", "")

func restart_level():
	get_tree().reload_current_scene()

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

deaths_hera:
{deaths_hera}
deaths_heracle:
{deaths_heracle}
--------------------""".format({
		"levels": progress.unlocked_levels,
		"abilities": progress.unlocked_abilities,
		"weapons": progress.selected_abilities,
		"time": game_stats.play_time,
		"deaths_hera": game_stats.deaths_hera,
		"deaths_heracle": game_stats.deaths_heracle,
	}))


func hera_safe_pos() -> void:
	Input.warp_mouse(ram["hera_safe_pos"])

func set_heracles_safe_pos(pos: Vector2) -> void:
	ram["heracles_safe_pos"] = pos
