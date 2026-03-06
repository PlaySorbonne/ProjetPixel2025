extends CasinoWindow
class_name RouletteWindow


@onready var roulette : RouletteWheel = $Contents/SubViewportContainer/SubViewport/RouletteWheel


static func roulette_slot_to_color(slot_nb : int) -> String:
	if slot_nb == 0:
		return "Green"
	elif slot_nb in [32, 19, 21, 25, 34, 27, 36, 30, 23, 5, 16, 1, 14, 9, 18, 7, 12, 3]:
		return "Red"
	else:
		return "Black"

func _on_window_opened() -> void:
	await get_tree().create_timer(0.55).timeout
	roulette.number_of_marbles = randi_range(1, 6)
	roulette.spin_roulette()

func _on_roulette_wheel_marble_landed(on_slot: int) -> void:
	var marble_color := roulette_slot_to_color(on_slot)
	$Contents/Label.text += "\n" + marble_color
	MessagePopupWindow.spawn_message_popup("/ROULETTE WHEEL/\nMarble on %s!" % marble_color)

func _on_roulette_wheel_wheel_result(_result: int) -> void:
	get_tree().create_timer(3.0).timeout.connect(close_window.bind(true))
