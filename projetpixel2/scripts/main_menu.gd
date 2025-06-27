extends Submenu
class_name MainMenu


const MENU_COLLECTION : Submenu = preload("res://scenes/interface/menus/submenus/collection_menu.tscn")



func _on_button_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world/world.tscn")

func _on_button_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world/world_tuto.tscn")

func _on_button_debug_cards_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/interface/menus/submenus/cards_test_menu.tscn")

func _on_button_quit_pressed() -> void:
	get_tree().quit()

func _on_button_collection_pressed() -> void:
	go_to_screen(MENU_COLLECTION)
