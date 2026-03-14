extends Booster
class_name RareBooster


const RARE_BOOSTER_RES := preload("res://scenes/interface/cards/boosters/rare_booster.tscn")

static func spawn_booster(nparent : Node) -> Booster:
	return super._spawn_booster_from_res(nparent, RARE_BOOSTER_RES)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	super._on_animation_player_animation_finished(_anim_name)
	draw_cards(2, CardData.CardRarities.Common)
	diplay_cards_choice(4)
