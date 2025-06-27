extends Control
class_name Submenu


enum MenuScreens {TitleScreen, CollectionScreen, PlayScreen, MissionScreen, 
					ResearchScreen, CraftScreen}

static var SCREENS : Dictionary[MenuScreens, PackedScene] = {
	MenuScreens.TitleScreen : load("res://scenes/interface/menus/submenus/main_menu.tscn"),
	MenuScreens.CollectionScreen : load("res://scenes/interface/menus/submenus/collection_menu.tscn"),
	MenuScreens.PlayScreen : load("res://scenes/interface/menus/submenus/play_menu.tscn"),
	MenuScreens.MissionScreen : load("res://scenes/interface/menus/submenus/mission_menu.tscn"),
	MenuScreens.ResearchScreen : load("res://scenes/interface/menus/submenus/research_menu.tscn"),
	MenuScreens.CraftScreen : load("res://scenes/interface/menus/submenus/craft_menu.tscn"),
}

var persistent_menu : PersistentMenu = null
@export var submenu_pos := Vector2(1, 0)


func transition_to_menu() -> void:
	pass

func go_to_screen(new_screen : PackedScene, to_camera_marker : Marker3D) -> void:
	print("new screen = " + str(new_screen) + " ; camera marker = " + str(to_camera_marker))
	GV.persistent_menu_world.camera_movement(to_camera_marker)
	var new_screen_obj : Submenu = new_screen.instantiate()
	GV.persistent_menu.transition_to_menu(new_screen_obj)

func go_to_title_screen() -> void:
	go_to_screen(
		SCREENS[MenuScreens.TitleScreen],
		GV.persistent_menu_world.markers_dict[
				PersistentMenuWorld.CameraMarkers.title_screen]
	)
