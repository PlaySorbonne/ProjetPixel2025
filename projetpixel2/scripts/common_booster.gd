extends Booster
class_name CommonBooster


const COMMON_BOOSTER_RES := preload("res://scenes/interface/cards/boosters/common_booster.tscn")

static func spawn_booster(nparent : Node) -> Booster:
	return super._spawn_booster_from_res(nparent, COMMON_BOOSTER_RES)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	super._on_animation_player_animation_finished(_anim_name)
	draw_cards(3, CardData.CardRarities.Common)
	destroy_booster()
