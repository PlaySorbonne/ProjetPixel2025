extends CanvasLayer
class_name PlayerHud


const TOWER_RES := preload("res://scenes/spaceship/towers/tower_base.tscn")
const TOWERS_OFFSET := Vector2(-10, 0)

var in_combo := false
var available_towers := 0

# components
@onready var mouse_cursor_hint : MouseCursorHint = $MouseCursorHint
@onready var tower_spawner : TowerSpawner = $TowerSpawner
@onready var mouse_3d_interaction : Mouse3dInteraction = $Mouse3dInteraction
@onready var combo_label : Label = $ComboCounter/Label


func _ready() -> void:
	GV.hud = self
	RunData.connect("enemy_killed", new_kill)
	RunData.connect("experience_gained", update_experience)
	RunData.connect("level_gained", update_level)
	update_level()
	
	await get_tree().create_timer(1).timeout
	for i in range(99):
		add_available_tower()
		await get_tree().create_timer(5).timeout

func update_experience() -> void:
	$ExperienceBar.value = RunData.current_experience

func update_level() -> void:
	$ExperienceBar/Label.text = "Level " + str(RunData.current_level)
	$ExperienceBar.max_value = RunData.level_experience_threshold

func new_kill() -> void:
	$ComboCounter/ComboTimer.start(RunData.combo_max_time)
	if in_combo:
		RunData.current_combo += RunData.combo_increment
	else:
		in_combo = true
	update_combo_label()

func update_combo_label() -> void:
	combo_label.text = "Combo: " + str(RunData.current_combo)

func add_available_tower() -> void:
	print_debug("new tower!")
	var tower_pos := GV.player_camera.project_position(
		Vector2(50, 50) + TOWERS_OFFSET * available_towers, 50.0)
	available_towers += 1
	var new_tower := TOWER_RES.instantiate()
	new_tower.is_hologram = true
	GV.world.add_child(new_tower)
	new_tower.position = tower_pos

func _on_create_tower_window_tower_placed() -> void:
	tower_spawner.spawn_tower(
		TowersData.tower_types[0],
		mouse_3d_interaction.mouse_3d_position
	)

func _on_combo_timer_timeout() -> void:
	in_combo = false
	RunData.current_combo = 0
	update_combo_label()
