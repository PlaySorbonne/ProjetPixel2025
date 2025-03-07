extends CharacterBody3D
class_name BaseEnemy

@export var health : int = 100

@onready var damagable : DamagableObject = $DamagableObject

func _ready() -> void:
	damagable.health = health

func _on_damagable_object_death() -> void:
	queue_free()
