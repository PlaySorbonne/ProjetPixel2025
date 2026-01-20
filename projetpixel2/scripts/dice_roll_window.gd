extends CasinoWindow
class_name DiceRollWindow


@onready var dice_roller : DiceRoller = $Contents/SubViewportContainer/SubViewport/DiceRoller


func _on_window_opened() -> void:
	await get_tree().create_timer(0.25).timeout
	dice_roller.roll_dice(6)

func _on_dice_roller_die_rolled(result: int) -> void:
	$Contents/Label.text += "\n    " + str(result)

func _on_dice_roller_all_dice_rolled(result: int) -> void:
	$Contents/Label.text += "\n  TOTAL = " + str(result)
	MessagePopupWindow.spawn_message_popup("Dice rolled - results: " + str(result) + "!")
	await get_tree().create_timer(1.5).timeout
	close_window()
