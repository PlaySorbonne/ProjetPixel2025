extends TextureRect
class_name ShipHealthControl


func _ready() -> void:
	mouse_entered.connect(_add_description)

func _add_description() -> void:
	pass
