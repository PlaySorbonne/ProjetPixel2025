extends Control
class_name Booster


signal booster_opened

const BOOSTER_RES := preload("res://scenes/interface/cards/booster.tscn")


static func spawn_booster(nparent : Node, pos : Vector2) -> Booster:
	var new_booster := BOOSTER_RES.instantiate()
	new_booster.position = pos
	nparent.add_child(new_booster)
	return new_booster


func open_booster() -> void:
	await get_tree().create_timer(0.5).timeout
	$AnimationPlayer.play("open_booster")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	booster_opened.emit()

func destroy_booster() -> void:
	var t := create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	t.tween_property(self, "scale", Vector2.ZERO, 0.75)
	t.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	t.finished.connect(queue_free)
