extends AuraBase
class_name SchockwaveAura


var damage_per_tick := 5

func apply_effect() -> void:
	for enemy : BaseEnemy in get_overlapping_bodies():
		enemy.damageable.damage(damage_per_tick, DamageableObject.DamagingTypes.Energy, false)
