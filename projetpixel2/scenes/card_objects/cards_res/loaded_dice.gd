extends CardBase
class_name LoadedDice


func check_condition():
	return true

func run_effect():
	var dice_btn := GV.minigame_buttons[CasinoMinigameButton.Minigames.Dice]
	dice_btn.min_reset_level
