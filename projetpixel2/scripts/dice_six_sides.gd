extends RigidBody3D
class_name Dice


signal dice_rolled(value : float)

@export var roll_force := 6.0
@export var roll_torque := 10.0


func _physics_process(_delta : float):
	if is_still() and sleeping == false:
		sleeping = true
		var value := get_dice_value()
		print("Dice rolled:", value)
		dice_rolled.emit(value)

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
		1,
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
	var up := global_transform.basis * Vector3.UP
	
	var faces := {
		1: Vector3.UP,
		6: Vector3.DOWN,
		2: Vector3.FORWARD,
		5: Vector3.BACK,
		3: Vector3.RIGHT,
		4: Vector3.LEFT
	}

	var best_dot := -1.0
	var best_face := 1
	
	for face in faces:
		var dot := up.dot(global_transform.basis * faces[face])
		if dot > best_dot:
			best_dot = dot
			best_face = face
	
	return best_face
