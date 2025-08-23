extends Submenu
class_name CardsTestMenu


func _ready() -> void:
	CardData.load_cards_data()
	display_cards()

func display_cards() -> void:
	for card_name : String in CardData.cards_data.keys():
		var card_label := Label.new()
		$ColorRect/ScrollContainer/CardsBox.add_child(card_label)
		card_label.text = card_name
