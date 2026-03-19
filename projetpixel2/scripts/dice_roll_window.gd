extends CasinoMinigameWindow
class_name DiceRollWindow


@onready var dice_roller : DiceRoller = $Contents/SubViewportContainer/SubViewport/DiceRoller


func _on_window_opened() -> void:
	await get_tree().create_timer(0.25).timeout
	dice_roller.roll_dice(minigame_level)

func _on_dice_roller_die_rolled(result: int) -> void:
	MessagePopupWindow.spawn_message_popup("/DICE/\nLanded on %s!" % result)

func _on_dice_roller_all_dice_rolled(result: int, nb_sixes : int) -> void:
	$Contents/Label.text += "\n  TOTAL = " + str(result)
	MessagePopupWindow.spawn_message_popup("/DICE ROLL/\nRolled %s sixes!" % str(nb_sixes))
	RunData.current_chips += 50 * nb_sixes
	await get_tree().create_timer(1.5).timeout
	close_window(true)
