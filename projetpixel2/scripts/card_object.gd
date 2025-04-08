extends Button
class_name CardObject

enum CardRarities {Common, Uncommon, Rare, Legendary, Secret}

var card_name := ""
var card_description := ""
var card_value := 1
var card_rarity : CardRarities = CardRarities.Common
var card_resource : PackedScene
var card_signal : String = "tower_fired" # the target's signal that triggers the effect
var card_trigger_condition : Expression  # a boolean function to make sure the effect triggers
var card_effect_code : Array[Expression] # the method to call when the effect triggers
var tower : TowerBase

func execute_card() -> bool:
	# if trigger condition ok, execute effect
	if card_trigger_condition.execute([], tower):
		for effect : Expression in card_effect_code:
			effect.execute([], tower)
		return true
	else:
		return false
