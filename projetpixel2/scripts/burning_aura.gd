extends AuraBase
class_name BurningAura


func apply_effect() -> void:
	for enemy : BaseEnemy in get_overlapping_bodies():
		var burning : StatusBurning = StatusBurning.new()
		burning.inflict_status(enemy)
