extends StaticBody3D
class_name TowerBase


enum Modes {Firing, Mining, Transition}

const PROJECTILE_RES := preload("res://scenes/spaceship/towers/projectiles/projectile_base.tscn")
const HOLOGRAM_RES := preload("res://resources/materials/3d_hologram_material.tres")
const MAX_IDLE_TIME := 0.5

signal tower_card_added(card: CardData)
signal tower_fired(projectile : ProjectileBase, enemy : BaseEnemy)
signal tower_switched_mode
signal tower_collected_xp(projectile : ProjectileBase, enemy : BaseEnemy)
signal tower_upgraded(projectile : ProjectileBase, enemy : BaseEnemy)
signal enemy_hit(projectile : ProjectileBase, enemy : BaseEnemy)
signal enemy_killed(projectile : ProjectileBase, enemy : BaseEnemy)
signal projectile_critical_hit(projectile : ProjectileBase, enemy : BaseEnemy)
signal start_mining
signal tower_can_switch_mode

@export var tower_name := "TowerBase"
@export_multiline var tower_description := "Most standardized galactic exploration tower drone model. Capable of shooting balistic projectiles and collecting minerals from the ground."
@export var is_hologram := false
@export var cards : Array[CardData] = []
@export var enemy_choice := get_spaceship_closest_enemy # method used to select the targeted enemy
@export var shooting_orbs := false
var current_mode := Modes.Firing
var can_switch_mode := true
var idle_timer := 0.5
var is_mining_orb := false
var current_mined_orb : ExperienceDrop
var can_shoot := true
var mining_laser : TowerMiningLaser

@export_group("Tower stats")
@export var projectile_res : PackedScene = PROJECTILE_RES
@export var number_of_projectiles := 1
@export var fire_rate := 1.0
@export var projectile_template : Projectile = Projectile.new()
@export var max_number_of_cards := 5
@export var fire_range := 10.0:
	set(value):
		fire_range = value
		var new_shader_size := value / 10.0 * 0.4  # value / CollisionShape3D.radius * MeshInstance3D.material.size
		if is_visible_in_tree():
			var t := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
			var initial_shader_size : float = $Area3D/MeshInstance3D.material_override.get_shader_parameter("size")
			t.tween_method(_update_fire_range_shader, initial_shader_size, new_shader_size, 0.1)
		else:
			$Area3D/MeshInstance3D.material_override.set_shader_parameter("size", new_shader_size)
		$Area3D/CollisionShape3D.shape.radius = value
@export var switch_mode_duration := 1.5
@export var switch_mode_delay := 5.0
@export var damage_to_xp := 90

# components
@onready var clickable : ClickableObject = $ClickableObject
@onready var projectile_spawn_pos := $blasterM/ProjectileSpawnPos
@onready var area3d := $Area3D
@onready var areaXp := $AreaXP

func _ready() -> void:
	GV.towers.append(self)
	if not is_hologram:
		$TimerShoot.start()
	else:
		set_hologram()

func _update_fire_range_shader(new_size : float) -> void:
	$Area3D/MeshInstance3D.material_override.set_shader_parameter("size", new_size)

func switch_mode() -> void:
	if not can_switch_mode:
		return
	match current_mode:
		Modes.Firing:
			switch_to_mining()
		Modes.Mining:
			switch_to_firing()

func switch_to_mining() -> void:
	if current_mode == Modes.Mining:
		return
	_trigger_switch_mode_anim(Modes.Mining)

func switch_to_firing() -> void:
	if current_mode == Modes.Firing:
		return
	_trigger_switch_mode_anim(Modes.Firing)
	stop_mining_orb()

func _trigger_switch_mode_anim(new_mode : Modes) -> void:
	# enter transition state
	current_mode = Modes.Transition
	can_switch_mode = false
	$TimerSwitchModes.start(switch_mode_delay)
	var final_mining_mesh_pos : Vector3
	match new_mode:
		Modes.Mining:
			final_mining_mesh_pos = Vector3(0.0, 0.0, 0.0)
		Modes.Firing:
			final_mining_mesh_pos = Vector3(0.0, -0.5, 0.0)
	var t := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	t.tween_property($MiningMesh, "position", final_mining_mesh_pos, switch_mode_duration)
	await t.finished
	current_mode = new_mode
	tower_switched_mode.emit()
	# check if there is anything to do in new mode now that transition is complete
	match current_mode:
		Modes.Mining:
			check_for_orbs()
		Modes.Firing:
			pass

func _on_timer_switch_modes_timeout() -> void:
	can_switch_mode = true
	tower_can_switch_mode.emit()

func check_for_orbs() -> void:
	print("CHECKING FOR ORBS, FOUND " + str(len($AreaXP.get_overlapping_areas())))
	for area : Area3D in $AreaXP.get_overlapping_areas():
		if area is ExperienceDrop and not area.marked_for_deletion:
			start_mining_orb(area)
			return

func start_mining_orb(experience_drop : ExperienceDrop) -> void:
	is_mining_orb = true
	mining_laser = TowerMiningLaser.spawn_tower_mining_laser(global_position, experience_drop)
	current_mined_orb = experience_drop
	experience_drop.start_mining()
	experience_drop.xp_drop_collected.connect(xp_orb_collected)
	$TimerMineXp.start()
	print("start mining orb " + str(experience_drop))

func stop_mining_orb() -> void:
	is_mining_orb = false
	if is_instance_valid(current_mined_orb):
		current_mined_orb.stop_mining()
	current_mined_orb = null
	if is_instance_valid(mining_laser):
		mining_laser.destroy_laser()
	mining_laser = null

