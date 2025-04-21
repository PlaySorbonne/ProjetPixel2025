extends Node3D
class_name ProjectileBase

const PROJECTILE_RES := preload("res://scenes/spaceship/towers/projectiles/projectile_base.tscn")

static var critical_hits_number := 0
static var hits_number := 0

signal projectile_hit
signal projectile_critical_hit

var projectile : Projectile

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
	emit_signal("projectile_hit")
	if is_crit:
		emit_signal("projectile_critical_hit")
		critical_hits_number += 1
		body.damageable.damage_critical(
			projectile.damage, 
			projectile.damage_type, 
			projectile.critical_hit_intensity)
	else:
		body.damageable.damage(
			projectile.damage, 
			projectile.damage_type)

func split(number_of_children : int, total_angle : float, children_multiplier := 0.9) -> void:
	#TODO
	var angle_increment := total_angle / float(number_of_children)
	var initial_angle : float
	for i : int in range(number_of_children):
		var new_projectile : ProjectileBase = PROJECTILE_RES.instantiate()
		new_projectile.projectile = projectile.split_projectile(children_multiplier)
		GV.world.add_child(new_projectile)
		new_projectile.global_position = global_position

func _on_body_entered(body: Node3D) -> void:
	if body is BaseEnemy:
		damage_body(body)
		if not projectile.pierce:
			queue_free()
