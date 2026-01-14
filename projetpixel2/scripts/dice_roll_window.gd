extends CasinoWindow
class_name DiceRollWindow


@onready var dice_roller : DiceRoller = $Contents/SubViewportContainer/SubViewport/DiceRoller


func _on_window_opened() -> void:
	dice_roller.roll_dice(6)

func _on_dice_roller_die_rolled(result: int) -> void:
	$Contents/Label.text += "\n    " + str(result)

func _on_dice_roller_all_dice_rolled(result: int) -> void:
	$Contents/Label.text += "\n  TOTAL = " + str(result)
	await get_tree().create_timer(1.5).timeout
	close_window()
