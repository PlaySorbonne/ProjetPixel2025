extends SubViewportContainer
class_name ChipsViewportContainer


func _ready() -> void:
	mouse_entered.connect(_add_description)

func _add_description() -> void:
	ChipsDescription.add_minigame_description(self)
