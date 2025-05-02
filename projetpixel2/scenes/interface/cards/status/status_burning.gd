extends StatusBase
class_name StatusBurning


var tick_damage : int = 5
var tick_time : float = 0.25
var total_time : float = 3.0


func get_status_object_ref() -> PackedScene:
	return preload("res://scenes/interface/cards/status/status_burning_object.tscn")

func stack_status_effect(effect_object : StatusObjectBase) -> void:
	var status_burning : StatusBurning = effect_object.status
	status_burning.tick_damage = max(status_burning.tick_damage, tick_damage)
	status_burning.tick_time = min(status_burning.tick_time, tick_time)
	status_burning.total_time = max(status_burning.total_time, total_time)
	effect_object.reset_timer(status_burning.total_time)

func apply_effect(enemy : BaseEnemy) -> void:
	enemy.damageable.damage(
		tick_damage, 
		DamageableObject.DamagingTypes.Fire, 
		RunData.roll_probability(0.0)
	)
