extends Area3D
class_name AuraBase


var tick_time := 0.5
var lifespan := 5.0
var radius := 1.0


func _ready() -> void:
	$CollisionShape3D.shape.radius = radius
	$TimerTick.start(tick_time)
	$TimerLifespan.start(lifespan)

func apply_effect() -> void:
	pass

func _on_timer_tick_timeout() -> void:
	apply_effect()

func _on_timer_lifespan_timeout() -> void:
	queue_free()
