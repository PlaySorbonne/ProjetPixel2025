extends InfoPopupBase
class_name TowerInfoPopup


const CARD_INFOS := preload("res://scenes/interface/gameplay_hud/info_popups/card_infos.tscn")


var tower : TowerBase
@onready var cards_container := $ScrollContainer/VBoxContainer


func _ready() -> void:
	$LabelTitle.text = tower.tower_name
	$LabelDescription.text = tower.tower_description
	tower.tower_card_added.connect(add_card_infos)
	for card : Card in tower.cards:
		add_card_infos(card)

func add_card_infos(new_card : Card) -> void:
	var card_infos := CARD_INFOS.instantiate()
	card_infos.card = new_card
	cards_container.add_child(card_infos)
