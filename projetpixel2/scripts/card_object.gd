extends Button
class_name CardObject

class Card:
	var name := "blank_card"
	var description := "blank description"
	var value := 1
	var rarity : CardRarities = CardRarities.Common
	var trigger_signal : String = "tower_fired" # the target's signal that triggers the effect
	var trigger_condition : Expression  # a boolean function to make sure the effect triggers
	var effect_code : Array[Expression] # the method to call when the effect triggers

enum CardRarities {Common, Uncommon, Rare, Legendary, Secret}

const CARDS_FILE_PATH := "tower_cards_data"

static var cards_data : Dictionary = {}

var card := Card.new()
var tower : TowerBase


static func load_cards_data() -> void:
	cards_data = {}
	var card_file := FileAccess.open(CARDS_FILE_PATH, FileAccess.READ)
	while not card_file.eof_reached():
		var csv_line : PackedStringArray = card_file.get_csv_line()
	card_file.close()

func execute_card() -> bool:
	# if trigger condition ok, execute effect
	if card.card_trigger_condition.execute([], tower):
		for effect : Expression in card.effect_code:
			effect.execute([], tower)
		return true
	else:
		return false
