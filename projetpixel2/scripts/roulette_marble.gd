extends MeshInstance3D
class_name RouletteMarble


const TOTAL_SLOTS := 37
const SLOTS := [
	0, 32, 15, 19, 4, 21, 2, 25, 17, 34, 6, 27, 13, 36, 11, 30, 8, 23, 10, 
	5, 24, 16, 33, 1, 20, 14, 31, 9, 22, 18, 29, 7, 28, 12, 35, 3, 26
]

@export var radius := 2.375
@export var angular_speed := 4.0   # radians/sec
@export var height := 0.2

var angle := 0.0
var center := Vector3.ZERO
var running := false


func launch_to_slot(slot_index: int)-> void:
	var target_angle := SLOTS.find(slot_index) * TAU / TOTAL_SLOTS
	set_position_from_angle(target_angle)
	
	return
	var extra_turns = randi_range(3, 6)
	var spiral_time := randf_range(3.5, 4.5)
	
	running = true
	
	var start_angle := randf() * TAU
	set_position_from_angle(start_angle)
	
	var total_rotation = (target_angle - start_angle) + TAU * extra_turns
	var speed : float = total_rotation / spiral_time
	start_motion(start_angle, speed)

func set_position_from_angle(angle : float) -> void:
	angle -= PI/2.0
	position = Vector3(
		center.x + cos(angle) * radius, 
		center.z + height, 
		center.y + sin(angle) * radius
	)

func start_motion(start_angle := 0.0, speed := 1.0):
	angular_speed = speed
	angle = start_angle
	running = true

func stop_motion() -> void:
	running = false

func _process(delta : float)-> void:
	if not running:
		return
	
	angle += angular_speed * delta
	set_position_from_angle(angle)
