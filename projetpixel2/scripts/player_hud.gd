extends CanvasLayer
class_name PlayerHud


var in_combo := false

# components
@onready var object_info : ObjectInfoWindow = $hud_control/ObjectInfoWindow
@onready var create_towers : CreateTowerWindow = $hud_control/CreateTowerWindow
@onready var mouse_cursor_hint : MouseCursorHint = $MouseCursorHint
@onready var tower_spawner : TowerSpawner = $TowerSpawner
@onready var mouse_3d_interaction : Mouse3dInteraction = $Mouse3dInteraction
@onready var combo_label : Label = $ComboCounter/Label


func _ready() -> void:
	GV.hud = self
	RunData.connect("enemy_killed", new_kill)

func new_kill() -> void:
	$ComboCounter/ComboTimer.start(RunData.combo_max_time)
	if in_combo:
		RunData.current_combo += RunData.combo_increment
	else:
		in_combo = true
	update_combo_label()

func update_combo_label() -> void:
	combo_label.text = "Combo: " + str(RunData.current_combo)

func _on_mouse_3d_interaction_select_new_object(object: Node3D) -> void:
	if object == null:
		mouse_cursor_hint.add_mouse_hint()
		object_info.deselect_object()
		create_towers.show_window()
	else:
		object_info.select_object(object)
		mouse_cursor_hint.hide_mouse_hint()
		create_towers.hide_window()

func _on_create_tower_window_tower_placed() -> void:
	tower_spawner.spawn_tower(
		TowersData.tower_types[0],
		mouse_3d_interaction.clicked_location
	)

func _on_combo_timer_timeout() -> void:
	in_combo = false
	RunData.current_combo = 0
	update_combo_label()
