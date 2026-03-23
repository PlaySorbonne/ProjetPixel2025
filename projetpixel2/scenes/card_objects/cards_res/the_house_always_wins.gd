extends CardBase
class_name TheHouseAlwaysWins


@export var better_luck_duration := 5.0

func check_condition():
	return true

func run_effect():
	RunData.add_better_luck(better_luck_duration)
