extends Node3D
class_name World

func _ready() -> void:
	InfoPopup.reset_popups()
	RunData.reset_run_data()
	GV.world = self
	# parse cards data from game design csv file
	CardData.load_cards_data()
	#TODO: do the same with enemy data csv
