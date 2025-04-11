extends DragAndDrop
class_name DragAndDrop3D


@export var dragged_object : Node3D = null


func _process(delta: float) -> void:
	if is_dragged:
		dragged_object.global_position = GV.mouse_3d_interaction.mouse_3d_position
		if Input.is_action_just_pressed("click"):
			press()
		elif Input.is_action_just_released("click"):
			release()
