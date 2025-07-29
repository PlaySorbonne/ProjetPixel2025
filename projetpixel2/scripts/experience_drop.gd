extends Area3D
class_name ExperienceDrop


class ExperienceLevel:
	var xp_amount : int
	var xp_color : Color
	
	func _init(xp_amount: int = 0, xp_color: Color = Color.WHITE) -> void:
		self.xp_amount = xp_amount
		self.xp_color = xp_color

static var experience_thresholds : Array[ExperienceLevel] = [
	ExperienceLevel.new(1600, Color.WHITE),
	ExperienceLevel.new(800, Color.AQUA),
	ExperienceLevel.new(400, Color.BLUE),
	ExperienceLevel.new(200, Color.PURPLE),
	ExperienceLevel.new(0, Color.RED),
]

static func spawn_xp(pos : Vector3, xp : int) -> void:
	const EXPERIENCE_DROP_RES := preload("res://scenes/world/enemies/experience_drop.tscn")
	var experience_drop := EXPERIENCE_DROP_RES.instantiate()
	GV.world.add_child(experience_drop)
	experience_drop.position = pos
	experience_drop.experience_points = xp
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
	t.tween_property(self, "scale", Vector3.ONE, 0.8)

func destroy_experience_object() -> void:
	var t := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "scale", Vector3.ZERO, 0.2)
	await t.finished
	queue_free()

func merge_xp_drops(neighbor_xp : ExperienceDrop) -> void:
	# remove the neighbor and move self to mid point
	neighbor_xp.marked_for_deletion = true
	hitpoints = (hitpoints + neighbor_xp.hitpoints) / 2
	experience_points = (experience_points + neighbor_xp.experience_points) * 2
	position = (position + neighbor_xp.position) / 2
	neighbor_xp.queue_free()

func _check_neighbor_xp_drops() -> void:
	for area : Area3D in get_overlapping_areas():
		if marked_for_deletion or not(area is ExperienceDrop) or area.marked_for_deletion:
			continue
		if xp_level_index == area.xp_level_index:
			merge_xp_drops(area)
			return

func _apply_color() -> void:
	var xp_level : ExperienceLevel
	for i : int in range(len(experience_thresholds)):
		xp_level = experience_thresholds[i]
		if experience_points > xp_level.xp_amount :
			var xp_mat : StandardMaterial3D = $CSGSphere3D.material
			xp_mat.emission = xp_level.xp_color
			xp_level_index = i
			return
	print_debug("wtf, negative xp => " + str(experience_points) + "?")

func _on_area_entered(area: Area3D) -> void:
	if marked_for_deletion or not(area is ExperienceDrop) or area.marked_for_deletion:
		return
	if xp_level_index == area.xp_level_index:
		merge_xp_drops(area)
