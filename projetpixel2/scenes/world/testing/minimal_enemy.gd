extends Node3D
class_name MinimalEnemy

const SPEED := 25.0

var velocity : Vector3
var is_moving := false
var recompute_dir_in_process := true

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	is_moving = true
	compute_velocity()
	if not recompute_dir_in_process:
		$Timer.start()

func _process(delta: float) -> void:
	if is_moving:
		position += velocity * delta
		if recompute_dir_in_process:
			compute_velocity()

func _on_timer_timeout() -> void:
	compute_velocity()

func compute_velocity() -> void:
	velocity = SPEED * position.direction_to(GV.space_ship.position)
	look_at(GV.space_ship.position)
