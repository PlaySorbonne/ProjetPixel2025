extends Node3D
class_name LevelEnvironment

func _ready() -> void:
	generate_map(Vector2i(10, 10))

func generate_map(map_size : Vector2i) -> void:
	var tiles : Array = []
	for x : int in range(map_size.x):
		for y : int in range(map_size.y):
			var pos_x : float = 2.0 * x
			if x%2==1:
				pos_x += 1
			var pos_z : float = 1.7 * y
			DefaultTile.spawn_tile(Vector3(pos_x, 0, pos_z))
			print(Vector3(pos_x, 0, pos_z))
	
