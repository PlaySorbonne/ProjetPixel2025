extends CasinoWindow
class_name RouletteWindow


@onready var roulette : RouletteWheel


func _on_window_opened() -> void:
	await get_tree().create_timer(0.25).timeout
	#dice_roller.roll_dice(6)
