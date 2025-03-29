extends Node

signal enemy_killed

# combo
var current_combo := 0:
	set(value):
		current_combo = value
		if current_combo > max_run_combo:
			max_run_combo = current_combo
var combo_increment := 1
var combo_max_time := 2.0
var max_run_combo := 0

# stats
var enemy_kills : Dictionary[String, int] = {}
var alpha_kills : Dictionary[String, int] = {}
var total_kills := 0
var total_alpha_kills := 0


func new_kill(enemy_type : String, is_alpha : bool) -> void:
	emit_signal("enemy_killed")
	total_kills += 1
	enemy_kills[enemy_type] += 1
	if is_alpha:
		total_alpha_kills += 1
		alpha_kills[enemy_type] += 1

func reset_run_data() -> void:
	current_combo = 0
	max_run_combo = 0
	combo_increment = 1
	enemy_kills.clear()
	alpha_kills.clear()
	for enemy_type : String in BaseEnemy.enemy_types:
		enemy_kills[enemy_type] = 0
		alpha_kills[enemy_type] = 0
	total_kills = 0
	total_alpha_kills = 0
