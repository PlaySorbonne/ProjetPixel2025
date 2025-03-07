extends Node
class_name DamagableObject


signal hit(damage_amount : int, new_health : int)
signal death

enum DamagableTypes {Neutral, Energy, Structure}
enum DamagingTypes {Neutral, TrueDamage, Energy, Fire}

static var damage_table : Dictionary = {
	DamagingTypes.Neutral : {
		DamagableTypes.Neutral : 1.0,
		DamagableTypes.Energy : 0.8,
		DamagableTypes.Structure : 1.0,
	},
	DamagingTypes.TrueDamage : {
		DamagableTypes.Neutral : 1.0,
		DamagableTypes.Energy : 1.0,
		DamagableTypes.Structure : 1.0,
	},
	DamagingTypes.Energy : {
		DamagableTypes.Neutral : 1.0,
		DamagableTypes.Energy : 0.5,
		DamagableTypes.Structure : 1.5,
	},
	DamagingTypes.Fire : {
		DamagableTypes.Neutral : 1.0,
		DamagableTypes.Energy : 1.5,
		DamagableTypes.Structure : 0.75,
	},
}

@export var health : int = 100
@export var type := DamagableTypes.Neutral
@export var defense := 1.0

static func compute_type_coeff(damaging_type : DamagingTypes, damaged_type : DamagableTypes) -> float:
	return damage_table[damaging_type][damaged_type]

static func compute_damage(damage_amount : int, damage_type : DamagingTypes, 
				damaged_type : DamagableTypes, defense : float) -> int:
	var type_coeff : float = compute_type_coeff(damage_type, damaged_type)
	
	return int(damage_amount * type_coeff / defense)

func damage(damage_amount : int, damage_type : DamagingTypes) -> void:
	var type_coeff : float = compute_type_coeff(damage_type, type)
	health -= damage_amount
	if health < 0:
		health = 0
	emit_signal("hit", damage_amount, health)
	if health == 0:
		emit_signal("death")
