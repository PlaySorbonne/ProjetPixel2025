extends Control
class_name ObjectInfoWindow


var is_window_displayed := false
var selected_object : Node3D = null
var selected_clickable : ClickableObject = null
var obj_damageable : DamageableObject = null

func _ready() -> void:
	$Label.text = ""
	scale = Vector2.ZERO

func display_window() -> void:
	is_window_displayed = true
	$AnimationPlayer.play("show")

func hide_window() -> void:
	is_window_displayed = false
	$AnimationPlayer.play("hide")

func select_object(new_obj : Node3D) -> void:
	if new_obj == null:
		deselect_object()
		return
	if not is_window_displayed:
		display_window()
	selected_object = new_obj
	selected_clickable = selected_object.clickable
	if "damageable" in selected_object:
		obj_damageable = selected_object.damageable
		obj_damageable.connect("hit", selected_obj_hit)
	else:
		obj_damageable = null
	update_object_infos()

func deselect_object() -> void:
	selected_object = null
	$Label.text = "No selected object."
	if is_window_displayed:
		hide_window()

func selected_obj_hit(_dmg : int, _new_health : int) -> void:
	update_object_infos()

func update_object_infos() -> void:
	var health_str : String = ""
	if obj_damageable != null:
		health_str = str(obj_damageable.health) + " / " + str(obj_damageable.max_health)
	$Label.text = str(selected_object) + """\nObject description description description
""" + health_str
