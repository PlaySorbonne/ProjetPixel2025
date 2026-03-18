extends Booster
class_name CommonBooster


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	super._on_animation_player_animation_finished(_anim_name)
	draw_cards()
	destroy_booster()
