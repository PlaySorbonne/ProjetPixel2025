extends Node3D
class_name LevelEnvironment

func _ready() -> void:
	pass
	
	#await(get_tree().process_frame)
	#generate_map(Vector2i(10, 10), Vector2(-10, -10))

func generate_map(map_size : Vector2i, offset : Vector2) -> void:
	var tiles : Array = []
	for x : int in range(map_size.x):
		for y : int in range(map_size.y):
			var pos_x : float = 2.0 * x
			if y%2==1:
				pos_x += 1
			var pos_z : float = 1.7 * y
			DefaultTile.spawn_tile(Vector3(pos_x+offset.x, 0, pos_z+offset.y))
			await(get_tree().create_timer(0.05).timeout)
	
