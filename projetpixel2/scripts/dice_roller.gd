extends Node3D
class_name DiceRoller


signal dice_result(result : int)

var total_dice_result : int
var rolled_dice : Array[Dice] = []
var nb_dice_thrown : int
var nb_dice_rolled : int


#func _input(event):
	#if event.is_action_pressed("ui_accept"):
		#roll_dice(24)

func roll_dice(number_of_dice : int) -> void:
	cleanup_dice()
	nb_dice_thrown = number_of_dice
	nb_dice_rolled = 0
	for _i : int in range(number_of_dice):
		var dice := Dice.roll_dice(self, random_dice_spawn_position())
		connect_dice(dice)

func random_dice_spawn_position() -> Vector3:
	return $Marker3D.position + Vector3(
		randf_range(-$Marker3D.gizmo_extents, $Marker3D.gizmo_extents),
		0.0,
		randf_range(-$Marker3D.gizmo_extents, $Marker3D.gizmo_extents)
	)

func cleanup_dice() -> void:
	for d : Dice in rolled_dice:
		if is_instance_valid(d):
			d.queue_free()
	rolled_dice.clear()
	total_dice_result = 0

func connect_dice(dice : Dice) -> void:
	dice.dice_result.connect(_on_dice_rolled.bind(dice))
	dice.dice_cocked.connect(_on_dice_cocked)
	rolled_dice.append(dice)

func add_debug_line(new_line : String) -> void:
	#$CanvasLayer/Label.text += new_line + "\n"
	pass

func _on_dice_cocked(new_dice : Dice) -> void:
	add_debug_line("cocked -> spawn new dice")
	connect_dice(new_dice)

func _on_dice_rolled(result : int, dice : Dice) -> void:
	total_dice_result += result
	nb_dice_rolled += 1
	if nb_dice_rolled == nb_dice_thrown:
		dice_result.emit(total_dice_result)
		#$CanvasLayer/Label.text += "total_dice_result = " + str(total_dice_result) + "\n"
