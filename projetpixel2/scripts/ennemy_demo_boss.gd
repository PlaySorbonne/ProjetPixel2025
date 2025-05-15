extends BaseEnemy
class_name EnemyDemoBoss

const MINION := preload("res://scenes/world/enemies/base_enemy.tscn")

var lives := 4


func death() -> void:
	lives -= 1
	if lives == 0:
		super.death()
		return
	elif lives == 1:
		enemy_data.health = 4000
	$DamageableObject.max_health = enemy_data.health
	$DamageableObject.health = enemy_data.health
	var rooted := StatusRooted.new()
	rooted.inflict_status(self)
	$DamageableObject.defense = 100.0
	$TimerDefense.start(3.0)
	set_collision_layer_value(0, false)
	set_collision_layer_value(1, false)

func _on_timer_minion_timeout() -> void:
	var minion := MINION.instantiate()
	GV.world.add_child(minion)
	minion.global_position = global_position

func _on_damageable_object_hit(damage_amount: int, new_health: int, damage_type: DamageableObject.DamagingTypes) -> void:
	$Label3D.text = str(enemy_data.health) + " / " + str(enemy_data.health)

func _on_timer_defense_timeout() -> void:
	$DamageableObject.defense = 1.0
	set_collision_layer_value(0, true)
	set_collision_layer_value(1, true)
