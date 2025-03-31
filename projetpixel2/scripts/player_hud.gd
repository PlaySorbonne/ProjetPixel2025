extends CanvasLayer
class_name PlayerHud


var in_combo := false

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

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if mouse_3d_interaction.selected_object != null and is_instance_valid(
								mouse_3d_interaction.selected_object):
			print("Select object " + str(mouse_3d_interaction.selected_object))
		else:
			print("No object selected!")

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

func _on_create_tower_window_tower_placed() -> void:
	tower_spawner.spawn_tower(
		TowersData.tower_types[0],
		mouse_3d_interaction.clicked_location
	)

func _on_combo_timer_timeout() -> void:
	in_combo = false
	RunData.current_combo = 0
	update_combo_label()
