extends Node3D
class_name ProjectileBase


static var critical_hits_number := 0
static var hits_number := 0

var projectile_res := load("res://scenes/spaceship/towers/projectiles/projectile_base.tscn")
var tower : Node
var projectile : Projectile
var size := 1.0:
	set(value):
		size = value
		scale = Vector3.ONE * size
var direction : Vector3
var base_speed := 20.0

func _ready() -> void:
	await get_tree().create_timer(4.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * base_speed * projectile.speed * delta

func damage_body(body : BaseEnemy) -> void:
	var is_crit : bool
	is_crit = RunData.roll_probability(projectile.critical_hit_chance)
	hits_number += 1
	tower.enemy_hit.emit(self, body)
	var killed : bool
	if is_crit:
		tower.projectile_critical_hit.emit(self, body)
		critical_hits_number += 1
		killed = body.damageable.damage_critical(
			projectile.get_damage(), 
			projectile.damage_type, 
			projectile.critical_hit_intensity)
	else:
		killed = body.damageable.damage(
			projectile.get_damage(), 
			projectile.damage_type)
	if killed:
		tower.enemy_killed.emit(self, body)

func split(total_angle : float, number_of_children := 3, children_multiplier := 0.9) -> void:
	var angle_increment := total_angle / float(number_of_children)
	var rot := Basis(Vector3.UP, -(total_angle / 2))
	var initial_direction = rot * direction
	self.direction = initial_direction
	rot = Basis(Vector3.UP, angle_increment)
	for i : int in range(number_of_children - 1):
		var new_projectile : ProjectileBase = projectile_res.instantiate()
		new_projectile.projectile = projectile.split_projectile(children_multiplier)
		new_projectile.tower = self.tower
		GV.world.add_child(new_projectile)
		new_projectile.global_position = global_position
		initial_direction = rot * initial_direction
		new_projectile.direction = initial_direction

func bounce() -> void:
	direction = Vector3(
		randf_range(-1.0, 1.0),
		0.0,
		randf_range(-1.0, 1.0)
	)

func _on_body_entered(body: Node3D) -> void:
	if body is BaseEnemy:
		damage_body(body)
		# pierce + bounce: split
		if projectile.pierce > 0 and projectile.bounce > 0:
			projectile.pierce -= 1
			projectile.bounce -= 1
			split(2, 45.0, 0.9)
		# pierce
		elif projectile.pierce > 0:
			projectile.pierce -= 1
		# bounce
		elif projectile.bounce > 0:
			projectile.bounce -= 1
			bounce()
		# destroy projectile
		else:
			await get_tree().process_frame
			queue_free()
