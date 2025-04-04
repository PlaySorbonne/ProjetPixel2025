extends Node3D
class_name Mouse3dInteraction

const DIST := 1000.0

signal select_new_object(object : Node3D)

var mouse := Vector2.ZERO
var selected_object : Node3D = null
var selected_object_path : String = ""
var clicked_location : Vector3


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse = event.position
		var obj : Node3D = mouse_get_world_object(mouse)
		if obj == null:
			deselect_current_object()
			emit_signal("select_new_object", null)
		elif obj != selected_object:
			deselect_current_object()
			click_object(obj)
			emit_signal("select_new_object", obj)
	elif event.is_action_pressed("click"):
		if selected_object != null and is_instance_valid(selected_object):
			print("Select object " + str(selected_object))
		else:
			print("No object selected!")

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

func mouse_get_world_object(mouse : Vector2) -> Node3D:
	var space := get_world_3d().direct_space_state
	var start := get_viewport().get_camera_3d().project_ray_origin(mouse)
	var end := get_viewport().get_camera_3d().project_position(mouse, DIST)
	var params := PhysicsRayQueryParameters3D.new()
	params.from = start
	params.to = end
	var result := space.intersect_ray(params)
	
	if result.is_empty():
		return null
	else:
		clicked_location = result["position"]
		if not "clickable" in result["collider"]:
			return null
		else:
			var collider_node : Node3D = result["collider"]
			clicked_location = result["position"]
			if "damageable" in collider_node:
				var collider_dmg : DamageableObject = collider_node.damageable
			return collider_node
