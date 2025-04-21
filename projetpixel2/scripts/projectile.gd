extends Resource
class_name Projectile

@export var speed : float = 1.0
@export var damage : int = 50
@export var size := 1.0
@export var pierce := false
@export var damage_type := DamageableObject.DamagingTypes.Neutral
@export var critical_hit_chance := 0.01
@export var critical_hit_intensity := 10.0

func split_projectile(multiplier : float) -> Projectile:
	var new_projectile := Projectile.new()
	# same variables
	new_projectile.speed = speed
	new_projectile.pierce = pierce
	new_projectile.damage_type = damage_type
	new_projectile.critical_hit_chance = critical_hit_chance
	new_projectile.critical_hit_intensity = critical_hit_intensity
	# changed variables
	new_projectile.damage = damage * multiplier
	new_projectile.size = size * multiplier
	return new_projectile
