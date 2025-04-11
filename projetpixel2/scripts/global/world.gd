extends Node3D
class_name World

func _ready() -> void:
	RunData.reset_run_data()
	GV.world = self
	
	
	Card.load_cards_data()
