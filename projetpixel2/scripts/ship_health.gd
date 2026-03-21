extends TextureRect
class_name ShipHealthControl


func _ready() -> void:
	mouse_entered.connect(_add_description)

func _add_description() -> void:
	ShipHealthDescription.add_ship_health_description(self)
