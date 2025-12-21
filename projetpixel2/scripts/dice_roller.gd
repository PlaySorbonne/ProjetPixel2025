extends Node3D
class_name DiceRoller


func _input(event):
	if event.is_action_pressed("ui_accept"):
		for _i : int in range(5):
			Dice.roll_dice(self, $Marker3D.position)
