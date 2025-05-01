extends Sprite3D
class_name TowerCard3DIndicator

const DEFAULT_SCALE := Vector3(0.075, 0.075, 0.075)
const INITIAL_POS := Vector3(0.7, 0.5, 0.5)
const OFFSET := Vector3(0.0, 0.0, 0.5)
const INDICATOR_RES := preload("res://scenes/interface/cards/tower_card_3d_indicator.tscn")

static func add_card_indicator(tower : TowerBase) -> TowerCard3DIndicator:
	var indicator := INDICATOR_RES.instantiate()
	tower.add_child(indicator)
	indicator.position = INITIAL_POS + OFFSET * (tower.cards.size() - 1)
	indicator.scale = DEFAULT_SCALE
	return indicator
