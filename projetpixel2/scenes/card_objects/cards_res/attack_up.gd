extends CardBase
class_name AttackUp


@export var damage_increase := 5

func check_condition():
	return true

func run_effect():
	for t : TowerBase in GV.towers:
		t.projectile_template.damage += 5
