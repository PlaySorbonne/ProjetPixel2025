extends StaticBody3D
class_name TowerBase


const PROJECTILE_RES := preload("res://scenes/spaceship/towers/projectiles/projectile_base.tscn")
const HOLOGRAM_RES := preload("res://resources/materials/3d_hologram_material.tres")

signal tower_fired
signal tower_switched_mode
signal tower_collected_xp
signal tower_upgraded
signal enemy_hit
signal enemy_killed
signal projectile_critical_hit
signal projectile_hit
signal projectile_destroyed

@export var tower_name := "TowerBase"
@export var is_hologram := false
@export var cards : Array[Card] = []
@export var enemy_choice := get_closest_enemy

@export_group("Tower Stats")
@export var projectile_res : PackedScene = PROJECTILE_RES
@export var number_of_projectiles := 1
@export var fire_rate := 1.0

var can_shoot := true
var focused_enemies : Array[BaseEnemy] = []

# components
@onready var clickable : ClickableObject = $ClickableObject

func _ready() -> void:
	GV.towers.append(self)
	if not is_hologram:
		$TimerShoot.start()
	else:
		set_hologram()

func add_card(card_obj: CardObject) -> void:
	var card : Card = card_obj.card
	card.tower = self
	cards.append(card)
	if card.trigger_signal != "":
		# connect signal specified in the card to corresponding tower 
		# signal, to execution of card effect
		if self.has_signal(card.trigger_signal):
			self.connect(card.trigger_signal, card.execute_card)
		else:
			print_debug("TOWER DOESN'T HAVE SIGNAL " + card.trigger_signal)
	else:
		# if there is no signal, trigger the card immediately
		card.execute_card()
		print("execute card now")
	card_obj.destroy_card_object()

func set_hologram(autodrag := true) -> void:
	$blasterM/blasterM.material_override = HOLOGRAM_RES
	$DragAndDrop.can_be_dragged = true
	$Area3D/CollisionShape3D.disabled = true
	if autodrag:
		$DragAndDrop.drag()
		$CollisionShape3D.disabled = true

func spawn_from_hologram() -> void:
	is_hologram = false
	$blasterM/blasterM.material_override = null
	$DragAndDrop.can_be_dragged = false
	$Area3D/CollisionShape3D.disabled = false

func set_tower_enable(new_enable : bool) -> void:
	set_process(new_enable)

func shoot_bonus() -> void:
	shoot(focused_enemies[0], true)

func get_closest_enemy() -> BaseEnemy:
	if len(focused_enemies) == 0:
		return null
	var closest_enemy : BaseEnemy = focused_enemies[0]
	var min_dist : float = global_position.distance_squared_to(closest_enemy.global_position)
	for i : int in range(1, len(focused_enemies)):
		var enemy : BaseEnemy = focused_enemies[i]
		var dist := global_position.distance_squared_to(enemy.global_position)
		if dist < min_dist:
			enemy = closest_enemy
			min_dist = dist
	return closest_enemy

func shoot(enemy : BaseEnemy, is_bonus := false) -> void:
	# idea: have a var "prepared_projectile", pass it to every card connected
	# to "tower_fired" and each card can modify prepared_projectile before actually shooting?
	#for card : CardObject in cards["tower_fired"]:
		#pass
	if not is_bonus:
		can_shoot = false
	look_at(enemy.position)
	var projectile := projectile_res.instantiate()
	GV.world.add_child(projectile)
	projectile.position = $ProjectileSpawnPos.global_position
	projectile.direction = projectile.position.direction_to(enemy.position)
	if not is_bonus:
		$TimerShoot.start(1.0 / fire_rate)

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

func _on_clickable_object_object_selected() -> void:
	if is_hologram:
		$DragAndDrop.press()
		$CollisionShape3D.disabled = true

func _on_clickable_object_object_unselected() -> void:
	pass
	# drop is handled in drag&drop component

func _on_drag_and_drop_dropped() -> void:
	# tower is a hologram
	$CollisionShape3D.disabled = false
	spawn_from_hologram()
