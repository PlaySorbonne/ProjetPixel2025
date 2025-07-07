extends Node3D
class_name MinimalEnemy

const SPEED := 25.0

var velocity : Vector3
var is_moving := false

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	is_moving = true
	velocity = SPEED * position.direction_to(GV.space_ship.position)
	$Timer.start()

func _process(delta: float) -> void:
	if is_moving:
		position += velocity * delta

func _on_timer_timeout() -> void:
	velocity = SPEED * position.direction_to(GV.space_ship.position)
