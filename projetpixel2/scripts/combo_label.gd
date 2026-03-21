extends Label
class_name ComboLabel


func _ready() -> void:
	mouse_entered.connect(_add_description)

func _add_description() -> void:
	pass
