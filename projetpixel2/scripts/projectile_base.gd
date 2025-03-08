extends Node3D
class_name ProjectileBase

var direction : Vector3 
var speed : float = 30.0
var damage_amount : int = 50
var damage_type := DamageableObject.DamagingTypes.Neutral

func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node3D) -> void:
	print("hello " + str(body))
	if body is BaseEnemy:
		body.damageable.damage(damage_amount, damage_type)
		print("YOU GON DIE BISH")
