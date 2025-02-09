extends Node

enum ROOMS {
	tutorial,
	castle,
	level1,
	level2,
	level3,
	level4,
	level5
}

const ROOM_PATHS = {
	ROOMS.tutorial: "res://entities/levels/tutorial/tutorial.tscn",
	ROOMS.castle: "res://entities/levels/castle/castle.tscn",
	ROOMS.level1: "res://entities/levels/level1 - lion/level1.tscn",
	ROOMS.level2: "res://entities/levels/level2 - hydra/level2.tscn",
	ROOMS.level3: "res://entities/levels/level3 - hind/level3.tscn",
	ROOMS.level4: "res://entities/levels/level4 - boar/level4.tscn",
	ROOMS.level5: "res://entities/levels/level5 - stables/level5.tscn",
}

func change_scene(room: ROOMS):
	DataManager.save_game()
	get_tree().change_scene_to_file(ROOM_PATHS[room])
	DataManager.load_game()
	print("Changed to room: " + str(room))
