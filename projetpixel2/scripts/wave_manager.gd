extends Node
class_name WaveManager

@export var current_wave_number : int = 0
@export var current_wave_difficulty : float = 1.0
@export var current_wave_enemies : Array[BaseEnemy] = []
@export var current_wave_number_of_enemies : int = 25

func _ready() -> void:
	GV.wave_manager = self
	await(get_tree().process_frame)
	initialize_spawners()
	spawn_wave()

func initialize_spawners() -> void:
	for spawner : EnemySpawner in GV.spawners:
		spawner.wave_manager = self

func spawn_wave() -> void:
	for spawner : EnemySpawner in GV.spawners:
		spawner.spawn_wave(current_wave_number_of_enemies / len(GV.spawners))
	
