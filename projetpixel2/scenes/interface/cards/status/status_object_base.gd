extends Node3D
class_name StatusObjectBase


@export var status_type : StatusBase.StatusEffects = StatusBase.StatusEffects.Burning

var status : StatusBase
@onready var enemy : BaseEnemy = get_parent()

func reset_timer(new_time : float) -> void:
	$TimerLifespan.start(new_time)

func _on_timer_lifespan_timeout() -> void:
	enemy.status_effects.erase(self)
	queue_free()
