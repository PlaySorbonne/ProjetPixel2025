extends Camera3D
class_name PlayerCamera


const SPEED := 8.0

var current_speed := 0.0


func _ready() -> void:
	GV.player_camera = self

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
