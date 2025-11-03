extends Resource
class_name Deck


@export var name := "My deck"
@export var color : Color = Color.RED
@export var cards : Array[String] = []


func _init(nname : String, ncolor : Color, ncards : Array[String]) -> void:
	name = nname
	color = ncolor
	cards = ncards

func deck_to_string() -> String:
	var deck_str : String = "DECK " + name + " (" + str(color) + ") ["
	for card : CardData in get_cards():
		deck_str += "\n\t" + card.name
	return deck_str + "\n]"

func get_cards() -> Array[CardData]:
	var cards_data : Array[CardData] = []
	for card_name : String in cards:
		cards_data.append(CardData.cards_data[card_name])
	return cards_data
