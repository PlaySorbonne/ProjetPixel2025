extends Node
class_name DamagingObject

static func create_attack(dmg_amount := 10, dmg_type := DamageTypes.Neutral) -> DamagingObject:
	return DamagingObject.new()

enum DamageTypes {Neutral, TrueDamage, Energy, Fire}

var damage_amount : int
var damage_type : DamageTypes = DamageTypes.Energy

func set_type(new_type : DamageTypes) -> DamagingObject:
	damage_type = new_type
	return self

func set_amount(new_amount : int) -> DamagingObject:
	damage_amount = new_amount
	return self
