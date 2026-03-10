extends RigidBody3D
class_name PokerChip


enum CHIP_VALUES{Val_1, Val_5, Val_25, Val_50, Val_100, Val_500, Val_1000}

const POKER_CHIP_RES := preload("res://scenes/casino/poker_chip.tscn")

const CHIP_COLOR_OUTSIDE : Array[Color] = [
	Color(0.102, 0.239, 0.655, 1.0),
	Color(1.0, 1.0, 1.0, 1.0),
	Color(1.0, 1.0, 1.0, 1.0),
	Color(1.0, 1.0, 1.0, 1.0),
	Color(1.0, 1.0, 1.0, 1.0),
	Color(0.0, 0.0, 0.0, 1.0),
	Color(0.0, 0.0, 0.0, 1.0),
]
const CHIP_COLOR_INSIDE : Array[Color] = [
	Color(0.91, 0.91, 0.91, 1.0),
	Color(0.729, 0.165, 0.176, 1.0),
	Color(0.008, 0.612, 0.31, 1.0),
	Color(0.098, 0.243, 0.667, 1.0),
	Color(0.078, 0.078, 0.078, 1.0),
	Color(0.988, 0.659, 0.153, 1.0),
	Color(0.0, 0.0, 0.0, 1.0),
]

const MAX_FREEZE_TIMER := 1.0

static func spawn_poker_chip(parent : Node, ntransform : Transform3D, nval : CHIP_VALUES) -> PokerChip:
	var poker_chip : PokerChip = POKER_CHIP_RES.instantiate()
	poker_chip.chip_value = nval
	poker_chip.transform = ntransform
	parent.add_child(poker_chip)
	return poker_chip

@export var chip_value := CHIP_VALUES.Val_1:
	set(value):
		chip_value = value
		_update_chip_material()

var freeze_timer := MAX_FREEZE_TIMER

func _update_chip_material() -> void:
	if $Chip:
		$Chip.get_surface_override_material(0).albedo_color = CHIP_COLOR_INSIDE[chip_value]
		$Chip.get_surface_override_material(1).albedo_color = CHIP_COLOR_OUTSIDE[chip_value]

func _ready() -> void:
	apply_torque_impulse(Vector3(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized() * 1.0)
	chip_value = chip_value
	_update_chip_material()

func _process(delta: float) -> void:
	if angular_velocity.length_squared() <= 0.1 and \
		linear_velocity.length_squared() <= 0.1:
		freeze_timer -= delta
		if freeze_timer <= 0.0:
			freeze = true
			set_process(false)
	else:
		freeze_timer = MAX_FREEZE_TIMER
