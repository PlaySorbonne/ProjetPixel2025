extends Button
class_name CardObject

class Card:
	var name := "blank_card"
	var description := "blank description"
	var value := 1
	var rarity : CardRarities = CardRarities.Common
	var trigger_signal : String = "tower_fired" # the target's signal that triggers the effect
	var trigger_condition : Expression  # a boolean function to make sure the effect triggers
	var effect : Array[Expression] # the method to call when the effect triggers

enum CardRarities {Common, Uncommon, Rare, Legendary, Secret}

const CARDS_FILE_PATH := "tower_cards_data"

static var cards_data : Dictionary[String, Card] = {}

var card := Card.new()
var tower : TowerBase
var projectile : ProjectileBase
var enemy : BaseEnemy


static func load_cards_data() -> void:
	cards_data = {}
	var card_file := FileAccess.open(CARDS_FILE_PATH, FileAccess.READ)
	while not card_file.eof_reached():
		var card_valid := true
		var csv_line : PackedStringArray = card_file.get_csv_line()
		var new_card := Card.new()
		new_card.name = csv_line[0]
		new_card.description = csv_line[1]
		new_card.value = int(csv_line[2])
		new_card.rarity = int(csv_line[3])
		new_card.trigger_signal = csv_line[4]
		new_card.trigger_condition = Expression.new()
		if csv_line[5] == "":
			new_card.trigger_condition.parse("true")
		else:
			var err := new_card.trigger_condition.parse(csv_line[5])
			if err != Error.OK:
				print_debug("error parsing card: " + new_card.name + " -> bad condition [" + csv_line[5] + "]")
				card_valid = false
		new_card.effect = []
		for effect_line : String in csv_line[6].split("\n"):
			var effect_expr := Expression.new()
			var err := effect_expr.parse(effect_line)
			if err != Error.OK:
				print_debug("error parsing card: " + new_card.name + " -> bad effect [" + csv_line[6] + "]")
				card_valid = false
			new_card.effect.append(effect_expr)
		if card_valid:
			cards_data[new_card.name] = new_card
	card_file.close()
	print_debug("parse complete, dictionary = " + str(cards_data))

func execute_card() -> bool:
	# if trigger condition ok, execute effect
	if card.card_trigger_condition.execute([], self):
		for effect : Expression in card.effect:
			effect.execute([], self)
		return true
	else:
		return false
