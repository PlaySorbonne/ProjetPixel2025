extends Resource
class_name Deck


const DECK_TEXTURES := [
	preload("res://resources/images/cards/deck_back_black.png"),
	preload("res://resources/images/cards/deck_back_blue.png"),
	preload("res://resources/images/cards/deck_back_cyan.png"),
	preload("res://resources/images/cards/deck_back_green.png"),
	preload("res://resources/images/cards/deck_back_orange.png"),
	preload("res://resources/images/cards/deck_back_purple.png"),
	preload("res://resources/images/cards/deck_back_red.png"),
	preload("res://resources/images/cards/deck_back_white.png"),
	preload("res://resources/images/cards/deck_back_yellow.png"),
	preload("res://resources/images/cards/deck_back_checkered.png")
]
const DECK_COLORS := [
	Color.DARK_SLATE_GRAY,
	Color.BLUE,
	Color.CYAN,
	Color.LIME_GREEN,
	Color.ORANGE,
	Color.PURPLE,
	Color.RED,
	Color.LIGHT_GRAY,
	Color.YELLOW,
	Color.BLACK
]


@export var name := "My deck"
@export var texture_index : int = 0
@export var cards : Array[String] = []


func _init(nname : String, ntexture_index : int, ncards : Array[String]) -> void:
	name = nname
	texture_index = ntexture_index
	cards = ncards

func deck_to_string() -> String:
	var deck_str : String = "DECK " + name + " (" + str(texture_index) + ") ["
	for card : CardData in get_cards():
		deck_str += "\n\t" + card.name
	return deck_str + "\n]"

func get_cards() -> Array[CardData]:
	var cards_data : Array[CardData] = []
	for card_name : String in cards:
		cards_data.append(CardData.cards_data[card_name])
	return cards_data
