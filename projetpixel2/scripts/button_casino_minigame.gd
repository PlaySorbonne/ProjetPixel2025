extends Button
class_name CasinoMinigameButton


@export var minigame_popup : PackedScene

var can_launch_minigame := true


func _on_pressed() -> void:
	if can_launch_minigame:
		var popup : CasinoWindow = minigame_popup.instantiate()
		popup.visible = false
		var pos_rect :=  GV.hud.game_panel.size - popup.size
		GV.hud.add_child(popup)
		await get_tree().process_frame
		popup.position = popup.random_popup_position()
		popup.open_window()
