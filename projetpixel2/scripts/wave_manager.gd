extends Node
class_name WaveManager

@export var current_wave_number : int = 0
@export var current_wave_difficulty : float = 1.0
@export var current_wave_enemies : Array[BaseEnemy] = []
@export var current_wave_number_of_enemies : int = 25

func _ready() -> void:
	await(get_tree().process_frame)
	for spawner : EnemySpawner in GV.spawners:
		spawner.spawn_wave(current_wave_number_of_enemies / len(GV.spawners))
	
