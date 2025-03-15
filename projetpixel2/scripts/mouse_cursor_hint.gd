extends Control
class_name MouseCursorHint


func add_mouse_hint() -> void:
	$TextureRect.global_position = get_global_mouse_position()
	show_mouse_hint()

func show_mouse_hint() -> void:
	$TextureRect.visible = true

func hide_mouse_hint() -> void:
	$TextureRect.visible = false
