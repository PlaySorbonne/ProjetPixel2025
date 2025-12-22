extends Node3D
class_name DiceRoller


var total_dice_result : int


func _input(event):
	if event.is_action_pressed("ui_accept"):
		var dice := Dice.roll_dice(self, $Marker3D.position)
		connect_dice(dice)

func connect_dice(dice : Dice) -> void:
	dice.dice_result.connect(_on_dice_rolled)
	dice.dice_cocked.connect(_on_dice_cocked)

func _on_dice_cocked(new_dice : Dice) -> void:
	$CanvasLayer/Label.text += "\ncocked -> spawn new dice"
	connect_dice(new_dice)

func _on_dice_rolled(result : int) -> void:
	total_dice_result += result
	$CanvasLayer/Label2.text = str(total_dice_result)
	$CanvasLayer/Label.text += "\n" + str(result)
