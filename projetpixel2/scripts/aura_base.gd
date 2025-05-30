extends Area3D
class_name AuraBase

enum EffectApplication {onTick, onEnteredExited}

@export var tick_time := 0.25
@export var lifespan := 5.0
@export var radius := 2.5
@export var effect_application_time := EffectApplication.onTick

func _ready() -> void:
	$CollisionShape3D.shape.radius = radius
	$CSGCylinder3D.radius = radius
	$TimerTick.start(tick_time)
	$TimerLifespan.start(lifespan)

func apply_effect() -> void:
	pass

func _on_timer_tick_timeout() -> void:
	apply_effect()

func _on_timer_lifespan_timeout() -> void:
	queue_free()
