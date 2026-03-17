extends Booster
class_name CommonBooster


@export var number_of_cards := 3

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	super._on_animation_player_animation_finished(_anim_name)
	draw_cards(number_of_cards, CardData.CardRarities.Common)
	destroy_booster()
