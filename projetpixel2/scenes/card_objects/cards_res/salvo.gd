extends CardBase
class_name Salvo


@export var number_of_shots = 3


func check_condition():
	return true

func run_effect():
	for _i in range(number_of_shots):
		for t : TowerBase in GV.towers:
			t.try_shoot_enemy(true)
		await GV.get_tree().create_timer(0.25).timeout
