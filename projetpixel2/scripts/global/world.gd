extends Node3D
class_name World

func _ready() -> void:
	InfoPopup.reset_popups()
	RunData.reset_run_data()
	GV.world = self
	
	
	Card.load_cards_data()
	while true:
		var rend := 0.0
		for i in range(1000):
			rend += RunData.random_float(0.0, 1.0)
		rend /= 1000.0
		print("random average = " + str(rend))
		await get_tree().create_timer(1.0).timeout
