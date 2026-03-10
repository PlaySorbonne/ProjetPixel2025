extends Node3D


@onready var poker_chips_initial_transform : Transform3D = $PokerChip.transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_m"):
		PokerChip.spawn_poker_chip(self, poker_chips_initial_transform, PokerChip.CHIP_VALUES.values().pick_random())
