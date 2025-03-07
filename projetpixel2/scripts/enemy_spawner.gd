extends Node3D
class_name EnemySpawner

func _ready() -> void:
	await get_tree().process_frame
	spawn_wave(25)

func spawn_enemy() -> void:
	var enemy : BaseEnemy = preload("res://scenes/world/enemies/base_enemy.tscn").instantiate()
	GV.world.add_child(enemy)
	enemy.position = self.position
	print("new enemy!")

func spawn_wave(nb_enemies : int) -> void:
	for i : int in range(nb_enemies):
		spawn_enemy()
		await get_tree().create_timer(randf_range(0.3, 0.8)).timeout
