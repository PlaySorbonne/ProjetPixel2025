extends Button
class_name CardObject

enum CardTargets {Tower, Enemy, Bullet}

var card_target := CardTargets.Tower     # the target of the effect
var card_signal : String = "tower_fired" # the target's signal that triggers the effect
var card_trigger_condition : Callable    # a boolean function to make sure the effect triggers
var card_effect_code : Callable          # the method to call when the effect triggers
