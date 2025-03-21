extends Node
class_name WaveManager

@export var wave_number : int = 0
@export var wave_difficulty : float = 1.0
@export var wave_enemies : Array[BaseEnemy] = []
@export var wave_number_of_enemies : int = 15
@export var wave_duration := 30.0



func _ready() -> void:
	GV.wave_manager = self
	await(get_tree().process_frame)
	initialize_spawners()
	spawn_next_wave()

func initialize_spawners() -> void:
	for spawner : EnemySpawner in GV.spawners:
		spawner.wave_manager = self

func spawn_next_wave() -> void:
	for spawner : EnemySpawner in GV.spawners:
		spawner.spawn_wave(wave_number_of_enemies / len(GV.spawners))
	increment_wave_difficulty()
	$Timer.start(wave_duration)

func increment_wave_difficulty() -> void:
	wave_number_of_enemies += 5

func _on_button_pressed() -> void:
	$Timer.stop()
	spawn_next_wave()

func _on_timer_timeout() -> void:
	spawn_next_wave()
