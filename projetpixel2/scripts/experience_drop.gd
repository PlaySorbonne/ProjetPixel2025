extends Area3D
class_name ExperienceDrop


class ExperienceLevel:
	var xp_amount : int
	var xp_color : Color
	
	func _init(xp_amount: int = 0, xp_color: Color = Color.WHITE) -> void:
		self.xp_amount = xp_amount
		self.xp_color = xp_color


const MAX_HP := 100
const NB_ORBS_MERGE := 3

static var experience_thresholds : Array[ExperienceLevel] = [
	ExperienceLevel.new(400, Color.BLACK),
	ExperienceLevel.new(200, Color.AQUA),
	ExperienceLevel.new(100, Color.BLUE),
	ExperienceLevel.new(50, Color.PURPLE),
	ExperienceLevel.new(25, Color.RED),
	ExperienceLevel.new(0, Color.WHITE),
]

static func spawn_xp(pos : Vector3, xp : int, fast_spawn := false) -> void:
	const EXPERIENCE_DROP_RES := preload("res://scenes/world/enemies/experience_drop.tscn")
	var experience_drop := EXPERIENCE_DROP_RES.instantiate()
	GV.world.add_child(experience_drop)
	experience_drop.position = pos
	experience_drop.experience_points = xp
	experience_drop.hitpoints = MAX_HP
	if not fast_spawn:
		experience_drop.create_experience_object()


signal xp_drop_collected(xp_amount : int)


@export var hitpoints := MAX_HP
@export var experience_points := 100:
	set(value):
		experience_points = value
		_apply_color()
var xp_level_index : int = 0:
	set(value):
		xp_level_index = value
		_check_neighbor_xp_drops()
var marked_for_deletion := false
var is_being_harvested := false
var is_mouse_over := false


func _process(delta: float) -> void:
	if is_mouse_over and Input.is_action_pressed("click") and not marked_for_deletion:
		marked_for_deletion = true
		xp_drop_collected.emit(experience_points)
		is_being_harvested = false
		#RunData.gain_experience(experience_points)
		set_process(false)
		await get_tree().create_timer(0.2).timeout
		destroy_experience_object()

func start_mining() -> void:
	is_being_harvested = true
	marked_for_deletion = true

func stop_mining() -> void:
	if is_being_harvested:
		is_being_harvested = false
		marked_for_deletion = false

func damage_xp(damage_amount : int) -> bool:
	if hitpoints <= 0:
		return true
	hitpoints -= damage_amount
	if hitpoints <= 0:
		# give xp reward
		xp_drop_collected.emit(experience_points)
		is_being_harvested = false
		#print("XP ORB COLLECTED")
		RunData.gain_experience(experience_points)
		# destroy object
		destroy_experience_object()
		return true
	else:
		return false

func create_experience_object() -> void:
	scale = Vector3.ZERO
	var t := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "scale", Vector3.ONE, 0.15)

func destroy_experience_object() -> void:
	var t := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "global_position", GV.space_ship.global_position, 0.4)
	await t.finished
	RunData.gain_experience(experience_points)
	DamagePopup.display_experience(experience_points)
	queue_free()

func merge_xp_drops(neighbors_xp : Array[ExperienceDrop]) -> void:
	# remove the neighbor and move self to mid point
	var new_xp := 0
	var new_pos := Vector3.ZERO
	for neighbor : ExperienceDrop in neighbors_xp:
		new_pos += neighbor.position
		new_xp += neighbor.experience_points
		neighbor.marked_for_deletion = true
	new_pos /= len(neighbors_xp)
	new_xp *= 1.1
	var t := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	for neighbor : ExperienceDrop in neighbors_xp:
		t.tween_property(neighbor, "position", new_pos, 0.4)
	await t.finished
	spawn_xp(
		new_pos,
		new_xp,
		true
	)
	for neighbor : ExperienceDrop in neighbors_xp:
		if is_instance_valid(neighbor):
			neighbor.queue_free()

func _check_neighbor_xp_drops() -> void:
	if is_merge_maxed():
		return
	var neighbors_xp : Array[ExperienceDrop] = [self]
	for area : Area3D in get_overlapping_areas():
		if check_can_merge(area):
			neighbors_xp.append(area)
			if len(neighbors_xp) == NB_ORBS_MERGE:
				merge_xp_drops(neighbors_xp)
				return

func is_merge_maxed() -> bool:
	return xp_level_index == 0

func check_can_merge(neighbour_xp : ExperienceDrop) -> bool:
	return not(marked_for_deletion or neighbour_xp.marked_for_deletion
				) and xp_level_index == neighbour_xp.xp_level_index

func _apply_color() -> void:
	var xp_level : ExperienceLevel
	for i : int in range(len(experience_thresholds)):
		xp_level = experience_thresholds[i]
		if experience_points >= xp_level.xp_amount :
			var xp_mat : ShaderMaterial = $MeshInstance3D.get_surface_override_material(0)
			xp_mat.set_shader_parameter("Color", xp_level.xp_color)
			xp_mat.set_shader_parameter("glow_color", xp_level.xp_color.lightened(0.5))
			xp_level_index = i
			return
	print_debug("wtf, negative xp => " + str(experience_points) + "?")

func _on_area_entered(area: Area3D) -> void:
	if is_merge_maxed():
		return
	_check_neighbor_xp_drops()

func _on_mouse_entered() -> void:
	is_mouse_over = true

func _on_mouse_exited() -> void:
	is_mouse_over = false
