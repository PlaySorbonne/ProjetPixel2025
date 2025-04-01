extends Node
class_name WaveManager

const NEXT_BUTTON_RES := preload("res://scenes/interface/gameplay_hud/next_wave_button.tscn")

class EnemyWave:
	var wave_number : int = 0
	var wave_difficulty : float = 1.0
	var wave_enemies : Array[BaseEnemy] = []
	var wave_number_of_enemies : int = 15
	var wave_duration := 30.0
	var is_boss_wave := false

var waves : Array[EnemyWave] = []
var wave_buttons : Array[NextWaveButton] = []
var current_wave_id : int = 0
var max_wave := 0

# components
@onready var vbox_container := $CanvasLayer/VBoxContainer


func _ready() -> void:
	GV.wave_manager = self
	await(get_tree().process_frame)
	initialize_spawners()
	for i : int in range(9):
		var n_v := EnemyWave.new()
		n_v.wave_number_of_enemies += randi_range(i, i*2)
		n_v.wave_number = i+1
		n_v.wave_difficulty = n_v.wave_number_of_enemies
		n_v.wave_duration = 30.0
		n_v.is_boss_wave = false
		waves.append(n_v)
		var button := add_wave_button(n_v)
		if i==0:
			button.set_next_wave()

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

func spawn_next_wave() -> void:
	if current_wave_id < max_wave:
		wave_buttons[current_wave_id].remove_button()
	var current_wave : EnemyWave = waves[current_wave_id]
	for spawner : EnemySpawner in GV.spawners:
		spawner.spawn_wave(current_wave.wave_number_of_enemies / len(GV.spawners))
	current_wave_id += 1
	if current_wave_id < max_wave:
		wave_buttons[current_wave_id].set_next_wave()
		$Timer.start(waves[current_wave_id].wave_duration)
	print_debug("TODO: GENERATE ANOTHER WAVE")

func _on_timer_timeout() -> void:
	spawn_next_wave()
