extends DragAndDrop
class_name DragAndDrop2D


@export var dragged_object : Node = null

var offset := Vector2.ZERO


func drag() -> void:
	super.drag()
	offset = dragged_object.global_position - $Control.get_global_mouse_position()

func _process(delta: float) -> void:
	if is_dragged:
		dragged_object.global_position = $Control.get_global_mouse_position() + offset