func xp_orb_collected(xp_amount : int) -> void:
	stop_mining_orb()
	check_for_orbs()

func _on_timer_mine_xp_timeout() -> void:
	if is_instance_valid(current_mined_orb):
		var xp_destroyed := current_mined_orb.damage_xp(damage_to_xp)
		if xp_destroyed:
			stop_mining_orb()
		else:
			$TimerMineXp.start()

func can_add_card() -> bool:
	return cards.size() < max_number_of_cards

func add_card(card_obj: CardObject) -> void:
	if not can_add_card():
		return 
	var card : CardData = card_obj.card
	card.card_code.tower = self
	cards.append(card)
	tower_card_added.emit(card)
	if card.trigger_signal != "":
		# connect signal specified in the card to corresponding tower 
		# signal, to execution of card effect
		if self.has_signal(card.trigger_signal):
			self.connect(card.trigger_signal, card.execute_card)
		else:
			print_debug("TOWER DOESN'T HAVE SIGNAL " + card.trigger_signal)
	else:
		# if there is no signal, trigger the card immediately
		card.execute_card(null, null)
		print("execute card now")
	card_obj.destroy_card_object()
	TowerCard3DIndicator.add_card_indicator(self)

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

func _process(delta: float) -> void:
	idle_timer -= delta
	if idle_timer > 0:
		return
	idle_timer = MAX_IDLE_TIME
	match current_mode:
		Modes.Firing:
			if can_shoot:
				try_shoot_enemy()
		Modes.Mining:
			if not is_mining_orb:
				check_for_orbs()

func get_focused_enemies() -> Array[Node3D]:
	return area3d.get_overlapping_bodies()

func get_spaceship_closest_enemy() -> BaseEnemy:
	var nb_focused_enemies := len(get_focused_enemies())
	#print("nb_focused_enemies = " + str(nb_focused_enemies))
	if nb_focused_enemies == 0:
		return null
	var closest_enemy : BaseEnemy = get_focused_enemies()[0]
	var min_dist : float = GV.space_ship.global_position.distance_squared_to(
							closest_enemy.global_position)
	#print("\tinit min_dist = ", min_dist)
	for i : int in range(1, nb_focused_enemies):
		var enemy : BaseEnemy = get_focused_enemies()[i]
		if not is_instance_valid(enemy):
			print_debug("PROBLEME")
			return null
		var dist := GV.space_ship.global_position.distance_squared_to(enemy.global_position)
		if dist < min_dist:
			#print("\tmin_dist = ", dist)
			enemy = closest_enemy
			min_dist = dist
	return closest_enemy

func get_closest_enemy() -> BaseEnemy:
	var nb_focused_enemies := len(get_focused_enemies())
	if nb_focused_enemies == 0:
		return null
	var closest_enemy : BaseEnemy = get_focused_enemies()[0]
	var min_dist : float = global_position.distance_squared_to(closest_enemy.global_position)
	for i : int in range(1, nb_focused_enemies):
		var enemy : BaseEnemy = get_focused_enemies()[i]
		if not is_instance_valid(enemy):
			return null
		var dist := global_position.distance_squared_to(enemy.global_position)
		if dist < min_dist:
			enemy = closest_enemy
			min_dist = dist
	return closest_enemy

func shoot(enemy : BaseEnemy, is_bonus := false) -> void:
	if not is_instance_valid(enemy):
		print_debug("Invalid enemy targeted")
		return
	if not is_bonus:
		can_shoot = false
	look_at(Vector3(
		enemy.position.x,
		position.y,
		enemy.position.z
	))
	var projectile_obj : ProjectileBase 
	if shooting_orbs:
		const PROJECTILE_ORB := preload("res://scenes/spaceship/towers/projectiles/projectile_orb.tscn")
		projectile_obj = PROJECTILE_ORB.instantiate()
	else:
		projectile_obj = projectile_res.instantiate()
	projectile_obj.projectile = projectile_template.duplicate()
	projectile_obj.tower = self
	GV.world.add_child(projectile_obj)
	projectile_obj.position = Vector3(
		projectile_spawn_pos.global_position.x,
		enemy.position.y,
		projectile_spawn_pos.global_position.z
	)
	projectile_obj.direction = projectile_obj.position.direction_to(enemy.position)
	if not is_bonus:
		tower_fired.emit(projectile_obj, null)
		$TimerShoot.start(1.0 / fire_rate)
		for _i : int in range(number_of_projectiles-1):
			await get_tree().create_timer(1.0 / (fire_rate * 10.0)).timeout
			shoot_bonus(enemy)

func shoot_bonus(enemy : BaseEnemy = null) -> void:
	if enemy == null:
		enemy = enemy_choice.call()
	shoot(enemy, true)

func shoot_bonus_with_delay(delay : float) -> void:
	await get_tree().create_timer(delay).timeout
	shoot(enemy_choice.call(), true)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is BaseEnemy and can_shoot and current_mode == Modes.Firing:
		shoot(body)

func _on_timer_shoot_timeout() -> void:
	can_shoot = true
	if current_mode == Modes.Firing:
		try_shoot_enemy()

func try_shoot_enemy() -> void:
	if len(get_focused_enemies()) > 0:
		var focused_enemy : BaseEnemy = enemy_choice.call()
		if focused_enemy != null:
			shoot(focused_enemy)

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

func _on_clickable_object_object_hovered() -> void:
	pass
#	print("hello")

func _on_clickable_object_object_unhovered() -> void:
	pass
#	print("goodbye")
