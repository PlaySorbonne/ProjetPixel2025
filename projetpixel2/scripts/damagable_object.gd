extends Node
class_name DamagableObject


signal hit(damage_amount : int, new_health : int)
signal death

@export var health : int = 100

func damage(damage_amount : int) -> void:
	health -= damage_amount
	if health < 0:
		health = 0
	emit_signal("hit", damage_amount, health)
	if health == 0:
		emit_signal("death")
