extends Node3D
class_name DiceRoller


var total_dice_result : int


func _input(event):
	if event.is_action_pressed("ui_accept"):
		var dice := Dice.roll_dice(self, $Marker3D.position)
		connect_dice(dice)
		if randi()%4 == 0:
			dice.force_dice_value(6)
			print("force fice vfixc vfd")
		else:
			print("dont touch dice probabilities")

func connect_dice(dice : Dice) -> void:
	dice.dice_result.connect(_on_dice_rolled.bind(dice))
	dice.dice_cocked.connect(_on_dice_cocked)

func add_debug_line(new_line : String) -> void:
	$CanvasLayer/Label.text += new_line + "\n"

func _on_dice_cocked(new_dice : Dice) -> void:
	add_debug_line("cocked -> spawn new dice")
	connect_dice(new_dice)

func _on_dice_rolled(result : int, dice : Dice) -> void:
	if dice.forced_face == -1:
		add_debug_line("dice roll = " + str(result))
	else:
		add_debug_line("forced dice result = " + str(result))
	total_dice_result += result
	$CanvasLayer/Label2.text = str(total_dice_result)
