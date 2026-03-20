extends Control
class_name ObjectDescription


@export var spawn_offset := Vector2(10.0, 0.0)


var parent_object : Control


func _ready() -> void:
	position = _set_description_position()
	scale = Vector2(0.8, 0.2)
	modulate = Color(1, 1, 1, 0.3)
	var t := create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(
				).set_ignore_time_scale(true)
	t.tween_property(self, "scale", Vector2.ONE, 0.15)
	t.tween_property(self, "modulate", Color.WHITE, 0.15)
	parent_object.mouse_exited.connect(destroy_description)
	await get_tree().process_frame
	visible = true

func _init_description_popup(obj : Control) -> void:
	parent_object = obj
	visible = false
	obj.add_child(self)

func _set_description_position() -> Vector2:
	var viewport_width : float = get_viewport().get_visible_rect().size.x
	var card_pos_x : float = parent_object.global_position.x + parent_object.size.x
	var distance_from_right = viewport_width - card_pos_x
	if distance_from_right < 400:
		return Vector2(-self.size.x, 0.0) - spawn_offset
	else:
		return Vector2(parent_object.size.x, 0.0) + spawn_offset

func destroy_description() -> void:
	var t := create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(
					).set_ignore_time_scale(true)
	t.tween_property(self, "scale", Vector2.ZERO, 0.15)
	t.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.15)
	await t.finished
	queue_free()
