extends Node3D
class_name RouletteWheel


@export var number_of_marbles := 1


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		spin_roulette()


func spin_roulette() -> void:
	
	for _i in range(number_of_marbles):
		var slot := randi_range(0, 36)
		launch_marble(slot)

func launch_marble(slot : int) -> void:
	$CanvasLayer/Label.text = "Slot = " + str(slot)
	$RouletteSpinny/RouletteMarble.launch_to_slot(slot)
