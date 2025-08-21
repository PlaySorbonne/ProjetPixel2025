extends CharacterBody3D
class_name BaseEnemy

enum States {Moving, Attacking, Dead}

signal enemy_killed
signal enemy_hit
signal status_inflicted(status_type : StatusBase.StatusEffects)

static var living_enemies : Array[BaseEnemy] = []
static var number_of_enemies := 0
static var enemy_types : Array[String] = ["Puncher"]

@export var enemy_data : EnemyData

var status_effects : Array[StatusObjectBase] = []
var overlapping_enemies : Array[Node3D] = []
var can_attack := true
var can_move := true
var current_state := States.Moving
var current_animation := ""
var enemy_id := 0

# components
@onready var damageable : DamageableObject = $DamageableObject
@onready var clickable : ClickableObject = $ClickableObject

@onready var target : Node3D = GV.space_ship
@onready var mesh : Node3D = $mesh
@onready var mesh_animations : AnimationPlayer = $mesh/AnimationPlayer
@onready var attack_timer : Timer = $TimerAttacking


func _ready() -> void:
	damageable.health = enemy_data.hitpoints
	set_enemy_id()
	living_enemies.append(self)
	#print("enemy " + str(enemy_id) + " spawned!")

func get_health() -> int:
	return $DamageableObject.health

func set_enemy_id() -> void:
	enemy_id = number_of_enemies
	number_of_enemies += 1

func _physics_process(_delta: float) -> void:
	if current_state == States.Dead:
		return
	if current_state == States.Moving:
		if can_move:
			mesh_animations.play("sprint")
			velocity = position.direction_to(target.position) * enemy_data.speed * 1.5
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
		enemy_dmg.damage(enemy_data.damage, enemy_data.attack_type)
	mesh_animations.play("attack-melee-right")
	attack_timer.start(1.0/enemy_data.attack_speed)

func _on_timer_attacking_timeout() -> void:
	if current_state == States.Attacking:
		current_state = States.Moving

func death() -> void:
	if current_state == States.Dead:
		return
	current_state = States.Dead
	emit_signal("enemy_killed")
	living_enemies.erase(self)
	$CollisionShape3D.queue_free()
	mesh_animations.play("die")
	RunData.new_kill(enemy_data.enemy_type, enemy_data.is_alpha)
	# RunData.gain_experience(enemy_data.experience_points)
	ExperienceDrop.spawn_xp(position, enemy_data.experience_points)
	await(mesh_animations.animation_finished)
	await(get_tree().create_timer(3.0).timeout)
	queue_free()

func _on_damageable_object_death() -> void:
	death()

func _on_damage_area_body_entered(body: Node3D) -> void:
	if "damageable" in body and body is Spaceship:
		overlapping_enemies.append(body)

func _on_damage_area_body_exited(body: Node3D) -> void:
	overlapping_enemies.erase(body)

func _on_damageable_object_hit(damage_amount: int, new_health: int, damage_type: DamageableObject.DamagingTypes) -> void:
	enemy_hit.emit()
