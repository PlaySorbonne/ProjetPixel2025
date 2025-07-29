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


@export var experience_points := 100:
	set(value):
		experience_points = value
		_apply_color()


func _apply_color() -> void:
	for xp_level : ExperienceLevel in experience_thresholds:
		if experience_points > xp_level.xp_amount :
			var xp_mat : StandardMaterial3D = $CSGSphere3D.material
			xp_mat.emission = xp_level.xp_color
			return
	print_debug("wtf, negative xp => " + str(experience_points) + "?")
