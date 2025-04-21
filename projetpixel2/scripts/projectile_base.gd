extends Node3D
class_name ProjectileBase

var direction : Vector3 
var speed : float = 20.0
var damage : int = 50
var size := 1.0
var pierce := false
var damage_type := DamageableObject.DamagingTypes.Neutral

func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node3D) -> void:
	if body is BaseEnemy:
		body.damageable.damage(damage, damage_type)
		if not pierce:
			queue_free()
