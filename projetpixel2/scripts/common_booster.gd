extends Booster
class_name CommonBooster


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	super._on_animation_player_animation_finished(_anim_name)
	draw_cards(3, CardData.CardRarities.Common)
	await get_tree().create_timer(1.2).timeout
	destroy_booster()
