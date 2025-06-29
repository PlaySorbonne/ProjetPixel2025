extends Button
class_name MenuTransitionButton


@export var next_screen : Submenu.MenuScreens
@export var camera_marker : PersistentMenuWorld.CameraMarkers

@onready var parent_submenu : Submenu = get_parent()


func _on_pressed() -> void:
	parent_submenu.go_to_screen(
		Submenu.SCREENS[next_screen],
		GV.persistent_menu_world.markers_dict[camera_marker]
	)
