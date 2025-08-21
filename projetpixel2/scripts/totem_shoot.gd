extends TotemBase
class_name TotemShoot


var number_of_projectiles := 1
var current_projectile := 0
var is_instant := false


func trigger_effect() -> void:
	if is_instant:
		for _i : int in range(number_of_projectiles):
			shoot()
		super.trigger_effect()
	else:
		if current_projectile < number_of_projectiles:
			current_projectile += 1
			shoot()
			$TimerShoot.start()
		else:
			super.trigger_effect()

func _on_timer_shoot_timeout() -> void:
	trigger_effect()

func stack_totem() -> void:
	number_of_projectiles += 1

func shoot() -> void:
	tower.spawn_projectile(
		global_position,
		tower.get_random_shoot_direction()
	)
