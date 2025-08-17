extends Area3D
class_name ExplosionBase


@export var duration := 1.0:
	set(value):
		duration = value
		$TimerLifetime.start(duration)
@export var radius := 2.5


func apply_effect(enemy : BaseEnemy) -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body is BaseEnemy:
		apply_effect(body)

func _on_timer_lifetime_timeout() -> void:
	queue_free()
