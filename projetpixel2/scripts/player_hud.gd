extends CanvasLayer
class_name PlayerHud


# components
@onready var object_info : ObjectInfoWindow = $hud_control/ObjectInfoWindow
@onready var create_towers : CreateTowerWindow = $hud_control/CreateTowerWindow
@onready var mouse_cursor_hint : MouseCursorHint = $MouseCursorHint
@onready var tower_spawner : TowerSpawner = $TowerSpawner
@onready var mouse_3d_interaction : Mouse3dInteraction = $Mouse3dInteraction


func _ready() -> void:
	pass

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
