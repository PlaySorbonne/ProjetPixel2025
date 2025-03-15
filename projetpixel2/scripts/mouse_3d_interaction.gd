extends Node3D
class_name Mouse3dInteraction

const DIST := 1000.0

var mouse := Vector2.ZERO
var selected_object : Node3D = null
var selected_object_path : String = ""

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse = event.position
	if Input.is_action_just_pressed("click"):
		var obj : Node3D = mouse_get_world_object(mouse)
		if obj != null:
			click_object(obj)

func deselect_current_object() -> void:
	if get_node_or_null(selected_object_path) != null:
		

func click_object(obj : Node3D) -> void:
	pass

func mouse_get_world_object(mouse : Vector2) -> Node3D:
	var space := get_world_3d().direct_space_state
	var start := get_viewport().get_camera_3d().project_ray_origin(mouse)
	var end := get_viewport().get_camera_3d().project_position(mouse, DIST)
	var params := PhysicsRayQueryParameters3D.new()
	params.from = start
	params.to = end
	var result := space.intersect_ray(params)
	
	if result.is_empty():
		print("mouse clicked nothing")
		return null
	else:
		var debug_text := "mouse clicked: " + str(result["collider"])
		var collider_node : Node3D = result["collider"]
		if "damageable" in collider_node:
			var collider_dmg : DamageableObject = collider_node.damageable
			debug_text += " ; with " + str(collider_dmg.health) + " hitpoints"
		else:
			debug_text += " ; not damageable"
		print(debug_text)
		return collider_node
