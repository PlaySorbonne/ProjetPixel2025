@tool
extends Button
class_name DeckTextureButton


@export var texture_index : int:
	set(value):
		texture_index = value
		icon = Deck.DECK_TEXTURES[value]
var anim_tween : Tween


func _on_mouse_entered() -> void:
	if anim_tween:
		anim_tween.kill()
	anim_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	anim_tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.15)
	anim_tween.tween_property(self, "modulate", Color.WHITE, 0.15)

func _on_mouse_exited() -> void:
	if anim_tween:
		anim_tween.kill()
	anim_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	anim_tween.tween_property(self, "scale", Vector2.ONE, 0.15)
	anim_tween.tween_property(self, "modulate", Color(0.8, 0.8, 0.8), 0.15)
