extends Node
class_name ClickableObject


const OUTLINE_SHADER : Material = preload("res://resources/materials/3d_outline_material.tres")

signal object_selected
signal object_unselected

@export var custom_nodes : Array[MeshInstance3D] = []

@onready var selected_nodes : Array[MeshInstance3D] = init_selected_node3d()


func select() -> void:
	emit_signal("object_selected")
	for mesh_node : MeshInstance3D in selected_nodes:
		mesh_node.material_overlay = OUTLINE_SHADER

func deselect() -> void:
	emit_signal("object_unselected")
	for mesh_node : MeshInstance3D in selected_nodes:
		mesh_node.material_overlay = null

func init_selected_node3d() -> Array[MeshInstance3D]:
	if custom_nodes.is_empty():
		var _mesh_nodes : Array[MeshInstance3D] = []
		for object_node : Node in get_parent().get_children(true):
			if object_node is MeshInstance3D:
				_mesh_nodes.append(object_node)
		return _mesh_nodes
	else:
		return custom_nodes
