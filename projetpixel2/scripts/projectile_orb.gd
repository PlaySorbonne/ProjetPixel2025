extends ProjectileBase
class_name ProjectileOrb


var fire_rate := 1.0:
	set(value):
		fire_rate = value
		shoot_delay = 1.0/fire_rate
var shoot_delay := 1.0:
	set(value):
		shoot_delay = value
		$TimerShoot.start(value)
var shoot_angle := Vector3.ZERO

func _on_body_entered(body: Node3D) -> void:
	return

func _on_timer_shoot_timeout() -> void:
	shoot_angle = shoot_angle.rotated(Vector3(0.0, 1.0, 0.0), 0.1)
	shoot()

func shoot() -> void:
	var projectile_obj : ProjectileBase = tower.projectile_res.instantiate()
	projectile_obj.projectile = tower.projectile_template.duplicate()
	projectile_obj.tower = tower
	GV.world.add_child(projectile_obj)
	projectile_obj.position = global_position
	projectile_obj.direction = Vector3(
		randf_range(-1.0, 1.0),
		0.0,
		randf_range(-1.0, 1.0)
	)
