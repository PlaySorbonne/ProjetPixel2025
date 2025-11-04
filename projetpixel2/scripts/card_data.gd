extends Resource
class_name CardData


const CARDS_FILE_PATH := "res://game_design/card_data.csv"

enum CardRarities {Common, Uncommon, Rare, Legendary, Secret}
enum CardFamilies {Military, Scientists, Traders, Revolution}

static var cards_data : Dictionary[String, CardData] = {}
static var current_deck : Array[CardData] = []

@export var name := "blank_card"
@export var description := "blank description"
@export var value := 1
@export var rarity : CardRarities = CardRarities.Common
@export var family : CardFamilies = CardFamilies.Military
@export var trigger_signal : String = "tower_fired" # the target's signal that triggers the effect
@export var trigger_condition : Callable  # a boolean function to make sure the effect triggers
@export var effect : Callable # the method to call when the effect triggers
var card_code : RefCounted

static func rarity_to_multiplier(card_rarity : CardRarities) -> float:
	match card_rarity:
		CardRarities.Common:
			return 1.0
		CardRarities.Uncommon:
			return 1.25
		CardRarities.Rare:
			return 1.75
		CardRarities.Legendary:
			return 2.5
		_:
			return 4.0

static func load_deck() -> void:
	SaveData.player_decks[SaveData.selected_deck].cards
	SaveData.unlocked_cards
	current_deck

static func load_cards_data() -> void:
	cards_data = {}
	var card_file := FileAccess.open(CARDS_FILE_PATH, FileAccess.READ)
	card_file.get_csv_line() # remove the top line (column titles)
	while not card_file.eof_reached():
		var new_card := CardData.new()
		new_card.parse_from_csv(card_file.get_csv_line())
		cards_data[new_card.name] = new_card
	card_file.close()
	for card : CardData in cards_data.values():
		current_deck.append(card)

static func get_random_card() -> CardData:
	return cards_data.values().pick_random()

static func get_random_card_from_deck() -> CardData:
	return current_deck.pick_random()

func execute_card(projectile : ProjectileBase, enemy : BaseEnemy) -> bool:
	card_code.projectile = projectile
	card_code.enemy = enemy
	if trigger_condition.call():
		effect.call()
		return true
	else:
		return false

func parse_from_csv(csv_line : PackedStringArray) -> void:
	for i : int in range(len(csv_line)):
		csv_line[i] = csv_line[i].replace("        ", "	")
	name = csv_line[0]
	description = csv_line[1]
	value = int(csv_line[2])
	
	@warning_ignore("int_as_enum_without_cast")
	rarity = CardRarities.get(csv_line[3])
	trigger_signal = csv_line[4]
	
	var card_code_source : GDScript = GDScript.new()
	card_code_source.source_code = "extends CardBase\n"
	# create condition code
	if csv_line[5].begins_with("#"):
		card_code_source.source_code += csv_line[5]
	else:
		card_code_source.source_code += "func check_condition():"
		if csv_line[5] == "":
			card_code_source.source_code += "\n\treturn true"
		else:
			card_code_source.source_code += "\n\treturn " + csv_line[5]
	# create effect code
	if csv_line[6].begins_with("#"):
		card_code_source.source_code += csv_line[6]
	else:
		card_code_source.source_code += "\n\nfunc run_effect():"
		for effect_line : String in csv_line[6].split("\n"):
			card_code_source.source_code += "\n\t" + effect_line
	# create resource and connect everything
	card_code_source.reload()
	card_code = card_code_source.new()
	trigger_condition = Callable(card_code, "check_condition")
	effect = Callable(card_code, "run_effect")
	
	family = CardFamilies.get(csv_line[7])

func card_to_string() -> String:
	var card_string = "card[name='"+name+"', description='"+description
	card_string += "', value="+str(value)+", rarity="+str(rarity)+", trigger_signal='"
	card_string += trigger_signal+"', trigger_condition='"+str(trigger_condition)
	card_string += "', effect="+str(effect)+"']"
	return card_string
