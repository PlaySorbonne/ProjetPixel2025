extends Node
class_name WaveManager


enum EnemyTypes {Basic, Runner, Tank, Rock}

const MAX_ENEMY_TYPES_PER_WAVE := 2
const NEXT_BUTTON_RES := preload("res://scenes/interface/gameplay_hud/next_wave_button.tscn")
const ENEMY_RES : Dictionary[EnemyTypes, PackedScene] = {
	EnemyTypes.Basic : preload("res://scenes/world/enemies/mobs/standard_walker.tscn"),
	EnemyTypes.Runner : preload("res://scenes/world/enemies/mobs/runner.tscn"),
	EnemyTypes.Tank : preload("res://scenes/world/enemies/mobs/tank.tscn"),
	EnemyTypes.Rock : preload("res://scenes/world/enemies/mobs/rock.tscn"),
}
const ENEMY_DIFFICULTIES : Dictionary[EnemyTypes, float]= {
	EnemyTypes.Basic : 1.0,
	EnemyTypes.Runner : 0.7,
	EnemyTypes.Tank : 4.5,
	EnemyTypes.Rock : 3.5,
}
const ENEMY_PROBABILITIES : Dictionary[EnemyTypes, float] = {
	EnemyTypes.Basic : 0.5,
	EnemyTypes.Runner : 0.75,
	EnemyTypes.Tank : 0.25,
	EnemyTypes.Rock : 0.6,
}

class EnemyWave:
	var wave_number : int = 0
	var wave_difficulty : float = 5.0
	var wave_enemies : Array[BaseEnemy] = []
	var wave_number_of_enemies : int = 5
	var wave_duration := 30.0
	var is_boss_wave := false

var waves : Array[EnemyWave] = []
var wave_buttons : Array[NextWaveButton] = []
var current_wave_id : int = 0
var max_wave := 0
var wave_enemies : Array = []
var is_last_wave_spawned := false

# components
@onready var vbox_container := $CanvasLayer/VBoxContainer


func _ready() -> void:
	GV.wave_manager = self
	await(get_tree().process_frame)
	initialize_spawners()
	for i : int in range(9):
		var n_v := EnemyWave.new()
		n_v.wave_difficulty += randi_range(i*2, i*4)
		n_v.wave_number = i+1
		n_v.wave_number_of_enemies = n_v.wave_difficulty
		n_v.wave_duration = 30.0
		n_v.is_boss_wave = false
		waves.append(n_v)
		var button := add_wave_button(n_v)
		if i==0:
			button.set_next_wave()

func generate_new_wave() -> void:
	if max_wave == 15:
		return
	var wave_num := max_wave
	var new_wave := EnemyWave.new()
	new_wave.wave_number_of_enemies += randi_range(wave_num*3, wave_num*5)
	new_wave.wave_number = max_wave + 1
	new_wave.wave_difficulty = new_wave.wave_number_of_enemies
	new_wave.wave_duration = 30.0
	new_wave.is_boss_wave = false
	waves.append(new_wave)
	var button := add_wave_button(new_wave)

func _process(delta: float) -> void:
	$CanvasLayer/VBoxContainer/Label.text = str(int($Timer.time_left))

func add_wave_button(w : EnemyWave) -> NextWaveButton:
	var button : NextWaveButton = NEXT_BUTTON_RES.instantiate()
	button.set_wave(w)
	vbox_container.add_child(button)
	wave_buttons.append(button)
	button.connect("next_wave_triggered", spawn_next_wave)
	vbox_container.move_child(button, 0)
	max_wave += 1
	return button

func initialize_spawners() -> void:
	for spawner : EnemySpawner in GV.spawners:
		spawner.wave_manager = self

func pick_random_weighted(array: Array, weights: Array) -> Variant:
	var sum:float = 0.0
	for val in weights:
		sum += val
	
	var normalizedWeights = []
	for val in weights:
		normalizedWeights.append(val / sum)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rnd = rng.randf()
	var i = 0
	var summer:float = 0.0

	for val in normalizedWeights:
		summer += val
		if summer >= rnd:
			return array[i]
		i += 1
	return null

func spawn_next_wave() -> void:
	# FOR DEMO ONLY -> limit waves to 15 and spawn boss on last wave
	if is_last_wave_spawned:
		return
	if current_wave_id == 15:
		is_last_wave_spawned = true
		var boss := preload("res://scenes/world/enemies/mobs/demo_boss.tscn").instantiate()
		GV.spawners[1].spawn_wave([boss])
		return
		
	wave_buttons[current_wave_id].remove_button()
	var current_wave : EnemyWave = waves[current_wave_id]
	var distributed_enemies : Array[Array] = []
	for _i : int in range(len(GV.spawners)):
		distributed_enemies.append([])
	var wave_budget : float = current_wave.wave_difficulty
	# define which enemies will be in the wave (change later, bad system)
	var random_types : Array = EnemyTypes.values()
	random_types.shuffle()
	var types_of_wave_enemies : Array[EnemyTypes] = []
	var enemy_weights : Array[float] = []
	for _i in range(MAX_ENEMY_TYPES_PER_WAVE):
		var type_index : int = randi_range(0, len(random_types) - 1)
		types_of_wave_enemies.append(random_types[type_index])
		enemy_weights.append(ENEMY_PROBABILITIES[random_types[type_index]])
		random_types.remove_at(type_index)
	# add enemies to the wave until budget runs out
	while wave_budget > 0.0:
		var enemy_type : EnemyTypes = pick_random_weighted(
			types_of_wave_enemies,
			enemy_weights
		)
		wave_budget -= ENEMY_DIFFICULTIES[enemy_type]
		var selected_spawner : int = randi_range(0, len(distributed_enemies)-1)
		distributed_enemies[selected_spawner].append(ENEMY_RES[enemy_type].instantiate())
	# spawn enemies
	for i : int in range(len(GV.spawners)):
		var spawner : EnemySpawner = GV.spawners[i]
		spawner.spawn_wave(distributed_enemies[i])
	current_wave_id += 1
	$CanvasLayer/VBoxContainer/LabelWave.text = "Current wave:\nWave " + str(current_wave_id)
	if current_wave_id < max_wave:
		wave_buttons[current_wave_id].set_next_wave()
		$Timer.start(waves[current_wave_id].wave_duration)
	generate_new_wave()

func _on_timer_timeout() -> void:
	spawn_next_wave()
