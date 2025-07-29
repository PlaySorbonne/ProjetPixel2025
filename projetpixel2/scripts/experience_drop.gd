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

func damage_xp(damage_amount : int) -> void:
	if hitpoints <= 0:
		return
	hitpoints -= damage_amount
	if hitpoints <= 0:
		xp_drop_collected.emit(experience_points)
		destroy_experience_object()

func destroy_experience_object() -> void:
	var t := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "scale", Vector3.ZERO, 0.2)
	await t.finished
	queue_free()

func merge_xp_drops(neighbor_xp : ExperienceDrop) -> void:
	hitpoints = (hitpoints + neighbor_xp.hitpoints) / 2
	experience_points = (experience_points + neighbor_xp.experience_points) / 2
	position = (position + neighbor_xp.position) / 2
	neighbor_xp.queue_free()

func _check_neighbor_xp_drops() -> void:
	for area : Area3D in get_overlapping_areas():
		if not (area is ExperienceDrop):
			continue
		var neighbor_xp : ExperienceDrop = area
		if xp_level_index == neighbor_xp.xp_level_index:
			merge_xp_drops(neighbor_xp)
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
	if not (area is ExperienceDrop):
		return
	var neighbor_xp : ExperienceDrop = area
	if xp_level_index == neighbor_xp.xp_level_index:
		merge_xp_drops(area)
