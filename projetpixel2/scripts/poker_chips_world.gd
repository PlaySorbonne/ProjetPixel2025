extends Node3D


const POKER_CHIP_WIDTH := 0.032

@onready var poker_chips_initial_transform : Transform3D = $PokerChip.transform
@onready var poker_chip_objects : Dictionary[PokerChip.ChipValues, Array] = {
	PokerChip.ChipValues.Val_1 : [],
	PokerChip.ChipValues.Val_5 : [],
	PokerChip.ChipValues.Val_25 : [],
	PokerChip.ChipValues.Val_50 : [],
	PokerChip.ChipValues.Val_100 : [],
	PokerChip.ChipValues.Val_500 : [],
	PokerChip.ChipValues.Val_1000 : [],
}
@onready var poker_chip_positions : Dictionary[PokerChip.ChipValues, Vector3] = {
	PokerChip.ChipValues.Val_1 : $PokerChip1Marker.position,
	PokerChip.ChipValues.Val_5 : $PokerChip5Marker.position,
	PokerChip.ChipValues.Val_25 : $PokerChip25Marker.position,
	PokerChip.ChipValues.Val_50 : $PokerChip50Marker.position,
	PokerChip.ChipValues.Val_100 : $PokerChip100Marker.position,
	PokerChip.ChipValues.Val_500 : $PokerChip500Marker.position,
	PokerChip.ChipValues.Val_1000 : $PokerChip1000Marker.position,
}
var poker_chip_tweens : Dictionary[PokerChip.ChipValues, Tween]


func add_chip(chip_value : PokerChip.ChipValues) -> void:
	var new_chip := PokerChip.spawn_poker_chip(
		self, poker_chip_positions[chip_value], chip_value
		)
	var t := create_tween()

func _ready() -> void:
	for val : PokerChip.ChipValues in PokerChip.ChipValues.values():
		poker_chip_tweens[val] = null
	for obj : Node in get_children():
		if obj.is_in_group("chips_to_delete"):
			obj.queue_free()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_m"):
		add_chip(PokerChip.ChipValues.values().pick_random())
