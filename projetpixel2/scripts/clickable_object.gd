extends Node
class_name ClickableObject


const OUTLINE_SHADER := preload("res://resources/shaders/3d_outline.gdshader")

@export var custom_node3d : Node3D = null

@onready var selected_node3d : Node3D = init_selected_node3d()


func select() -> void:
	pass

func unselect() -> void:
	pass

func init_selected_node3d() -> Node3D:
	if custom_node3d == null:
		return get_parent()
	else:
		return custom_node3d
