extends Node

signal enemy_killed
signal experience_gained
signal level_gained

# probability
var probability_multiplier := 1.0
var better_luck := false
func random_float(min_number : float, max_number : float, max_better := true) -> float:
	if better_luck:
		# best possible case scenario
		if max_better:
			return max_number
		else:
			return min_number
	else:
		# weighted probabilities (good and bad)
		var rand : float = randf_range(min_number, max_number) * probability_multiplier
		return clamp(rand, min_number, max_number)

# experience points
var experience_needed_equation : Expression = default_levelling_expression()
var current_level := 1:
	set(value):
		current_level = value
		emit_signal("level_gained")
var level_experience_threshold : int =  get_level_experience_threshold()
var current_experience := 0:
	set(value):
		if value >= level_experience_threshold:
			current_experience = value - level_experience_threshold
			current_level += 1
		else:
			current_experience = value
		emit_signal("experience_gained")

func get_level_experience_threshold() -> int:
	return experience_needed_equation.execute([], self)

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
	var expr_str := "(current_level+1) * 50 + pow((current_level+1), 2)"
	var err = expr.parse(expr_str)
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
	level_experience_threshold = experience_needed_equation.execute([], self)
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
