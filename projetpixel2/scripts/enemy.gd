extends Resource
class_name Enemy


enum EnemyTypes {
	Insectoid,
	Plant,
	Telluric,
	Fungal
}


@export var enemy_type : String = "EnemyBase"
@export var description := ""
@export var mob_type : EnemyTypes = EnemyTypes.Insectoid
@export var is_alpha := false
@export var difficulty := 1.0
@export var hitpoints := 100
@export var speed := 1.0
@export var defense := 1.0
@export var defense_type : DamageableObject.DamageableTypes


@export var damage_amount : int = 10
@export var attack_speed : float = 0.5
@export var attack_type : DamageableObject.DamagingTypes = DamageableObject.DamagingTypes.Neutral
@export var experience_points := 8
