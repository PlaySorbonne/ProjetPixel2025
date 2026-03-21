extends ObjectDescription
class_name ShipHealthDescription


const SHIP_HEALTH_DESCRIPTION_RES := preload("res://scenes/interface/descriptions/ship_health_description.tscn")

static func add_ship_health_description(ship_health : ShipHealthControl) -> ShipHealthDescription:
	var ship_descr : ShipHealthDescription = SHIP_HEALTH_DESCRIPTION_RES.instantiate()
	ship_descr._init_description_popup(ship_health)
	return ship_descr


func _ready() -> void:
	super._ready()
