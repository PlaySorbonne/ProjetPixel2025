extends ProjectileBase
class_name ProjectileOrb


var shoot_delay := 1.0:
	set(value):
		shoot_delay = value
		$TimerShoot.start(value)
var shoot_angle := Vector3.ZERO

func _on_body_entered(body: Node3D) -> void:
	return

func _on_timer_shoot_timeout() -> void:
	
	shoot()

func increase_shoot_angle() -> void:
	shoot_angle = shoot_angle.rotated(Vector3(0.0, 1.0, 0.0), 0.1)

func shoot() -> void:
	var projectile_obj : ProjectileBase = projectile_res.instantiate()
	projectile_obj.projectile = tower.projectile_template.duplicate()
	projectile_obj.tower = tower
	GV.world.add_child(projectile_obj)
	projectile_obj.position = global_position
	projectile_obj.direction = Vector3(
		randf_range(-1.0, 1.0),
		0.0,
		randf_range(-1.0, 1.0)
	)
