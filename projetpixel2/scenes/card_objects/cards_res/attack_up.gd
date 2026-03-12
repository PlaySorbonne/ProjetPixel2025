extends CardBase
class_name AttackUp


func check_condition():
	return true

func run_effect():
	tower.projectile_template.damage += 5
