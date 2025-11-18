@tool
extends Node3D
class_name EnemySpawner


@export var path : Path3D 
@export var waves_data : Array[WaveData] = []

var wave_manager : WaveManager = null


func _ready() -> void:
	if not Engine.is_editor_hint():
		GV.spawners.append(self)
		#$CSGCylinder3D.visible = false

@export var spawner_radius := 1.0:
	set(new_val):
		if new_val > 0.0:
			spawner_radius = new_val
			$CSGCylinder3D.radius = spawner_radius

func spawn_enemy(enemy : BaseEnemy) -> void:
	enemy.position = self.position + Vector3(
		randf_range(-spawner_radius*1.0, spawner_radius*1.0),
		0.0,
		randf_range(-spawner_radius*1.0, spawner_radius*1.0)
	)
	GV.world.add_child(enemy)

func spawn_wave(enemies : Array) -> void:
	for enemy : BaseEnemy in enemies:
		spawn_enemy(enemy)
		await get_tree().create_timer(randf_range(0.3, 0.8)).timeout
