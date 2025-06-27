extends Submenu
class_name MissionMenu


func _on_button_play_pressed() -> void:
	var tween := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($FadeTransition, "color", Color.BLACK, 0.5)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/world/world.tscn")
