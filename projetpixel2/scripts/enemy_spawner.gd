@tool
extends Node3D
class_name EnemySpawner

@export var spawner_radius := 1.0:
	set(new_val):
		if new_val > 0.0:
			spawner_radius = new_val
			$CSGCylinder3D.radius = spawner_radius

func spawn_enemy() -> void:
	var enemy : BaseEnemy = preload("res://scenes/world/enemies/base_enemy.tscn").instantiate()
	GV.world.add_child(enemy)
	enemy.position = self.position + Vector3(
		randf_range(-spawner_radius*100.0, spawner_radius*100.0),
		0.0,
		randf_range(-spawner_radius*100.0, spawner_radius*100.0)
	)
	print("new enemy!")

func spawn_wave(nb_enemies : int) -> void:
	for i : int in range(nb_enemies):
		spawn_enemy()
		await get_tree().create_timer(randf_range(0.3, 0.8)).timeout
