extends BaseEnemy
class_name EnemyRock


const RUNNER_RES := preload("res://scenes/world/enemies/mobs/fireproof_runner.tscn")
const MINION_OFFSETS := [
	Vector3(0, 0, -1),
	Vector3(0, 0, 1),
	Vector3(-1, 0, -1),
	Vector3(-1, 0, 0),
	Vector3(-1, 0, 1),
	Vector3(1, 0, -1),
	Vector3(1, 0, 0),
	Vector3(1, 0, 1),
]

var minions_count := 0

@export var max_minions := 15

func spawn_runner() -> void:
	if minions_count > max_minions:
		return
	minions_count += 1
	var new_runner := RUNNER_RES.instantiate()
	GV.world.add_child(new_runner)
	new_runner.global_position = global_position + MINION_OFFSETS.pick_random()

func _on_status_inflicted(status_type: StatusBase.StatusEffects) -> void:
	if status_type == StatusBase.StatusEffects.Burning:
		for _i in range(3):
			spawn_runner()
