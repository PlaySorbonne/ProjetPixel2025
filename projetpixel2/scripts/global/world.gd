extends Node3D
class_name World

func _ready() -> void:
	InfoPopup.reset_popups()
	RunData.reset_run_data()
	GV.world = self
	
	Card.load_cards_data()


func _process(delta: float) -> void:
	pass
