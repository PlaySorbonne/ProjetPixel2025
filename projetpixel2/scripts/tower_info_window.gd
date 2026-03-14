extends CasinoWindow
class_name TowerInfoWindow


const CARD_INFOS := preload("res://scenes/interface/gameplay_hud/info_popups/card_infos.tscn")


var tower : TowerBase
@onready var cards_container := $Contents/ScrollContainer/VBoxContainer


func _ready() -> void:
	super._ready()
	tower.tower_card_added.connect(_add_card_infos)
	for card : CardData in tower.cards:
		_add_card_infos(card)

func _add_card_infos(new_card : CardData) -> void:
	var card_infos := CARD_INFOS.instantiate()
	card_infos.card = new_card
	cards_container.add_child(card_infos)
