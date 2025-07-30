extends Area3D
class_name ExperienceDrop


class ExperienceLevel:
	var xp_amount : int
	var xp_color : Color
	
	func _init(xp_amount: int = 0, xp_color: Color = Color.WHITE) -> void:
		self.xp_amount = xp_amount
		self.xp_color = xp_color

static var experience_thresholds : Array[ExperienceLevel] = [
	ExperienceLevel.new(3200, Color.WHITE),
	ExperienceLevel.new(1600, Color.AQUA),
	ExperienceLevel.new(800, Color.BLUE),
	ExperienceLevel.new(400, Color.PURPLE),
	ExperienceLevel.new(200, Color.RED),
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


signal xp_drop_collected(xp_amount)


@export var hitpoints := 100
@export var experience_points := 100:
	set(value):
		experience_points = value
		_apply_color()
var xp_level_index : int = 0:
	set(value):
		xp_level_index = value
		_check_neighbor_xp_drops()
var marked_for_deletion := false


func damage_xp(damage_amount : int) -> void:
	if hitpoints <= 0:
		return
	hitpoints -= damage_amount
	if hitpoints <= 0:
		xp_drop_collected.emit(experience_points)
		destroy_experience_object()

func create_experience_object() -> void:
	scale = Vector3.ZERO
	var t := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "scale", Vector3.ONE, 0.15)

func destroy_experience_object() -> void:
	var t := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "scale", Vector3.ZERO, 0.15)
	await t.finished
	queue_free()

func merge_xp_drops(neighbor_xp : ExperienceDrop) -> void:
	# remove the neighbor and move self to mid point
	neighbor_xp.marked_for_deletion = true
	marked_for_deletion = true
	var new_pos := (position + neighbor_xp.position) / 2
	var t := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	t.tween_property(self, "position", new_pos, 0.4)
	t.tween_property(neighbor_xp, "position", new_pos, 0.4)
	await t.finished
	print("spawn xp -> " + str(experience_points + neighbor_xp.experience_points))
	spawn_xp(
		new_pos,
		(experience_points + neighbor_xp.experience_points) * 2,
		true,
		(hitpoints + neighbor_xp.hitpoints) / 2
	)
	neighbor_xp.queue_free()
	queue_free()

func _check_neighbor_xp_drops() -> void:
	if is_merge_maxed():
		return
	for area : Area3D in get_overlapping_areas():
		if check_can_merge(area):
			merge_xp_drops(area)
			return

func is_merge_maxed() -> bool:
	print("current merge = " + str(xp_level_index))
	return xp_level_index == 0

func check_can_merge(neighbour_xp : ExperienceDrop) -> bool:
	return not(marked_for_deletion or neighbour_xp.marked_for_deletion) and xp_level_index == neighbour_xp.xp_level_index

func _apply_color() -> void:
	var xp_level : ExperienceLevel
	for i : int in range(len(experience_thresholds)):
		xp_level = experience_thresholds[i]
		if experience_points >= xp_level.xp_amount :
			var xp_mat : StandardMaterial3D = $CSGSphere3D.material
			xp_mat.emission = xp_level.xp_color
			xp_level_index = i
			return
	print_debug("wtf, negative xp => " + str(experience_points) + "?")

func _on_area_entered(area: Area3D) -> void:
	if is_merge_maxed():
		return
	if check_can_merge(area):
		merge_xp_drops(area)
