extends Camera3D
class_name PlayerCamera


const SPEED := 8.0

var current_speed := 0.0
@export var offset : Vector2:
	set(value):
		offset = value
		h_offset = value.x
		v_offset = value.y


func _ready() -> void:
	GV.player_camera = self

func shake(duration_n := 0.2, frequency_n := 15, amplitude_n := 30) -> void:
	$XYZShaker.shake(duration_n, frequency_n, amplitude_n)

func _physics_process(delta: float) -> void:
	var direction := Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		direction += Vector3.FORWARD
	if Input.is_action_pressed("move_backward"):
		direction += Vector3.BACK
	if Input.is_action_pressed("move_left"):
		direction += Vector3.LEFT
	if Input.is_action_pressed("move_right"):
		direction += Vector3.RIGHT
	if direction != Vector3.ZERO:
		current_speed = lerp(current_speed, SPEED, 0.00001 * delta)
		position += (direction.normalized() * SPEED * delta)
	else:
		current_speed = 0.0
