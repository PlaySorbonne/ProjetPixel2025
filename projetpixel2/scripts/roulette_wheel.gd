extends Node3D
class_name RouletteWheel


const ROULETTE_SPIN_TIME := 2.1
const ROULETTE_SPIN_ANGLE := 0.8

@export var number_of_marbles := 1

@onready var RouletteSpinny := $RouletteSpinny


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		spin_roulette()

func spin_roulette() -> void:
	var final_wheel_rotation : Vector3= RouletteSpinny.rotation + Vector3(
		0.0, 
		(randf_range(0.0, 0.1) + ROULETTE_SPIN_ANGLE)* TAU, 
		0.0
	)
	var spin_time := randf_range(0.0, 0.25) + ROULETTE_SPIN_TIME
	var t := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(RouletteSpinny, "rotation", final_wheel_rotation, spin_time)
	for _i in range(number_of_marbles):
		var slot := randi_range(0, 36)
		launch_marble(slot)

func launch_marble(slot : int) -> void:
	$CanvasLayer/Label.text = "Slot = " + str(slot)
	RouletteMarble.launch_marble(self, slot)
