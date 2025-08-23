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
	tower.spawn_projectile(
		global_position, 
		tower.get_random_shoot_direction(), 
		true
	)
