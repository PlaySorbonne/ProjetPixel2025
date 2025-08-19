extends TotemBase
class_name TotemShoot

var number_of_projectiles := 1
var projectile_template : Projectile


func trigger_effect() -> void:
	for _i : int in range(number_of_projectiles):
		shoot()
	destroy_totem()

func stack_totem() -> void:
	number_of_projectiles += 1

func shoot() -> void:
	tower.spawn_projectile(
		global_position,
		Vector3(
			randf_range(-1.0, 1.0),
			0.0,
			randf_range(-1.0, 1.0)
		)
	)
