extends Control
class_name Submenu


const MAIN_MENU := preload("res://scenes/interface/menus/submenus/main_menu.tscn")
const COLLECTION_MENU := preload("res://scenes/interface/menus/submenus/collection_menu.tscn")
const PLAY_MENU := preload("res://scenes/interface/menus/submenus/play_menu.tscn")
const MISSION_MENU := preload("res://scenes/interface/menus/submenus/mission_menu.tscn")
const RESEARCH_MENU := preload("res://scenes/interface/menus/submenus/research_menu.tscn")
const CRAFT_MENU := preload("res://scenes/interface/menus/submenus/craft_menu.tscn")

var persistent_menu : PersistentMenu = null
@export var submenu_pos := Vector2(1, 0)


func transition_to_menu() -> void:
	pass

func go_to_screen(new_screen : PackedScene, to_camera_marker : Marker3D) -> void:
	GV.persistent_menu_world.camera_movement(to_camera_marker)
	var new_screen_obj : Submenu = new_screen.instantiate()
	GV.persistent_menu.transition_to_menu(new_screen_obj)

func go_to_title_screen() -> void:
	go_to_screen(MAIN_MENU, GV.persistent_menu_world.marker_cam_title)
