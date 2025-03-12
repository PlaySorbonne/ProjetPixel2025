extends CharacterBody3D
class_name BaseEnemy

enum States {Moving, Attacking, Dead}

signal enemy_killed

static var number_of_enemies := 0

@export var health : int = 100
@export var movement_speed : float = 1.5
@export var damage_amount : int = 10
@export var attack_speed : float = 0.5
@export var attack_type : DamageableObject.DamagingTypes = DamageableObject.DamagingTypes.Neutral

var overlapping_enemies : Array[Node3D] = []
var can_attack := true
var current_state := States.Moving
var current_animation := ""
var enemy_id := 0

@onready var damageable : DamageableObject = $DamageableObject
@onready var target : Node3D = GV.space_ship
@onready var mesh : Node3D = $"figurine-cube"
@onready var mesh_animations : AnimationPlayer = $"figurine-cube/AnimationPlayer"
@onready var attack_timer : Timer = $TimerAttacking

func _ready() -> void:
	damageable.health = health
	set_enemy_id()
	#print("enemy " + str(enemy_id) + " spawned!")

func set_enemy_id() -> void:
	enemy_id = number_of_enemies
	number_of_enemies += 1

func _physics_process(_delta: float) -> void:
	if current_state == States.Dead:
		return
	if current_state == States.Moving:
		mesh_animations.play("sprint")
		velocity = position.direction_to(target.position) * movement_speed
		mesh.look_at(target.position)
		move_and_slide() 
	if len(overlapping_enemies) > 0:
		attack()

func attack() -> void:
	if not can_attack or current_state == States.Attacking or current_state == States.Dead:
		return
	current_state = States.Attacking
	for enemy : Node3D in overlapping_enemies:
		var enemy_dmg : DamageableObject = enemy.damageable
		enemy_dmg.damage(damage_amount, attack_type)
	mesh_animations.play("attack-melee-right")
	attack_timer.start(1.0/attack_speed)

func _on_timer_attacking_timeout() -> void:
	if current_state == States.Attacking:
		current_state = States.Moving

func death() -> void:
	if current_state == States.Dead:
		return
	current_state = States.Dead
	$CollisionShape3D.queue_free()
	mesh_animations.play("die")
	await(mesh_animations.animation_finished)
	await(get_tree().create_timer(1.0).timeout)
	emit_signal("enemy_killed")
	queue_free()

func _on_damageable_object_death() -> void:
	death()

func _on_damage_area_body_entered(body: Node3D) -> void:
	if "damageable" in body and body is Spaceship:
		overlapping_enemies.append(body)

func _on_damage_area_body_exited(body: Node3D) -> void:
	overlapping_enemies.erase(body)
