extends Area3D
class_name ExperienceDrop


class ExperienceLevel:
	var xp_amount : int
	var xp_color : Color
	
	func _init(xp_amount: int = 0, xp_color: Color = Color.WHITE) -> void:
		self.xp_amount = xp_amount
		self.xp_color = xp_color

const NB_ORBS_MERGE := 3

static var experience_thresholds : Array[ExperienceLevel] = [
	ExperienceLevel.new(400, Color.WHITE),
	ExperienceLevel.new(200, Color.AQUA),
	ExperienceLevel.new(100, Color.BLUE),
	ExperienceLevel.new(50, Color.PURPLE),
	ExperienceLevel.new(25, Color.RED),
	ExperienceLevel.new(0, Color.BLACK),
]

static func spawn_xp(pos : Vector3, xp : int, fast_spawn := false, hp := 100) -> void:
	const EXPERIENCE_DROP_RES := preload("res://scenes/world/enemies/experience_drop.tscn")
	var experience_drop := EXPERIENCE_DROP_RES.instantiate()
	GV.world.add_child(experience_drop)
	experience_drop.position = pos
	experience_drop.experience_points = xp
	experience_drop.hitpoints = hp
	if not fast_spawn:
		experience_drop.create_experience_object()


signal xp_drop_collected(xp_amount : int)


@export var hitpoints := 100:
	set(value):
		hitpoints = value
		$MeshInstance3D.scale = Vector3.ONE * log(hitpoints / 100)
@export var experience_points := 100:
	set(value):
		experience_points = value
		_apply_color()
var xp_level_index : int = 0:
	set(value):
		xp_level_index = value
		print("spawn orb -> xp=" + str(experience_points) + " ; hp=" + str(hitpoints) + " ; level = " + str(xp_level_index))
		_check_neighbor_xp_drops()
var marked_for_deletion := false
var is_being_harvested := false


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
		print("XP ORB COLLECTED")
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
	t.tween_property(self, "scale", Vector3.ZERO, 0.15)
	await t.finished
	queue_free()

func merge_xp_drops(neighbors_xp : Array[ExperienceDrop]) -> void:
	# remove the neighbor and move self to mid point
	var new_xp := 0
	var new_hp := 0
	var new_pos := Vector3.ZERO
	for neighbor : ExperienceDrop in neighbors_xp:
		new_pos += neighbor.position
		new_xp += neighbor.experience_points
		new_hp += neighbor.hitpoints
		neighbor.marked_for_deletion = true
	new_pos /= len(neighbors_xp)
	new_xp *= 1.1
	new_hp *= 1.3
	var t := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	for neighbor : ExperienceDrop in neighbors_xp:
		t.tween_property(neighbor, "position", new_pos, 0.4)
	await t.finished
	spawn_xp(
		new_pos,
		new_xp,
		true,
		new_hp
	)
	for neighbor : ExperienceDrop in neighbors_xp:
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
			var xp_mat : StandardMaterial3D = $MeshInstance3D.get_surface_override_material(0)
			xp_mat.emission = xp_level.xp_color
			xp_level_index = i
			return
	print_debug("wtf, negative xp => " + str(experience_points) + "?")

func _on_area_entered(area: Area3D) -> void:
	if is_merge_maxed():
		return
	_check_neighbor_xp_drops()
