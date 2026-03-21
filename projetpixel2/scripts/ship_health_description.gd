extends ObjectDescription
class_name ShipHealthDescription


const SHIP_HEALTH_DESCRIPTION_RES := preload("res://scenes/interface/descriptions/ship_health_description.tscn")

static func add_ship_health_description(ship_health : ShipHealthControl) -> ShipHealthDescription:
	var ship_descr : ShipHealthDescription = SHIP_HEALTH_DESCRIPTION_RES.instantiate()
	ship_descr._init_description_popup(ship_health)
	return ship_descr


func _ready() -> void:
	super._ready()
	GV.space_ship.hit.connect(_update_text)
	GV.space_ship.shield_regeneration.connect(_update_text)
	_update_text()

func _update_text() -> void:
	$LabelDescription.text = "Current Health: " + \
	str(GV.space_ship.get_health()) + "/" + \
	str(GV.space_ship.get_max_health()) + \
	"\nCurrent Shields: " + \
	str(GV.space_ship.get_shields()) + "/" + \
	str(GV.space_ship.get_max_shields())
