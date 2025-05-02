extends StatusObjectBase
class_name StatusBurningObject


func _ready() -> void:
	var status_burning : StatusBurning = status
	$TimerLifespan.start(status_burning.total_time)
	$TimerTick.start(status_burning.tick_time)

func _on_timer_tick_timeout() -> void:
	status.apply_effect(enemy)
