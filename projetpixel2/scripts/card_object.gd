extends Button
class_name CardObject

enum CardRarities {Common, Uncommon, Rare, Legendary, Secret}

const SIGNAL_TO_TARGET : Dictionary[String, String] = {
	"tower_fired" : "tower_effects",
	
}

var card_name := ""
var card_description := ""
var card_value := 1
var card_rarity : CardRarities = CardRarities.Common
var card_resource : PackedScene
var card_signal : String = "tower_fired" # the target's signal that triggers the effect
var card_trigger_condition : Expression  # a boolean function to make sure the effect triggers
var card_effect_code : Array[Expression] # the method to call when the effect triggers

func add_to_tower(tower : TowerBase) -> void:
	match card_signal:
		"tower_fired", "tower_switched_mode":
			tower.cards_tower.append(self)
		"enemy_died":
			tower.cards_enemy.append(self)
		"projectile_critical_hit", "projectile_hit_enemy":
			tower.cards_projectile.append(self)
		"added_to_tower":
			pass
		_:
			print_debug("card_object: incorrect card_signal detected")
