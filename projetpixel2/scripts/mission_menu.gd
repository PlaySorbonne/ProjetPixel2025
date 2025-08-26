extends Submenu
class_name MissionMenu





func _on_button_play_pressed() -> void:
	GV.persistent_menu_world.camera_movement(
			GV.persistent_menu_world.markers_dict[
			PersistentMenuWorld.CameraMarkers.StartGame]
	)
	var tween := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($FadeTransition, "color", Color.BLACK, 0.5)
	await tween.finished
	get_tree().change_scene_to_file(GV.WORLD_FILE)
