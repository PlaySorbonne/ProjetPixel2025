extends DragAndDrop
class_name DragAndDrop2D

@export var dragged_object : Control = null

func drag() -> void:
	is_dragged = true
	emit_signal("dragged")

func drop() -> void:
	is_dragged = false
	emit_signal("dropped")

func _process(delta: float) -> void:
	if is_dragged:
		dragged_object.global_position = $Control.get_global_mouse_position()
		if Input.is_action_just_released("click"):
			drop()
