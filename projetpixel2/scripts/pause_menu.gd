extends Control
class_name PauseMenu


var is_game_paused := false


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		set_paused(not is_game_paused)

func set_paused(new_pause : bool) -> void:
	is_game_paused = new_pause
	get_tree().paused = is_game_paused
	visible = is_game_paused
	if is_game_paused:
		pass
	else:
		pass

func _on_button_continue_pressed() -> void:
	set_paused(false)

func _on_button_restart_pressed() -> void:
	get_tree().paused = false
	GV.reset_gameplay_variables()
	get_tree().reload_current_scene()

func _on_button_quit_pressed() -> void:
	get_tree().paused = false
	GV.reset_gameplay_variables()
	get_tree().change_scene_to_file("res://scenes/interface/menus/persistent_menu.tscn")
