extends CanvasLayer

var progress := 1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		match progress:
			0:
				$TextureRect1.visible = true
			1:
				$TextureRect2.visible = true
			2:
				$TextureRect3.visible = true
			3:
				get_tree().change_scene_to_file("res://scenes/interface/menus/persistent_menu.tscn")
		progress += 1
