extends StatusBase
class_name StatusRooted


var total_time : float = 3.0


func get_status_object_ref() -> PackedScene:
	return preload("res://scenes/interface/cards/status/status_rooted_object.tscn")

func stack_status_effect(effect_object : StatusObjectBase) -> void:
	var status_rooted : StatusRooted = effect_object.status
	status_rooted.total_time = max(status_rooted.total_time, total_time)
	effect_object.reset_timer(status_rooted.total_time)

func apply_effect(enemy : BaseEnemy) -> void:
	enemy.can_move = false
