extends Resource
class_name Projectile


var damage_expression : Callable = default_damage_expression # expression used to compute the damage done by the projectile.
@export var speed : float = 1.0 # speed multiplier of the projectile
@export var damage : int = 50 # base damage of the projectile
@export var size := 1.0 # size multiplier of the projectile
@export var pierce := 0 # number of times the projectile can pierce an enemy
@export var bounce := 0 # number of times the projectile can bounce on an enemy
@export var damage_type := DamageableObject.DamagingTypes.Neutral # type of the projectile
@export var critical_hit_chance := 0.01 # chance of a critical hit
@export var critical_hit_intensity := 10.0 # critical hit damage multiplier


func default_damage_expression() -> int:
	return damage

func get_damage() -> int:
	return damage_expression.call()

func split_projectile(multiplier : float) -> Projectile:
	var new_projectile := self.duplicate()
	new_projectile.damage_expression = damage_expression
	# changed variables
	new_projectile.damage = damage * multiplier
	new_projectile.size = size * multiplier
	return new_projectile
