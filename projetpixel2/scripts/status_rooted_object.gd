extends StatusObjectBase
class_name StatusRootedObject


func _ready() -> void:
	var status_rooted : StatusRooted = status
	$TimerLifespan.start(status_rooted.total_time)
	status_rooted.apply_effect(enemy)

func remove_effect() -> void:
	enemy.can_move = true
	super.remove_effect()
