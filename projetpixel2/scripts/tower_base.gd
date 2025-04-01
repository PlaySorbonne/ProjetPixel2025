extends Node3D
class_name TowerBase


const PROJECTILE_RES := preload("res://scenes/spaceship/towers/projectiles/projectile_base.tscn")

signal tower_fired
signal tower_switched_mode
signal tower_collected_xp
signal tower_upgraded

@export var tower_name := "TowerBase"

@export_group("Tower Stats")
@export var projectile_res : PackedScene = PROJECTILE_RES
@export var number_of_projectiles := 1
@export var fire_rate := 1.0

@export_group("Cards")
@export var cards_tower : Array[CardObject] = []
@export var cards_projectile : Array[CardObject] = []
@export var cards_enemy : Array[CardObject] = []

@onready var shoot_delay := 1.0 / fire_rate
var can_shoot := true
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
	can_shoot = false
	look_at(enemy.position)
	var projectile := projectile_res.instantiate()
	GV.world.add_child(projectile)
	projectile.position = $ProjectileSpawnPos.global_position
	projectile.direction = projectile.position.direction_to(enemy.position)
	$TimerShoot.start(shoot_delay)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is BaseEnemy:
		focused_enemies.append(body)
		body.connect("enemy_killed", remove_focus_enemy)
		if can_shoot:
			shoot(body)

func remove_focus_enemy(enemy : BaseEnemy) -> void:
	focused_enemies.erase(enemy)

func _on_timer_shoot_timeout() -> void:
	can_shoot = true
	if len(focused_enemies) > 0:
		while len(focused_enemies) > 0:
			var focused_enemy := len(focused_enemies) - 1
			if not is_instance_valid(focused_enemies[focused_enemy]):
				focused_enemies.pop_back()
				focused_enemy -= 1
			else:
				shoot(focused_enemies[focused_enemy])
				break
