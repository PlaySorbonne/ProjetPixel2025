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
var descending_chip_values : Array = []
var ascending_chip_values : Array = []


func _ready() -> void:
	_set_ordered_poker_chips_values()
	for val : PokerChip.ChipValues in PokerChip.ChipValues.values():
		poker_chip_tweens[val] = null
	for obj : Node in get_children():
		if obj.is_in_group("chips_to_delete"):
			obj.queue_free()
	RunData.chips_gained.connect(_update_chips)

func _set_ordered_poker_chips_values() -> void:
	descending_chip_values = PokerChip.ChipValues.values()
	descending_chip_values.sort_custom(sort_descending)
	ascending_chip_values = PokerChip.ChipValues.values()
	ascending_chip_values.sort()

func sort_descending(a : int, b : int):
	return a > b

func get_all_number_of_chips() -> Dictionary:
	var n_dict : Dictionary
	for k : int in ascending_chip_values:
		n_dict[k] = get_number_of_chips(k)
	return n_dict

func _update_chips(chips_gained : int) -> void:
	#print("_update_chips -> " + str(chips_gained) + " ; new money = " + str(RunData.current_chips))
	#print("chips = " + str(get_all_number_of_chips()))
	if chips_gained == 0:
		return
	if chips_gained > 0:
		gain_chips(chips_gained)
	else:
		lose_chips(abs(chips_gained))

func gain_chips(money_gained : int) -> void:
	#print("  gain %s chips" %str(money_gained))
	var chips_to_change : Dictionary[int, int] = money_to_chips(abs(money_gained))
	for chip_val : int in chips_to_change.keys():
			for _i in range(chips_to_change[chip_val]):
				#print("    gain " + str(chip_val))
				add_chip(chip_val)
	check_chip_stacks_height()

func check_chip_stacks_height() -> void:
	for chip_val : int in ascending_chip_values:
		if get_number_of_chips(chip_val) > 30:
			for _i in range(15):
				remove_chip(chip_val)
			gain_chips(15 * chip_val)

func lose_chips(money_lost : int) -> void:
	#print("  lose %s chips" %str(money_lost))
	for chip_val : int in descending_chip_values:
		while money_lost >= chip_val and get_number_of_chips(chip_val) > 0:
			remove_chip(chip_val)
			#print("    lose " + str(chip_val))
			money_lost -= chip_val
			if money_lost == 0:
				return
	if money_lost > 0:
		make_change(money_lost)

func make_change(target_value : int) -> void:
	#print("    make change for " + str(target_value))
	for chip_val : int in ascending_chip_values:
		if chip_val >= target_value and get_number_of_chips(chip_val) > 0:
			target_value -= chip_val
			#print("       change remove " + str(chip_val))
			remove_chip(chip_val)
			if target_value < 0:
				#print("       change add " + str(abs(target_value)))
				gain_chips(abs(target_value))
				return

func money_to_chips(amount : int) -> Dictionary[int, int]:
	var chips : Dictionary[int, int] = {}
	for val : int in descending_chip_values:
		@warning_ignore("integer_division")
		var count := amount / val
		if count > 0:
			chips[val] = count
			amount -= count * val
	return chips

func _update_chip_tween(chip_value : PokerChip.ChipValues) -> Tween:
	if poker_chip_tweens[chip_value]:
		poker_chip_tweens[chip_value].kill()
	return create_tween().set_ease(Tween.EASE_OUT).set_parallel()

func add_chip(chip_value : PokerChip.ChipValues) -> void:
	var new_chip := PokerChip.spawn_poker_chip(
		self, 
		poker_chip_positions[chip_value] - Vector3(0.0, 0.3, 0.0),
		chip_value
	)
	var t := _update_chip_tween(chip_value)
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

func remove_chip(chip_value : PokerChip.ChipValues) -> bool:
	var nb_chips := get_number_of_chips(chip_value)
	if nb_chips == 0:
		return false
	var removed_chip : PokerChip = poker_chip_objects[chip_value][nb_chips-1]
	var t : Tween = create_tween().set_ease(Tween.EASE_OUT).set_parallel()
	t.tween_property(
		removed_chip, 
		"position", 
		removed_chip.position+Vector3(0.0, 0.5, 0.0), 
		0.3
	)
	t.tween_property(
		removed_chip,
		"global_rotation",
		removed_chip.global_rotation + Vector3(0.0, 0.0, 9.5),
		0.3
	)
	t.tween_property(
		removed_chip,
		"scale",
		Vector3.ZERO,
		0.1
	).set_delay(0.2)
	t.finished.connect(removed_chip.queue_free)
	poker_chip_objects[chip_value].resize(nb_chips-1)
	return true

func get_number_of_chips(value : PokerChip.ChipValues) -> int:
	return len(poker_chip_objects[value])

func remove_random_chip() -> bool:
	return remove_chip(PokerChip.ChipValues.values().pick_random())

func add_random_chip() -> void:
	add_chip(PokerChip.ChipValues.values().pick_random())

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_p"):
		RunData.current_chips += 1000
	if Input.is_action_just_pressed("debug_m"):
		RunData.current_chips += randi_range(1, 32)
	if Input.is_action_just_pressed("debug_l"):
		RunData.current_chips -= randi_range(1, 32)
