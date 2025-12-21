extends RigidBody3D
class_name Dice


signal dice_rolled(value : float)

const DICE_RES := preload("res://scenes/casino/dice_six_sides.tscn")


static func roll_dice(parent : Node3D, dice_location : Vector3) -> Dice:
	var dice := DICE_RES.instantiate()
	dice.ready.connect(dice.roll)
	dice.position = dice_location
	parent.add_child(dice)
	return dice


@export var roll_force := 6.0
@export var roll_torque := 10.0


func _ready() -> void:
	set_physics_process(false)

func _on_timer_timeout() -> void:
	set_physics_process(true)

func _physics_process(_delta : float):
	if is_still() and sleeping == false:
		sleeping = true
		var value := get_dice_value()
		print("Dice rolled:", value)
		dice_rolled.emit(value)
		freeze = true
		scale = Vector3(0.75, 0.75, 0.75)

func roll() -> void:
	rotation = Vector3(
		randf() * TAU,
		randf() * TAU,
		randf() * TAU
	)
	# Reset motion
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	
	# Random upward + sideways force
	var force := Vector3(
		randf_range(-1, 1),
		-1,
		randf_range(-1, 1)
	).normalized() * roll_force
	
	# Random torque
	var torque := Vector3(
		randf_range(-1, 1),
		randf_range(-1, 1),
		randf_range(-1, 1)
	).normalized() * roll_torque
	
	apply_impulse(force)
	apply_torque_impulse(torque)

func is_still() -> bool:
	return linear_velocity.length() < 0.05 and angular_velocity.length() < 0.05

func get_dice_value() -> int:
	const FACES := {
		1: Vector3.FORWARD,
		6: Vector3.BACK,
		2: Vector3.RIGHT,
		5: Vector3.LEFT,
		3: Vector3.UP,
		4: Vector3.DOWN
	}
	
	var best_dot := -1.0
	var best_face := 1
	print("get dice value")
	for face in FACES:
		var dot := Vector3.UP.dot(global_transform.basis * FACES[face])
		print("   dot["+ str(face) +"] = " + str(dot))
		if dot > best_dot:
			print("       new best dot!")
			best_dot = dot
			best_face = face
	
	return best_face
