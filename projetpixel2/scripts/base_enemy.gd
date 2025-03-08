extends CharacterBody3D
class_name BaseEnemy

@export var health : int = 100
@export var speed : float = 5.0
@export var damage_amount : int = 10
@export var attack_delay : float = 1.0
@export var attack_type : DamageableObject.DamagingTypes = DamageableObject.DamagingTypes.Neutral

var overlapping_enemies : Array[Node3D] = []
var can_attack := true
var current_attack_delay := 0.0

@onready var damageable : DamageableObject = $DamageableObject
@onready var target : Node3D = GV.space_ship
@onready var mesh : Node3D = $"figurine-cube"

func _ready() -> void:
	damageable.health = health

func _physics_process(delta: float) -> void:
	velocity = position.direction_to(target.position) * speed
	mesh.look_at(target.position)
	move_and_slide() 
	if len(overlapping_enemies) > 0:
		current_attack_delay -= delta
		if current_attack_delay <= 0.0:
			attack()

func attack() -> void:
	if not can_attack:
		return
	for enemy : Node3D in overlapping_enemies:
		var enemy_dmg : DamageableObject = enemy.damageable
		enemy_dmg.damage(damage_amount, attack_type)
	current_attack_delay = attack_delay

func _on_damageable_object_death() -> void:
	print("death")
	queue_free()

func _on_damage_area_body_entered(body: Node3D) -> void:
	if "damageable" in body and body is Spaceship:
		overlapping_enemies.append(body)

func _on_damage_area_body_exited(body: Node3D) -> void:
	overlapping_enemies.erase(body)
