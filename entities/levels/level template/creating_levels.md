# Turorial: Creating new levels

1. Copy the template
	Copy the level `template.tscn`. Rename and paste it into the corresponding stop in the file system.
	If it's a first scene for the level, please ensure that in data_manager, the location for the file is shown correctly.
	Naming convention for the levels:
	- Level1.0.tscn (the level which will be opened when Heracle enters the gate at the castle.)
	- Level1.X.tscn (try to break down the level into couple rooms instead of putting everything into a singular file. Good practice would be to have around 5 screens per file.)
	- level1.boss.tscn (the final boss battle scene)
2. Design the level
	Arrange the hitboxes and objects in the scene to create an entertaining level.
	Things to remember:
	- Hera has a "safe_pos" variable in the DataManager; it's a location where Hera and mouse will spawn when level / screen will change or she will die.
		To change safe_pos in code, please use: ```DataManager.ram["hera_safe_pos"]=Vector2(x,y)```
	- Under the obstacle node, there are 3 StaticBody2D's with each having a singular CollisionShape2D inside.
		You can add more CollisionShape2Ds under the StaticBodies, to create more of the different colliders for characters.
		Please don't rename the "Obstacle Both", "Obstacle Hera", and "Obstacle Heracle", it's important.
		Try to stick to the color-coding,
		Yellow: Obstacle for Hera
		Purple: Obstacle for both characters
		Blue: Obstacle for Heracle
	- You can hide objects while editing to get better view, but please ensure all the objects are shown when submitting pr. (pull request)
	- Please ensure every level takes some time, and is not too fast. You can try to get around 7-15 minutes of platforming per level. (you can test time with Sabina or your friends)
3. Notify me and Allie
	After finishing the level-design, message in the group chat, so Allie and I can start drawing and adding the artworks.
