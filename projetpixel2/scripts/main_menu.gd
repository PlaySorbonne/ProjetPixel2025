extends Submenu
class_name MainMenu


func _on_button_play_pressed() -> void:
	GV.persistent_menu_world.camera_movement(GV.persistent_menu_world.marker_cam_play)
	#go_to_screen()

func _on_button_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world/world_tuto.tscn")

func _on_button_debug_cards_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/interface/menus/submenus/cards_test_menu.tscn")

func _on_button_quit_pressed() -> void:
	get_tree().quit()

func _on_button_collection_pressed() -> void:
	go_to_screen(COLLECTION_MENU, GV.persistent_menu_world.marker_cam_collection)
