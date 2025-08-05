extends ExplosionBase
class_name ExplosionDamage


@export var damage_amount := 100
@export var damage_type := DamageableObject.DamagingTypes.Neutral


func apply_effect(enemy : BaseEnemy) -> void:
	enemy.damageable.damage(damage_amount, damage_type)
