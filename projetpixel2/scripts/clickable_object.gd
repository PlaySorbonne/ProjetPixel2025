extends Node
class_name ClickableObject


const OUTLINE_SHADER : Material = preload("res://resources/materials/3d_outline_material.tres")

signal object_selected
signal object_right_clicked
signal object_unselected
signal object_hovered
signal object_unhovered

@export var custom_nodes : Array[MeshInstance3D] = []

@onready var selected_nodes : Array[MeshInstance3D] = init_selected_node3d()


func hover() -> void:
	emit_signal("object_hovered")
	#print("SELECTED NODES = " + str(selected_nodes)) 
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

func right_click() -> void:
	if not GV.is_dragging_object:
		emit_signal("object_right_clicked")

func deselect() -> void:
	if not GV.is_dragging_object:
		emit_signal("object_unselected")
		#print("OBJECT UNSELECTED")

func init_selected_node3d() -> Array[MeshInstance3D]:
	# check if custom nodes are valid
	for subnode : MeshInstance3D in custom_nodes:
		if not is_instance_valid(subnode):
			print_debug("INVALID MESH IN OBJECT [" + str(get_parent()) + "]")
			custom_nodes.clear()
			break
	if custom_nodes.is_empty():
		return get_all_submeshes(get_parent())
	else:
		return custom_nodes

func get_all_submeshes(node : Node) -> Array[MeshInstance3D]:
	var submeshes : Array[MeshInstance3D]
	for child_node : Node in node.get_children(true):
		submeshes.append_array(get_all_submeshes(child_node))
		if child_node is MeshInstance3D:
			submeshes.append(child_node)
	return submeshes
