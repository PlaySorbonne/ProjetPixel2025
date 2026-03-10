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
@onready var init_chip_height : float = $PokerChip1Marker.position.y

var poker_chip_tweens : Dictionary[PokerChip.ChipValues, Tween]


func add_chip(chip_value : PokerChip.ChipValues) -> void:
	if poker_chip_tweens[chip_value]:
		poker_chip_tweens[chip_value].kill()
	var new_chip := PokerChip.spawn_poker_chip(
		self, 
		poker_chip_positions[chip_value] - Vector3(0.0, 0.3, 0.0),
		chip_value
	)
	var t := create_tween().set_ease(Tween.EASE_OUT).set_parallel()
	for chip_index : int in poker_chip_objects[chip_value].size():
		var current_pos : Vector3 = poker_chip_objects[chip_value][chip_index].position
		t.tween_property(
			poker_chip_objects[chip_value][chip_index],
			"position",
			Vector3(
				current_pos.x, 
				(1+chip_index)*POKER_CHIP_WIDTH + init_chip_height, 
				current_pos.z
				),
			0.15
		)
	t.tween_property(
		new_chip, 
		"position", 
		poker_chip_positions[chip_value], 
		0.15
	)
	poker_chip_tweens[chip_value] = t
	poker_chip_objects[chip_value].insert(0, new_chip)

func _ready() -> void:
	for val : PokerChip.ChipValues in PokerChip.ChipValues.values():
		poker_chip_tweens[val] = null
	for obj : Node in get_children():
		if obj.is_in_group("chips_to_delete"):
			obj.queue_free()

func add_random_chip() -> void:
	add_chip(PokerChip.ChipValues.values().pick_random())

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_m"):
		add_random_chip()
