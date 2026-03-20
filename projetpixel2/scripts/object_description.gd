extends Control
class_name ObjectDescription


const X_OFFSET := 10.0


var parent_object : Control


func _ready() -> void:
	position = _set_description_position()
	scale = Vector2(0.8, 0.2)
	modulate = Color(1, 1, 1, 0.3)
	var t := create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(
				).set_ignore_time_scale(true)
	t.tween_property(self, "scale", Vector2.ONE, 0.15)
	t.tween_property(self, "modulate", Color.WHITE, 0.15)
	#rotation = -card_object.rotation
	await get_tree().process_frame
	visible = true

func _set_description_position() -> Vector2:
	var viewport_width : float = get_viewport().get_visible_rect().size.x
	var card_pos_x : float = parent_object.global_position.x + parent_object.size.x
	var distance_from_right = viewport_width - card_pos_x
	if distance_from_right < 400:
		return Vector2(-self.size.x - X_OFFSET, 0.0)
	else:
		return Vector2(parent_object.size.x + X_OFFSET, 0.0)

func destroy_description() -> void:
	var t := create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(
					).set_ignore_time_scale(true)
	t.tween_property(self, "scale", Vector2.ZERO, 0.15)
	t.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.15)
	await t.finished
	queue_free()
