@tool
extends MeshInstance3D
class_name PokerChip


enum ChipValues{
	Val_1    = 1, 
	Val_5    = 5, 
	Val_25   = 25, 
	Val_50   = 50, 
	Val_100  = 100, 
	Val_500  = 500, 
	Val_1000 = 1000
}

const POKER_CHIP_RES := preload("res://scenes/casino/poker_chip.tscn")

const CHIP_COLOR_OUTSIDE : Dictionary[ChipValues, Color] = {
	PokerChip.ChipValues.Val_1 : Color(0.102, 0.239, 0.655, 1.0),
	PokerChip.ChipValues.Val_5 : Color(1.0, 1.0, 1.0, 1.0),
	PokerChip.ChipValues.Val_25 : Color(1.0, 1.0, 1.0, 1.0),
	PokerChip.ChipValues.Val_50 : Color(1.0, 1.0, 1.0, 1.0),
	PokerChip.ChipValues.Val_100 : Color(1.0, 1.0, 1.0, 1.0),
	PokerChip.ChipValues.Val_500 : Color(0.0, 0.0, 0.0, 1.0),
	PokerChip.ChipValues.Val_1000 : Color(0.887, 0.296, 1.0, 1.0),
}
const CHIP_COLOR_INSIDE : Dictionary[ChipValues, Color] = {
	PokerChip.ChipValues.Val_1 : Color(0.91, 0.91, 0.91, 1.0),
	PokerChip.ChipValues.Val_5 : Color(0.729, 0.165, 0.176, 1.0),
	PokerChip.ChipValues.Val_25 : Color(0.008, 0.612, 0.31, 1.0),
	PokerChip.ChipValues.Val_50 : Color(0.098, 0.243, 0.667, 1.0),
	PokerChip.ChipValues.Val_100 : Color(0.078, 0.078, 0.078, 1.0),
	PokerChip.ChipValues.Val_500 : Color(0.988, 0.659, 0.153, 1.0),
	PokerChip.ChipValues.Val_1000 : Color(10.0, 10.0, 10.0, 1.0),
}
const MAX_FREEZE_TIMER := 1.0

static func spawn_poker_chip(parent : Node, pos : Vector3, nval : ChipValues) -> PokerChip:
	var poker_chip : PokerChip = POKER_CHIP_RES.instantiate()
	poker_chip.ready.connect(poker_chip.add_random_offset)
	poker_chip.chip_value = nval
	poker_chip.position = pos
	parent.add_child(poker_chip)
	return poker_chip

@export var chip_value := ChipValues.Val_1:
	set(value):
		chip_value = value
		_update_chip_material()


func _update_chip_material() -> void:
	if get_surface_override_material(0):
		get_surface_override_material(0).albedo_color = CHIP_COLOR_INSIDE[chip_value]
		get_surface_override_material(1).albedo_color = CHIP_COLOR_OUTSIDE[chip_value]

func _ready() -> void:
	_update_chip_material()

func add_random_offset() -> void:
	position += Vector3(
		randf_range(-0.02, 0.02),
		0.0,
		randf_range(-0.02, 0.02),
	)
	rotation_degrees += Vector3(0.0, randf_range(-60.0, 60.0), 0.0)
