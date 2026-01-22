extends Node3D
class_name RouletteWheel


const ROULETTE_SPIN_TIME := 2.1
const ROULETTE_SPIN_ANGLE := 0.8

@export var number_of_marbles := 1

@onready var RouletteSpinny := $RouletteSpinny

var marbles : Array[RouletteMarble] = []
var spin_tween : Tween


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		number_of_marbles = randi_range(4, 8) + 4
		#$CanvasLayer/Label.text = "Spin roulette " + str(number_of_marbles) + " times"
		spin_roulette()

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
	for _i in range(number_of_marbles):
		var slot := randi_range(0, 36)
		launch_marble(slot)
		#$CanvasLayer/Label.text += "\n   - launch marble to " + str(slot)

func launch_marble(slot : int) -> void:
	marbles.append(RouletteMarble.launch_marble(self, slot))
