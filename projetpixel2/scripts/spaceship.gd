extends Node3D
class_name Spaceship

var shields := 500.0
var health := 100.0
var has_shields := true

@onready var damagable : DamagableObject = $DamagableObject

func _ready() -> void:
	GV.enemy_target = self
