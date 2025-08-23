extends ExplosionBase
class_name ExplosionRoot


@export var root_time := 1.0


func apply_effect(enemy : BaseEnemy) -> void:
	var root_status := StatusRooted.new()
	root_status.total_time = root_time
	root_status.inflict_status(enemy)
