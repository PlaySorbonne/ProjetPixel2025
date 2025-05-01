extends Resource
class_name Card


const CARDS_FILE_PATH := "res://game_design/card_data.csv"

enum CardRarities {Common, Uncommon, Rare, Legendary, Secret}

static var cards_data : Dictionary[String, Card] = {}
static var current_deck : Array[Card] = []

var name := "blank_card"
var description := "blank description"
var value := 1
var rarity : CardRarities = CardRarities.Common
var trigger_signal : String = "tower_fired" # the target's signal that triggers the effect
var trigger_condition : Callable  # a boolean function to make sure the effect triggers
var effect : Callable # the method to call when the effect triggers
var card_code : RefCounted
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
	for card : Card in cards_data.values():
		current_deck.append(card)

static func draw_first_deck_dard() -> Card:
	return current_deck.pop_front()

static func get_random_card() -> Card:
	return current_deck.pick_random()

func execute_card() -> bool:
	# if trigger condition ok, execute effect
	if trigger_condition.callv([tower, projectile, enemy]):
		effect.callv([tower, projectile, enemy])
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
	
	var card_code_source : GDScript = GDScript.new()
	# create condition code
	card_code_source.source_code = "func check_condition(tower : TowerBase = null, projectile : ProjectileBase = null, enemy : BaseEnemy = null):"
	if csv_line[5] == "":
		card_code_source.source_code += "\n\treturn true"
	else:
		card_code_source.source_code += "\n\treturn " + csv_line[5]
	
	# create effect code
	card_code_source.source_code += "\n\nfunc run_effect(tower : TowerBase = null, projectile : ProjectileBase = null, enemy : BaseEnemy = null):"
	for effect_line : String in csv_line[6].split("\n"):
		card_code_source.source_code += "\n\t" + effect_line
	
	# create resource and connect everything
	card_code_source.reload()
	card_code = card_code_source.new()
	trigger_condition = Callable(card_code, "check_condition")
	effect = Callable(card_code, "run_effect")

func card_to_string() -> String:
	var card_string = "card[name='"+name+"', description='"+description
	card_string += "', value="+str(value)+", rarity="+str(rarity)+", trigger_signal='"
	card_string += trigger_signal+"', trigger_condition='"+str(trigger_condition)
	card_string += "', effect="+str(effect)+"']"
	return card_string
