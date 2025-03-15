extends Node
class_name DamageableObject


signal hit(damage_amount : int, new_health : int)
signal death

enum DamagableTypes {Neutral, Energy, Structure}
enum DamagingTypes {Neutral, TrueDamage, Energy, Fire}

const K : int = 500     # used in the defense equation -> the smaller K is, the faster defense increases

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

@export var max_health : int = 100
@export var health : int = max_health
@export var type := DamagableTypes.Neutral
@export var defense := 1.0
@export var damage_threshold := 0
@export var element_resistances : Dictionary[DamagingTypes, float] = {
	DamagingTypes.Neutral : 0.0,
	DamagingTypes.TrueDamage : 0.0,
	DamagingTypes.Energy : 0.0,
	DamagingTypes.Fire : 0.0
}

static func compute_type_coeff(damaging_type : DamagingTypes, damaged_type : DamagableTypes,
			resistances : Dictionary[DamagingTypes, float]) -> float:
	return damage_table[damaging_type][damaged_type] * (1-resistances[damaging_type])

static func compute_defense_reduction(obj_defense : float) -> float:
	return 1 - pow(2.71828, -1/K * obj_defense)

static func compute_damage(damage_amount : int, damaging_type : DamagingTypes, 
									hit_obj : DamageableObject) -> int:
	# damage equation
	var total_damage : int = int(damage_amount * compute_type_coeff(damaging_type, 
	hit_obj.type, hit_obj.element_resistances) * (1-compute_defense_reduction(hit_obj.defense)))
	
	# check damage threshold
	if total_damage <= hit_obj.damage_threshold:
		total_damage = 0
	return total_damage

func damage(damage_amount : int, damage_type : DamagingTypes) -> void:
	var total_damage := compute_damage(damage_amount, damage_type, self)
	health -= total_damage
	if health < 0:
		health = 0
	emit_signal("hit", total_damage, health)
	if health == 0:
		emit_signal("death")
