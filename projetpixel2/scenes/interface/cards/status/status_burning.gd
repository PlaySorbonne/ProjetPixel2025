extends StatusBase
class_name StatusBurning


func get_status_object_ref() -> PackedScene:
	return preload("res://scenes/interface/cards/status/status_burning_object.tscn")
