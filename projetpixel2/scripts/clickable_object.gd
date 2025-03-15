extends Node
class_name ClickableObject


const OUTLINE_SHADER := preload("res://resources/shaders/3d_outline.gdshader")

signal object_selected
signal object_unselected

@export var custom_node3d : Node3D = null

@onready var selected_node3d : Node3D = init_selected_node3d()


func select() -> void:
	emit_signal("object_selected")
	selected_node3d.material

func unselect() -> void:
	emit_signal("object_unselected")

func init_selected_node3d() -> Node3D:
	if custom_node3d == null:
		return get_parent()
	else:
		return custom_node3d
