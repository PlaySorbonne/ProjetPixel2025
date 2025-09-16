extends Node

signal enemy_killed
signal experience_gained
signal level_gained

# probability
var probability_multiplier := 1.0
var better_luck := false
func roll_probability(base_probability : float) -> bool:
	if better_luck:
		return true
	var final_probability = clamp(base_probability * probability_multiplier, 0.0, 1.0)
	var rd : float = randf() 
	return rd < final_probability

# experience points
var experience_needed_equation : Expression = default_levelling_expression()
var current_level := 1:
	set(value):
		current_level = value
		level_experience_threshold = get_level_experience_threshold()
		level_gained.emit()
var level_experience_threshold : int = get_level_experience_threshold()
var experience_multiplier := 3.0
var current_experience := 0:
	set(value):
		if value >= level_experience_threshold:
			current_experience = value - level_experience_threshold
			current_level += 1
		else:
			current_experience = value
		experience_gained.emit()

func gain_experience(amount : int) -> void:
	#print("GAIN " + str(amount) + " * " + str(experience_multiplier))
	current_experience += int(amount * experience_multiplier) 

func get_level_experience_threshold() -> int:
	return experience_needed_equation.execute([], self)

func get_experience_percentage() -> float:
	return float(current_experience) / float(level_experience_threshold)

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
	var expr_str := "(current_level+1) * 50 + pow((current_level+1), 3.0)"
	var err = expr.parse(expr_str)
	return expr

func new_kill(enemy_type : String, is_alpha : bool) -> void:
	emit_signal("enemy_killed")
	total_kills += 1
	if enemy_kills.has(enemy_type):
		enemy_kills[enemy_type] += 1
	else:
		enemy_kills[enemy_type] = 1
	if is_alpha:
		total_alpha_kills += 1
		if alpha_kills.has(enemy_type):
			alpha_kills[enemy_type] += 1
		else:
			alpha_kills[enemy_type] = 1

func reset_run_data() -> void:
	Engine.time_scale = 1.0
	# experience
	experience_needed_equation = default_levelling_expression()
	current_level = 1
	level_experience_threshold = experience_needed_equation.execute([], self)
	current_experience = 0
	experience_multiplier = 1.0
	# combo
	current_combo = 0
	max_run_combo = 0
	combo_increment = 1
	# stats
	enemy_kills.clear()
	alpha_kills.clear()
	total_kills = 0
	total_alpha_kills = 0
