extends Resource
class_name Deck


@export var name := "My deck"
@export var color : Color = Color.RED
@export var cards : Array[CardData] = []


func _init(nname : String, ncolor : Color, ncards : Array[CardData]) -> void:
	name = nname
	color = ncolor
	cards = ncards

func deck_to_string() -> String:
	var deck_str : String = "DECK " + name + " (" + str(color) + ") ["
	for card : CardData in cards:
		deck_str += "\n\t" + card.name
	return deck_str + "\n]"
