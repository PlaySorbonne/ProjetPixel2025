extends Node3D
class_name RouletteWheel

signal marble_landed(on_slot : int)
signal wheel_result(result : int)

const ROULETTE_SPIN_TIME := 2.1
const ROULETTE_SPIN_ANGLE := 0.8

@export var number_of_marbles := 1

@onready var RouletteSpinny := $RouletteSpinny

var marbles : Array[RouletteMarble] = []
var spin_tween : Tween
var landed_marbles := 0


func spin_roulette() -> void:
	if is_instance_valid(spin_tween):
		spin_tween.kill()
	for marble : RouletteMarble in marbles:
		if is_instance_valid(marble):
			marble.queue_free()
	var final_wheel_rotation : Vector3= RouletteSpinny.rotation + Vector3(
		0.0, 
		(randf_range(0.0, 0.1) + ROULETTE_SPIN_ANGLE)* TAU, 
		0.0
	)
	var spin_time := randf_range(0.0, 0.25) + ROULETTE_SPIN_TIME
	spin_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	spin_tween.tween_property(RouletteSpinny, "rotation", final_wheel_rotation, spin_time)
	landed_marbles = 0
	for _i in range(number_of_marbles):
		var slot := randi_range(0, 36)
		launch_marble(slot)

func launch_marble(slot : int) -> void:
	var new_marble := RouletteMarble.launch_marble(self, slot)
	marbles.append(new_marble)
	new_marble.marble_landed.connect(_on_marble_landed)

func _on_marble_landed(land_slot : int) -> void:
	landed_marbles += 1
	marble_landed.emit(land_slot)
	if landed_marbles == number_of_marbles:
		wheel_result.emit(0)
