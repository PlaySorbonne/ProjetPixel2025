extends Node3D
class_name TowerBase


const PROJECTILE_RES := preload("res://scenes/spaceship/towers/projectiles/projectile_base.tscn")

signal tower_fired
signal tower_switched_mode
signal tower_collected_xp
signal tower_upgraded


@export var shoot_delay := 0.25
var time_before_shoot := 0.0
var focused_enemies : Array[BaseEnemy] = []
var cards : Dictionary[String, Array] = {}

# components
@onready var clickable : ClickableObject = $ClickableObject

func _ready() -> void:
	GV.towers.append(self)

func set_tower_enable(new_enable : bool) -> void:
	set_process(new_enable)

func shoot(enemy : BaseEnemy) -> void:
	# idea: have a var "prepared_projectile", pass it to every card connected
	# to "tower_fired" and each card can modify prepared_projectile before actually shooting?
	#for card : CardObject in cards["tower_fired"]:
		#pass
	time_before_shoot = shoot_delay
	look_at(enemy.position)
	var projectile := PROJECTILE_RES.instantiate()
	GV.world.add_child(projectile)
	projectile.position = $ProjectileSpawnPos.global_position
	projectile.direction = projectile.position.direction_to(enemy.position)

func _process(delta: float) -> void:
	time_before_shoot -= delta 
	if len(focused_enemies) > 0 and time_before_shoot < 0:
		if not is_instance_valid(focused_enemies[0]):
			focused_enemies.pop_front()
		else:
			shoot(focused_enemies[0])

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is BaseEnemy:
		focused_enemies.append(body)
