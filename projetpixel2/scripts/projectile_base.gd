extends Node3D
class_name ProjectileBase

@export_category("Projectile stats")
@export var speed : float = 1.0
@export var damage : int = 50
@export var size := 1.0:
	set(value):
		size = value
		scale = Vector3(size, size, size)
@export var pierce := false
@export var damage_type := DamageableObject.DamagingTypes.Neutral
@export var critical_hit_chance := 0.01
@export var critical_hit_intensity := 10.0

var direction : Vector3 
var base_speed := 20.0

func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * base_speed * speed * delta

func damage_body(body : BaseEnemy) -> void:
	var is_crit : bool
	is_crit = RunData.random_float(0.0, 1.0) > 1.0-critical_hit_chance
	if is_crit:
		body.damageable.damage_critical(damage, damage_type, critical_hit_intensity)
	else:
		body.damageable.damage(damage, damage_type)

func _on_body_entered(body: Node3D) -> void:
	if body is BaseEnemy:
		damage_body(body)
		if not pierce:
			queue_free()
