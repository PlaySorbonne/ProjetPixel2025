@tool
extends Button
class_name ButtonScifi


@export var button_text := "Button text":
	set(value):
		button_text = value
		$Label.text = value
var hover_tween : Tween


func _ready() -> void:
	pivot_offset = size/2.0

func _init_hover_tween() -> void:
	if hover_tween:
		hover_tween.kill()
	hover_tween = create_tween().set_ease(Tween.EASE_IN_OUT)

func _on_mouse_entered() -> void:
	_init_hover_tween()
	hover_tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.15)

func _on_mouse_exited() -> void:
	_init_hover_tween()
	hover_tween.tween_property(self, "scale", Vector2.ONE, 0.15)
