extends CasinoMinigameWindow
class_name DiceRollWindow


const REWARD_PER_SIX := 50
@onready var dice_roller : DiceRoller = $Contents/SubViewportContainer/SubViewport/DiceRoller


func _on_window_opened() -> void:
	await get_tree().create_timer(0.25).timeout
	dice_roller.roll_dice(minigame_level)

func _on_dice_roller_die_rolled(_result: int) -> void:
	#MessagePopupWindow.spawn_message_popup("/DICE/\nLanded on %s!" % result)
	pass

func _on_dice_roller_all_dice_rolled(result: int, nb_sixes : int) -> void:
	$Contents/Label.text += "\n  TOTAL = " + str(result)
	var total_reward : int = nb_sixes * REWARD_PER_SIX
	MessagePopupWindow.spawn_message_popup("/DICE ROLL/\nTotal chips: " + str(total_reward))
	RunData.current_chips += total_reward
	await get_tree().create_timer(1.5).timeout
	close_window(true)
