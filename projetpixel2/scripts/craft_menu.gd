extends Submenu
class_name CraftMenu


@onready var spacer := $DeckCraft/CardsScrollContainer/CardContainer/Spacer
@onready var card_container := $DeckCraft/CardsScrollContainer/CardContainer


func _ready() -> void:
	#print("CardData.cards_data = ")
	#print(CardData.cards_data)
	card_container.custom_minimum_size = $DeckCraft/CardsScrollContainer.size
	spacer.custom_minimum_size.x = card_container.custom_minimum_size.x
	for card : CardData in CardData.cards_data.values():
		var card_obj := CardObject.create_card_object(card)
		card_container.add_child(card_obj)
		CardCheck.add_card_check(card_obj)
