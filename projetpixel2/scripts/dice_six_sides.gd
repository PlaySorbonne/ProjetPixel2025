extends RigidBody3D
class_name Dice


signal dice_rolled(value : int)
signal dice_cocked
signal dice_result(value : int)

const DICE_RES := preload("res://scenes/casino/dice_six_sides.tscn")
const COCKED_LIMIT := 0.95
const FACES : Dictionary[int, Vector3] = {
		1: Vector3.FORWARD,
		6: Vector3.BACK,
		2: Vector3.RIGHT,
		5: Vector3.LEFT,
		3: Vector3.UP,
		4: Vector3.DOWN
	}


static func roll_dice(parent : Node3D, dice_location : Vector3) -> Dice:
	var dice := DICE_RES.instantiate()
	dice.roll_position = dice_location
	dice.ready.connect(dice.roll)
	dice.position = dice_location
	parent.add_child(dice)
	return dice


@export var roll_force := 6.0
@export var roll_torque := 10.0

var roll_position : Vector3
var forced_face := -1
var still_limit := 0.1
var snapping_dice_to_face := false


func _ready() -> void:
	if randi()%4 == 0 or true:
		force_dice_value(6)
	set_physics_process(false)

func _on_timer_timeout() -> void:
	set_physics_process(true)

func _physics_process(delta : float):
	if sleeping:
		return
	if snapping_dice_to_face:
		if is_still(0.1) and is_dice_on_face(forced_face):
			stop_dice()
		else:
			steer_towards_face(delta)
	elif is_still(still_limit):
		if forced_face == -1 or is_dice_on_face(forced_face):
			stop_dice()
		else:
			snapping_dice_to_face = true

func force_dice_value(value : int) -> void:
	if value == -1:
		still_limit = 0.1
	else:
		still_limit = 40.0
	forced_face = value

func stop_dice() -> void:
	sleeping = true
	var value := get_dice_value()
	dice_rolled.emit(value)
	if value == -1:
		roll()
		dice_cocked.emit()
		return
	dice_result.emit(value)
	freeze = true
	scale = Vector3(0.95, 0.95, 0.95)

func roll() -> void:
	# Reset motion
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	
	# Reset transform
	position = roll_position
	rotation = Vector3(
		randf() * TAU,
		randf() * TAU,
		randf() * TAU
	)
	
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

func is_still(limit := 0.1) -> bool:
	return linear_velocity.length_squared() < limit and \
				angular_velocity.length_squared() < limit

func is_dice_on_face(face : int) -> bool:
	var dot := Vector3.UP.dot(global_transform.basis * FACES[face])
	return (dot > COCKED_LIMIT)

func get_dice_value() -> int:
	var best_dot := -1.0
	var best_face := 1
	for face : int in FACES:
		var dot := Vector3.UP.dot(global_transform.basis * FACES[face])
		if dot > best_dot:
			best_dot = dot
			best_face = face
	if best_dot > COCKED_LIMIT:
		return best_face
	else:
		return -1

func steer_towards_face(delta: float) -> void:
	var max_angular_speed := 8.0
	var steer_impulse := 0.025
	var face_dir_world := (global_transform.basis * FACES[forced_face]).normalized()
	var target_dir := Vector3.UP
	var axis := face_dir_world.cross(target_dir)
	var sin_angle := axis.length()
	var cos_angle : float = clamp(face_dir_world.dot(target_dir), -1.0, 1.0)
	var angle := atan2(sin_angle, cos_angle)
	
	if angle < 0.01 and angular_velocity.length() < 0.2:
		sleeping = true
		return
	if sin_angle < 0.0001:
		return
	
	axis /= sin_angle
	apply_torque_impulse(axis * angle * steer_impulse)
	
	if angular_velocity.length() > max_angular_speed:
		angular_velocity = angular_velocity.normalized() * max_angular_speed
