extends Resource
class_name EffectTriggerBase

signal trigger_effect

var signal_to_connect : String

func trigger() -> void:
	pass

# EXAMPLE :
# trigger the effect every 10 times a tower shoots:
#
# var signal_to_connect : String = "tower_shoot"
# var shots := 0
#
# func trigger() -> void:
#   	shots += 1
#   	if shots >= 10:
#   		shots = 0
#   		emit_signal("trigger_effect")
#
