extends Node

signal enemy_killed
signal experience_gained

# experience points
var experience_needed_equation : Expression = default_levelling_expression()
var current_level := 1
var level_experience_threshold : int = experience_needed_equation.execute()
var current_experience := 0:
	set(value):
		current_experience = value
		emit_signal("experience_gained")

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

func default_levelling_expression() -> Expression:
	var expr : Expression = Expression.new()
	expr.parse("next_level * 50 + pow(next_level, 2)")
	return expr

func new_kill(enemy_type : String, is_alpha : bool) -> void:
	emit_signal("enemy_killed")
	total_kills += 1
	enemy_kills[enemy_type] += 1
	if is_alpha:
		total_alpha_kills += 1
		alpha_kills[enemy_type] += 1

func reset_run_data() -> void:
	# experience
	experience_needed_equation = default_levelling_expression()
	current_level = 1
	level_experience_threshold = experience_needed_equation.execute()
	current_experience = 0
	# combo
	current_combo = 0
	max_run_combo = 0
	combo_increment = 1
	# stats
	enemy_kills.clear()
	alpha_kills.clear()
	for enemy_type : String in BaseEnemy.enemy_types:
		enemy_kills[enemy_type] = 0
		alpha_kills[enemy_type] = 0
	total_kills = 0
	total_alpha_kills = 0
