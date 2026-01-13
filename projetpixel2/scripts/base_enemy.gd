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
@export var mesh : Node3D
@export var mesh_animations : AnimationPlayer
@export var run_anim := "Armature|Rat_Run"
@export var attack_anim := "Armature|Rat_Attack"
@export var death_anim := "Armature|Rat_Death"

var followed_path: Path3D
var target_point_index := 0
var target_position : Vector3
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

func follow_path() -> void:
	# get target point
	if target_point_index < followed_path.curve.point_count:
		target_position = followed_path.curve.get_point_position(target_point_index)
	
	# get next point index if target point is reached
	if position.distance_to(target_position) < 0.5 && target_point_index < followed_path.curve.point_count:
		target_point_index += 1
	
	# if last point is reached, attack the spaceship
	if target_point_index == followed_path.curve.point_count && position.distance_to(target_position) < 0.5:
		target_position = GV.space_ship.position
		# current_state = States.Attacking
		
	# move to target
	mesh_animations.play("sprint")
	velocity = position.direction_to(target_position) * enemy_data.speed * 1.5
	mesh.look_at(target_position)
	
	#print("Heading to point " + str(target_point_index))
	move_and_slide() 

func _physics_process(_delta: float) -> void:
	if current_state == States.Dead:
		return
	if current_state == States.Moving:
		if can_move:
			mesh_animations.play(run_anim)
			follow_path()
	if len(overlapping_enemies) > 0:
		attack()

func attack() -> void:
	if not can_attack or current_state == States.Attacking or current_state == States.Dead:
		return
	current_state = States.Attacking
	for enemy : Node3D in overlapping_enemies:
		var enemy_dmg : DamageableObject = enemy.damageable
		enemy_dmg.damage(enemy_data.damage, enemy_data.attack_type)
	mesh_animations.play(attack_anim)
	attack_timer.start(1.0/enemy_data.attack_speed)

func _on_timer_attacking_timeout() -> void:
	if current_state == States.Attacking:
		current_state = States.Moving

func death() -> void:
	if current_state == States.Dead:
		return
	current_state = States.Dead
	living_enemies.erase(self)
	emit_signal("enemy_killed")
	$CollisionShape3D.queue_free()
	mesh_animations.play(death_anim)
	RunData.new_kill(enemy_data.enemy_type, enemy_data.is_alpha)
	# RunData.gain_experience(enemy_data.experience_points)
	ExperienceDrop.spawn_xp(position, enemy_data.experience_points)
	await(mesh_animations.animation_finished)
	var buried_pos := position + Vector3(0.25, -3.0, 0.25)
	var t := create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC).set_parallel()
	t.tween_property(self, "position", buried_pos, 5.0)
	t.tween_property(self, "scale", scale/1.6, 5.0)
	t.finished.connect(queue_free)

func _on_damageable_object_death() -> void:
	death()

func _on_damage_area_body_entered(body: Node3D) -> void:
	print("entered spaceship")
	if "damageable" in body and body is Spaceship:
		overlapping_enemies.append(body)

func _on_damage_area_body_exited(body: Node3D) -> void:
	overlapping_enemies.erase(body)

func _on_damageable_object_hit(damage_amount: int, new_health: int, damage_type: DamageableObject.DamagingTypes) -> void:
	enemy_hit.emit()
