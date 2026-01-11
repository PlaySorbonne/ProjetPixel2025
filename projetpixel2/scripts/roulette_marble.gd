extends MeshInstance3D
class_name RouletteMarble


signal marble_landed(slot : int)

const MARBLE_RES := preload("res://scenes/casino/roulette_marble.tscn")
const TOTAL_SLOTS := 37
const SLOTS := [
	0, 32, 15, 19, 4, 21, 2, 25, 17, 34, 6, 27, 13, 36, 11, 30, 8, 23, 10, 
	5, 24, 16, 33, 1, 20, 14, 31, 9, 22, 18, 29, 7, 28, 12, 35, 3, 26
]
const BALL_ROLLING_TIME := 3.75

@onready var radius := randf_range(2.2, 2.45)
@onready var angle_variation := randf_range(-0.075, 0.075)
@onready var starting_height := 0.2
@onready var height := starting_height

var angle := 0.0
var center := Vector3.ZERO
var running := false
var current_speed := 1.0
var slot := 0


static func launch_marble(roulette : RouletteWheel, slot : int) -> RouletteMarble:
	var marble := MARBLE_RES.instantiate()
	roulette.RouletteSpinny.add_child(marble)
	marble.launch_to_slot(slot)
	return marble

func launch_to_slot(slot_index: int)-> void:
	slot = slot_index
	var start_angle := randf() * TAU
	angle = start_angle
	var target_angle := SLOTS.find(slot_index) * TAU / TOTAL_SLOTS + TAU * randi_range(0, 3)
	var roll_time := randf_range(0.0, 1.5) + BALL_ROLLING_TIME
	current_speed = 1.0
	
	var t := create_tween().set_ease(Tween.EASE_OUT).set_trans(
						Tween.TRANS_CUBIC).set_parallel()
	t.tween_property(self, "angle", target_angle + angle_variation, roll_time)
	t.tween_property(self, "current_speed", 0.0, roll_time)
	t.finished.connect(stop_motion)
	
	# add marble jump animation
	var nb_jumps := randi_range(2, 5)
	var jump_tween := create_tween().set_ease(Tween.EASE_OUT)
	var jump_decay := 1.0
	for _jump : int in range(nb_jumps):
		var jump_height := (randf_range(0.0, 0.3) + 0.6) / jump_decay
		var jump_delay := randf_range(0.0, 0.3)
		var jump_half_duration := randf_range(0.25, 0.35) / jump_decay
		jump_tween.tween_property(self, "height", jump_height, 
									jump_half_duration).set_delay(jump_delay)
		jump_tween.tween_property(self, "height", starting_height, jump_half_duration)
		jump_decay += 0.15
	
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

func _process(delta : float)-> void:
	if not running:
		return
	rotation.y += delta * current_speed * 10.0
	set_position_from_angle(angle)
