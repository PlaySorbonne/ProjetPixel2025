extends Timer
class_name BoostAutoSwitchMode


static func add_boost_auto_switch(tower: TowerBase, switch_time := 20.0) -> BoostAutoSwitchMode:
	if tower.is_in_group("auto_switch_mode"):
		for boost : Node in tower.get_children():
			if boost is BoostAutoSwitchMode:
				boost.auto_switch_duration = switch_time
				return boost
		print_debug("ERROR: tower should have a BoostAutoSwitchMode component")
	const BOOST_RES := preload("res://scenes/spaceship/towers/components/boost_auto_switch_mode.tscn")
	tower.add_to_group("auto_switch_mode")
	var boost := BOOST_RES.instantiate()
	tower.add_child(boost)
	boost.auto_switch_duration = switch_time
	boost.connect_to_tower(tower)
	return boost


@export var auto_switch_duration := 20.0
@export var auto_switch_from_mining := true
@export var auto_switch_from_firing := true
var boost_tower : TowerBase 
#@export var nova_type : Res

func connect_to_tower(tower : TowerBase) -> void:
	boost_tower = tower
	tower.tower_can_switch_mode.connect(aut_switch_mode)

func aut_switch_mode() -> void:
	if boost_tower.current_mode == TowerBase.Modes.Mining and auto_switch_from_mining:
		boost_tower.switch_to_firing()
	elif boost_tower.current_mode == TowerBase.Modes.Firing and auto_switch_from_firing:
		boost_tower.switch_to_mining()
