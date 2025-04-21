extends Resource
class_name Projectile

@export var speed : float = 1.0
@export var damage : int = 50
@export var size := 1.0
@export var pierce := false
@export var damage_type := DamageableObject.DamagingTypes.Neutral
@export var critical_hit_chance := 0.01
@export var critical_hit_intensity := 10.0
