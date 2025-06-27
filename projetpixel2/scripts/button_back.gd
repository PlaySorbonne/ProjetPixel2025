extends Button
class_name BackButton


@export var previous_screen : Submenu.MenuScreens
@export var camera_marker : PersistentMenuWorld.CameraMarkers

@onready var parent_submenu : Submenu = get_parent()


func _on_pressed() -> void:
	parent_submenu.go_to_screen(
		Submenu.SCREENS[previous_screen],
		GV.persistent_menu_world.markers_dict[camera_marker]
	)
