extends Node3D
class_name Mouse3dInteraction

const DIST := 1000.0

signal select_new_object(object : Node3D)

var mouse := Vector2.ZERO
var hovered_object : Node3D = null
var hovered_object_path : String = ""
var selected_object : Node3D = null
var selected_object_path : String = ""
var mouse_3d_position : Vector3


func _ready() -> void:
	GV.mouse_3d_interaction = self

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse = event.position
		var obj : Node3D = mouse_get_world_object()
		if obj == null:
			unhover_object()
			emit_signal("select_new_object", null)
		elif obj != hovered_object:
			unhover_object()
			hover_object(obj)
			emit_signal("select_new_object", obj)
	elif event.is_action_pressed("click"):
		if get_node_or_null(hovered_object_path) != null:
			deselect_current_object()
			click_object(hovered_object)
			InfoPopup.add_popup(selected_object)
			print("Select object " + str(selected_object))
		else:
			deselect_current_object()
			print("No object selected!")

func hover_object(obj : Node3D) -> void:
	hovered_object = obj
	hovered_object_path = obj.get_path()
	var obj_clickable : ClickableObject = hovered_object.clickable
	obj_clickable.hover()

func unhover_object() -> void:
	if get_node_or_null(hovered_object_path) != null:
		var obj_clickable : ClickableObject = hovered_object.clickable
		obj_clickable.unhover()
	hovered_object = null
	hovered_object_path = ""

func deselect_current_object() -> void:
	if get_node_or_null(selected_object_path) != null:
		var obj_clickable : ClickableObject = selected_object.clickable
		obj_clickable.deselect()
	selected_object = null
	selected_object_path = ""

func click_object(obj : Node3D) -> void:
	selected_object = obj
	selected_object_path = obj.get_path()
	var obj_clickable : ClickableObject = selected_object.clickable
	obj_clickable.select()

func get_mouse_raycast() -> Dictionary:
	var space := get_world_3d().direct_space_state
	var start := get_viewport().get_camera_3d().project_ray_origin(mouse)
	var end := get_viewport().get_camera_3d().project_position(mouse, DIST)
	var params := PhysicsRayQueryParameters3D.new()
	params.from = start
	params.to = end
	var result := space.intersect_ray(params)
	return result

func mouse_get_world_position() -> Vector3:
	var result := get_mouse_raycast()
	return result["position"]

func mouse_get_world_object() -> Node3D:
	var result := get_mouse_raycast()
	if result.is_empty():
		return null
	else:
		mouse_3d_position = result["position"]
		if not "clickable" in result["collider"]:
			return null
		else:
			var collider_node : Node3D = result["collider"]
			mouse_3d_position = result["position"]
			if "damageable" in collider_node:
				var collider_dmg : DamageableObject = collider_node.damageable
			return collider_node
