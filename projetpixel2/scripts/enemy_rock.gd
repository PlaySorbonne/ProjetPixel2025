extends BaseEnemy
class_name EnemyRock


const RUNNER_RES := preload("res://scenes/world/enemies/mobs/runner.tscn")


func spawn_runner() -> void:
	var new_runner := RUNNER_RES.instantiate()
	GV.world.add_child(new_runner)
	new_runner.global_position = global_position

func _on_status_inflicted(status_type: StatusBase.StatusEffects) -> void:
	if status_type == StatusBase.StatusEffects.Burning:
		spawn_runner()
