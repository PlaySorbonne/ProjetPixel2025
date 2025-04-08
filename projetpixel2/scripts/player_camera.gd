extends Camera3D
class_name PlayerCamera


const SPEED := 50.0


func _ready() -> void:
	GV.player_camera = self

func _physics_process(delta: float) -> void:
	var direction := Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		direction += Vector3.FORWARD
	if Input.is_action_pressed("move_backward"):
		direction += Vector3.BACK
	position += direction * SPEED * delta
