extends CardBase
class_name Salvo


func check_condition():
	return true

func run_effect():
	tower.try_shoot_enemy(true)
	tower.try_shoot_enemy(true)
	tower.try_shoot_enemy(true)
