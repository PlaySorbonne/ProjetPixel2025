extends Booster
class_name RareBooster


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	super._on_animation_player_animation_finished(_anim_name)
	draw_cards(2, CardData.CardRarities.Common)
	diplay_cards_choice(4)
