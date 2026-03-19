extends Button
class_name AnimatedButton


var t : Tween

func get_tween() -> Tween:
	_update_tween()
	return t

func _update_tween() -> void:
	if t:
		t.kill()
	t = create_tween().set_ease(Tween.EASE_IN_OUT)

func _on_mouse_entered() -> void:
	_update_tween()
	t.tween_property(self, "scale", Vector2(1.05, 1.05), 0.15)

func _on_mouse_exited() -> void:
	_update_tween()
	t.tween_property(self, "scale", Vector2.ONE, 0.15)
