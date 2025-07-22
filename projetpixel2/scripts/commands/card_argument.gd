extends Argument
class_name CardArgument

var card_data: CardData

func _init(argument: String):
	if not (argument in CardData.cards_data.keys()):
		self.error = true
		return
	card_data = CardData.cards_data[argument] 
