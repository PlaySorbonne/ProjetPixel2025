extends Button
class_name CasinoMinigameButton


@export var minigame_popup : PackedScene

var can_launch_minigame := true


func _random_popup_position(pos_min : Vector2, pos_rect : Vector2) -> Vector2:
	const POSITION_MAX_OFFSET := 15.0
	return pos_min + Vector2(
		pos_rect.x * randf() + randf_range(-POSITION_MAX_OFFSET, POSITION_MAX_OFFSET),
		pos_rect.y * randf() + randf_range(-POSITION_MAX_OFFSET, POSITION_MAX_OFFSET)
	)

func _on_pressed() -> void:
	if can_launch_minigame:
		var popup : CasinoWindow = minigame_popup.instantiate()
		popup.visible = false
		var pos_min := GV.hud.game_panel.position
		var pos_rect :=  GV.hud.game_panel.size - popup.size
		GV.hud.add_child(popup)
		await get_tree().process_frame
		popup.position = _random_popup_position(pos_min, pos_rect)
		popup.open_window()
