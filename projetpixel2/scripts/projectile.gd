extends Resource
class_name Projectile


var damage_expression : Callable = default_damage_expression
var damage_script : RefCounted
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

func set_damage_expression(new_expression : String) -> void:
	var subscript = GDScript.new()
	subscript.source_code = "extends Resource\n\nfunc eval() -> int:\n\treturn " + new_expression
	subscript.reload()
	damage_script = RefCounted.new()
	damage_script.set_script(subscript)
	damage_expression

func get_damage() -> int:
	return damage_expression.call()

func split_projectile(multiplier : float) -> Projectile:
	var new_projectile := Projectile.new()
	# same variables
	new_projectile.speed = speed
	new_projectile.pierce = pierce
	new_projectile.damage_type = damage_type
	new_projectile.critical_hit_chance = critical_hit_chance
	new_projectile.critical_hit_intensity = critical_hit_intensity
	new_projectile.damage_expression = damage_expression
	# changed variables
	new_projectile.damage = damage * multiplier
	new_projectile.size = size * multiplier
	return new_projectile
