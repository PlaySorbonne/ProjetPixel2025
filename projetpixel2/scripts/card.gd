extends Resource
class_name Card


const CARDS_FILE_PATH := "res://game_design/card_data.csv"

enum CardRarities {Common, Uncommon, Rare, Legendary, Secret}

static var cards_data : Dictionary[String, Card] = {}

var name := "blank_card"
var description := "blank description"
var value := 1
var rarity : CardRarities = CardRarities.Common
var trigger_signal : String = "tower_fired" # the target's signal that triggers the effect
var trigger_condition : Expression  # a boolean function to make sure the effect triggers
var effect : Array[Expression] # the method to call when the effect triggers
# active variables
var tower : TowerBase
var projectile : ProjectileBase
var enemy : BaseEnemy

static func load_cards_data() -> void:
	cards_data = {}
	var card_file := FileAccess.open(CARDS_FILE_PATH, FileAccess.READ)
	card_file.get_csv_line() # remove the top line, which is just titles
	while not card_file.eof_reached():
		var new_card := Card.new()
		new_card.parse_from_csv(card_file.get_csv_line())
		cards_data[new_card.name] = new_card
	card_file.close()
	print("parse complete, dictionary:")
	for k : String in cards_data.keys():
		print("\n" + k + " : " + cards_data[k].card_to_string())

func execute_card() -> bool:
	# if trigger condition ok, execute effect
	if trigger_condition.execute([], self):
		for effect : Expression in effect:
			effect.execute([], self)
		return true
	else:
		return false

func parse_from_csv(csv_line : PackedStringArray) -> void:
	name = csv_line[0]
	description = csv_line[1]
	value = int(csv_line[2])
	@warning_ignore("int_as_enum_without_cast")
	rarity = int(csv_line[3])
	trigger_signal = csv_line[4]
	trigger_condition = Expression.new()
	if csv_line[5] == "":
		trigger_condition.parse("true")
	else:
		var err := trigger_condition.parse(csv_line[5])
		if err != Error.OK:
			print_debug("error parsing card: " + name + " -> bad condition [" + csv_line[5] + "]")
	effect = []
	for effect_line : String in csv_line[6].split("\n"):
		var effect_expr := Expression.new()
		var err := effect_expr.parse(effect_line)
		if err != Error.OK:
			print_debug("error parsing card: " + name + " -> bad effect [" + csv_line[6] + "]")
		effect.append(effect_expr)

func card_to_string() -> String:
	var card_string = "card[name='"+name+"', description='"+description
	card_string += "', value="+str(value)+", rarity="+str(rarity)+", trigger_signal='"
	card_string += trigger_signal+"', trigger_condition='"+str(trigger_condition)
	card_string += "', effect="+str(effect)+"']"
	return card_string
