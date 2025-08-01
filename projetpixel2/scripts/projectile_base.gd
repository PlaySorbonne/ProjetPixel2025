extends Node3D
class_name ProjectileBase

const PROJECTILE_RES := preload("res://scenes/spaceship/towers/projectiles/projectile_base.tscn")

static var critical_hits_number := 0
static var hits_number := 0

var tower : TowerBase
var projectile : Projectile
var size := 1.0:
	set(value):
		size = value
		scale = Vector3.ONE * size

var direction : Vector3 
var base_speed := 20.0

func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
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

func split(number_of_children : int, total_angle : float, children_multiplier := 0.9) -> void:
	var angle_increment := total_angle / float(number_of_children)
	var rotation = Basis(Vector3.UP, -(total_angle / 2))
	var initial_direction = rotation.xform(direction)
	rotation = Basis(Vector3.UP, angle_increment)
	for i : int in range(number_of_children):
		var new_projectile : ProjectileBase = PROJECTILE_RES.instantiate()
		new_projectile.projectile = projectile.split_projectile(children_multiplier)
		GV.world.add_child(new_projectile)
		new_projectile.global_position = global_position
		initial_direction = rotation.xform(initial_direction)
		new_projectile.direction = initial_direction
		

func _on_body_entered(body: Node3D) -> void:
	if body is BaseEnemy:
		damage_body(body)
		if projectile.pierce <= 0:
			await get_tree().process_frame
			queue_free()
		else:
			projectile.pierce -= 1
