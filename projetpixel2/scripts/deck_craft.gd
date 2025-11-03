extends Control
class_name DeckCraftSubmenu



@onready var spacer := $CardsScrollContainer/CardContainer/Spacer
@onready var card_container := $CardsScrollContainer/CardContainer


func _ready() -> void:
	card_container.custom_minimum_size = $CardsScrollContainer.size
	spacer.custom_minimum_size.x = card_container.custom_minimum_size.x
	for card : CardData in CardData.cards_data.values():
		var card_obj := CardObject.create_card_object(card)
		card_container.add_child(card_obj)
		CardCheck.add_card_check(card_obj)
