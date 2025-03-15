extends Control
class_name ObjectInfoWindow


var selected_object : Node3D = null
var selected_clickable : ClickableObject = null
var obj_damageable : DamageableObject = null

func _ready() -> void:
	pass

func select_object(new_obj : Node3D) -> void:
	selected_object = new_obj
	selected_clickable = selected_clickable.clickable
	if "damageable" in selected_object:
		obj_damageable = selected_object.damageable
		obj_damageable.connect("hit", selected_obj_hit)
	else:
		obj_damageable = null

func deselect_object() -> void:
	selected_object = null

func selected_obj_hit(_dmg : int, _new_health : int) -> void:
	update_object_infos()

func update_object_infos() -> void:
	var health_str : String = ""
	if obj_damageable != null:
		health_str = str(obj_damageable.health) + " / " + str(obj_damageable.max_health)
	$Label.text = str(selected_object) + """\nObject description description description
""" + health_str
