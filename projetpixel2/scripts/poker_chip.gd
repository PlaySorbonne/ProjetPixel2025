@tool
extends RigidBody3D
class_name PokerChip


enum CHIP_VALUES{Val_1, Val_5, Val_25, Val_50, Val_100, Val_500, Val_1000}

const CHIP_COLOR_OUTSIDE : Array[Color] = [
	Color(0.102, 0.239, 0.655, 1.0),
	Color(1.0, 1.0, 1.0, 1.0),
	Color(1.0, 1.0, 1.0, 1.0),
	Color(1.0, 1.0, 1.0, 1.0),
	Color(1.0, 1.0, 1.0, 1.0),
	Color(0.0, 0.0, 0.0, 1.0),
	Color(0.282, 0.16, 0.413, 1.0),
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

@export var chip_value := CHIP_VALUES.Val_1:
	set(value):
		chip_value = value
		$Chip.get_surface_override_material(0).albedo_color = CHIP_COLOR_INSIDE[value]
		$Chip.get_surface_override_material(1).albedo_color = CHIP_COLOR_OUTSIDE[value]
