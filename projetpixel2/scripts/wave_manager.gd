extends Node
class_name WaveManager

@export var current_wave_number : int = 0
@export var current_wave_difficulty : float = 1.0
@export var current_wave_enemies : Array[BaseEnemy] = []

func _ready() -> void:
	await(get_tree().process_frame)
	for spawner : EnemySpawner in GV.spawners:
		spawner.spawn_wave(50 / len(GV.spawners))
	
