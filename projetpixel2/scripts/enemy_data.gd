extends Resource
class_name EnemyData


enum EnemyTypes {
	Insectoid,
	Plant,
	Telluric,
	Fungal
}


@export var enemy_type : String = "EnemyBase"
@export_multiline var description := ""
@export var mob_type : EnemyTypes = EnemyTypes.Insectoid
@export var is_alpha := false
@export var difficulty := 1.0
@export var hitpoints := 100
@export var speed := 1.0
@export var defense := 1.0
@export var defense_type : DamageableObject.DamageableTypes
@export var resistances : Dictionary[DamageableObject.DamagingTypes, float] = {}
@export var damage_threshold := 0
@export var damage : int = 10
@export var attack_speed : float = 0.5
@export var attack_type : DamageableObject.DamagingTypes = DamageableObject.DamagingTypes.Neutral
@export var experience_points := 8
@export var resource_drop := 1
@export var spawn_probability := 0.5
@export var min_wave := -1
@export var max_wave := -1
