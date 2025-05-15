extends Node
class_name ClickableObject


const OUTLINE_SHADER : Material = preload("res://resources/materials/3d_outline_material.tres")

signal object_selected
signal object_unselected
signal object_hovered
signal object_unhovered

@export var custom_nodes : Array[MeshInstance3D] = []

@onready var selected_nodes : Array[MeshInstance3D] = init_selected_node3d()


func hover() -> void:
	emit_signal("object_hovered")
	for mesh_node : MeshInstance3D in selected_nodes:
		mesh_node.material_overlay = OUTLINE_SHADER

func unhover() -> void:
	emit_signal("object_unhovered")
	for mesh_node : MeshInstance3D in selected_nodes:
		mesh_node.material_overlay = null

func select() -> void:
	if not GV.is_dragging_object:
		emit_signal("object_selected")
		#print("OBJECT SELECTED")

func deselect() -> void:
	if not GV.is_dragging_object:
		emit_signal("object_unselected")
		#print("OBJECT UNSELECTED")

func init_selected_node3d() -> Array[MeshInstance3D]:
	if custom_nodes.is_empty():
		var _mesh_nodes : Array[MeshInstance3D] = []
		for object_node : Node in get_parent().get_children(true):
			if object_node is MeshInstance3D:
				_mesh_nodes.append(object_node)
		return _mesh_nodes
	else:
		return custom_nodes
