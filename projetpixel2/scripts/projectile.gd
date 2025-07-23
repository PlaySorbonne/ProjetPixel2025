extends Resource
class_name Projectile


var damage_expresion := default_damage_expression()
@export var speed : float = 1.0
@export var damage : int = 50
@export var size := 1.0
@export var pierce := 0
@export var damage_type := DamageableObject.DamagingTypes.Neutral
@export var critical_hit_chance := 0.01
@export var critical_hit_intensity := 10.0


func default_damage_expression() -> Expression:
	var expr : Expression = Expression.new()
	var expr_str := "damage"
	var err = expr.parse(expr_str)
	return expr

func set_damage_expression(new_expression : String) -> void:
	var expr : Expression = Expression.new()
	var expr_str := "new_expression"
	var err = expr.parse(expr_str)
	damage_expresion = expr

func get_damage() -> int:
	return damage_expresion.execute([], self)

func split_projectile(multiplier : float) -> Projectile:
	var new_projectile := Projectile.new()
	# same variables
	new_projectile.speed = speed
	new_projectile.pierce = pierce
	new_projectile.damage_type = damage_type
	new_projectile.critical_hit_chance = critical_hit_chance
	new_projectile.critical_hit_intensity = critical_hit_intensity
	new_projectile.damage_expresion = damage_expresion
	# changed variables
	new_projectile.damage = damage * multiplier
	new_projectile.size = size * multiplier
	return new_projectile
