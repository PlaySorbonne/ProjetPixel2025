extends Control
class_name DragAndDrop

signal dragged
signal dropped

@export var dragged_object : Node2D = null

var is_dragged := false


func drag() -> void:
	is_dragged = true
	emit_signal("dragged")

func drop() -> void:
	is_dragged = false
	emit_signal("dropped")

func _process(delta: float) -> void:
	if is_dragged:
		dragged_object.global_position = get_global_mouse_position()
		if Input.is_action_just_released("click"):
			drop()
