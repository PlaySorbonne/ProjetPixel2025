extends CharacterBody3D
class_name BaseEnemy

@export var health : int = 100
@export var speed : float = 2.0

@onready var damagable : DamagableObject = $DamagableObject
@onready var target : Node3D = GV.space_ship
@onready var mesh : Node3D = $"figurine-cube"

func _ready() -> void:
	damagable.health = health

func _physics_process(delta: float) -> void:
	velocity = position.direction_to(target.position) * speed
	mesh.look_at(target.position)
	move_and_slide()

func _on_damagable_object_death() -> void:
	queue_free()
