extends MeshInstance3D
class_name RouletteMarble


signal marble_landed(slot : int)

const MARBLE_RES := preload("res://scenes/casino/roulette_marble.tscn")
const TOTAL_SLOTS := 37
const SLOTS := [
	0, 32, 15, 19, 4, 21, 2, 25, 17, 34, 6, 27, 13, 36, 11, 30, 8, 23, 10, 
	5, 24, 16, 33, 1, 20, 14, 31, 9, 22, 18, 29, 7, 28, 12, 35, 3, 26
]
const BALL_ROLLING_TIME := 4.25

@export var radius := 2.375
@export var height := 0.2

var angle := 0.0
var center := Vector3.ZERO
var running := false
var slot := 0
var previous_tween : Tween


static func launch_marble(roulette : RouletteWheel, slot : int) -> RouletteMarble:
	var marble := MARBLE_RES.instantiate()
	roulette.RouletteSpinny.add_child(marble)
	marble.launch_to_slot(slot)
	return marble

func launch_to_slot(slot_index: int)-> void:
	if is_instance_valid(previous_tween):
		previous_tween.kill()
	
	slot = slot_index
	var start_angle := randf() * TAU
	angle = start_angle
	var target_angle := SLOTS.find(slot_index) * TAU / TOTAL_SLOTS
	var roll_time := randf_range(0.0, 1.5) + BALL_ROLLING_TIME
	
	var t := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "angle", target_angle, roll_time)
	t.finished.connect(stop_motion)
	
	previous_tween= t
	running = true

func set_position_from_angle(marble_angle : float) -> void:
	marble_angle -= PI/2.0
	position = Vector3(
		center.x + cos(marble_angle) * radius, 
		center.z + height, 
		center.y + sin(marble_angle) * radius
	)

func stop_motion() -> void:
	running = false
	marble_landed.emit(slot)

func _process(_delta : float)-> void:
	if not running:
		return
	set_position_from_angle(angle)
