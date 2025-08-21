extends Resource
class_name Projectile


var damage_expression : Callable = default_damage_expression
@export var speed : float = 1.0
@export var damage : int = 50
@export var size := 1.0
@export var pierce := 0
@export var bounce := 0
@export var damage_type := DamageableObject.DamagingTypes.Neutral
@export var critical_hit_chance := 0.01
@export var critical_hit_intensity := 10.0


func default_damage_expression() -> int:
	return damage

func get_damage() -> int:
	return damage_expression.call()

func split_projectile(multiplier : float) -> Projectile:
	var new_projectile := self.duplicate(true)
	# changed variables
	new_projectile.damage = damage * multiplier
	new_projectile.size = size * multiplier
	return new_projectile
