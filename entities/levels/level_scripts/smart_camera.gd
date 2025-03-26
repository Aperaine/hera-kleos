extends Node

enum CameraMovementType {
	static_screen,
	complete_follow,
	celeste_follow,
}

@export var camera_type: CameraMovementType = CameraMovementType.static_screen
@export var heracle_node: CharacterBody2D

func _ready() -> void:
	DataManager.ram["camera_pos"] = DataManager.ram["camera_default"]

func _process(delta: float) -> void:
	match camera_type:
		CameraMovementType.static_screen:
			self.position = DataManager.ram["camera_pos"]
		CameraMovementType.complete_follow:
			var heracle_pos = heracle_node.position
			self.position += (heracle_pos - self.position) / 10
		CameraMovementType.celeste_follow:
			pass
