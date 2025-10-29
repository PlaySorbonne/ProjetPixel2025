extends Submenu
class_name CraftMenu


@onready var card_container := $DeckCraft/CardContainer

func _ready() -> void:
	#print("CardData.cards_data = ")
	#print(CardData.cards_data)
	for card : CardData in CardData.cards_data.values():
		var card_obj := CardObject.create_card_object(card)
		card_container.add_child(card_obj)
		CardCheck.add_card_check(card_obj)
