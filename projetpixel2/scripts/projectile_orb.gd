extends ProjectileBase
class_name ProjectileOrb


var fire_rate := 1.0:
	set(value):
		fire_rate = value
		shoot_delay = 1.0/fire_rate
var shoot_delay := 1.0
#var shoot_angle := Vector3(1.0, 0.0, 0.0)


func _ready() -> void:
	base_speed = 10.0
	$TimerShoot.start(shoot_delay)

func _on_body_entered(body: Node3D) -> void:
	return

func _on_timer_shoot_timeout() -> void:
	#shoot_angle = shoot_angle.rotated(Vector3(0.0, 1.0, 0.0), 0.4)
	shoot()

func shoot() -> void:
	#var enemy : Node3D = tower.enemy_choice.call()
	var enemy : Node3D = BaseEnemy.living_enemies.pick_random()
	var projectile_dir : Vector3
	if enemy == null:
		projectile_dir = Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0))
	else:
		projectile_dir = position.direction_to(enemy.position)
	tower.spawn_projectile(
		global_position, 
		projectile_dir, 
		true
	)
