extends Node

@export var normal : Marker2D
@export var enabled : bool = true
@export var chip : Sprite2D 
@export var suit : Sprite2D 

var TIME := 0
var value := 2000
var blaa := 0
var is_mouse_over := false
var is_grabbed := false
var mouse_grab_offset : Vector2
var time_since_movement_start := 0.0
var at_rest := true

var movement_start_pos : Vector2

var follow_speed := 20.0
var max_rotation: float = 0.15  
var rotation_return_speed: float = 5.0  
var last_position := Vector2.ZERO  

@onready var card_object : CardObject = get_parent()
@onready var initial_position : Vector2 = card_object.global_position
@onready var original_rotation := card_object.rotation


func _process(delta: float) -> void:
	TIME += delta
	if enabled:
		process_shader_effect()
		process_card_movement(delta)

func process_card_movement(delta : float) -> void:
	var target_pos = card_object.get_global_mouse_position()
	if is_grabbed:
		target_pos = card_object.get_global_mouse_position() - mouse_grab_offset
	else:
		target_pos = initial_position
	
	# position
	card_object.global_position = lerp(
		card_object.global_position,
		target_pos,
		follow_speed * delta
	)
	
	
	# rotation
	# Calculate velocity based on position difference
	var velocity = card_object.global_position - last_position
	last_position = card_object.global_position  # Update for next frame

	var speed_factor = min(velocity.length() / 10.0, 10.0) # Normalize speed [0,1]
	var target_rotation = max(-1.57, min(velocity.x * max_rotation, 1.57))  # Tilt based on horizontal movement

	target_rotation = (target_pos - last_position).angle() * -1.0
	chip.rotation = target_rotation
	#chip.rotation = lerp(
		#chip.rotation,
		#target_rotation * speed_factor,  # Blend tilt based on speed
		#rotation_return_speed * delta
	#)
	

func process_old(delta : float) -> void:
	if at_rest:
		return
	var target_position : Vector2
	if is_grabbed:
		target_position = card_object.get_global_mouse_position() - mouse_grab_offset
	else:
		target_position = initial_position
	# move
	card_object.global_position = lerp(
		card_object.global_position,
		target_position,
		follow_speed * delta
	)
	# rotate
	#var direction = (target_position - card_object.global_position).normalized()
	#var target_rotation = direction.angle()
	
	
	#var direction = (target_position - card_object.global_position)
	#if direction.length() > rotation_threshold:
		#var target_rotation = direction.angle()
		#card_object.rotation = lerp_angle(
			#card_object.rotation, 
			#target_rotation, 
			#rotation_speed * delta)

func process_shader_effect() -> void:
	var material := chip.material
	if is_mouse_over and enabled:
		if material:
			blaa = 1
			card_object.scale = lerp(card_object.scale,Vector2(1.05,1.05),0.25)
			material.set_shader_parameter("hovering", 1)
			material.set_shader_parameter(
				"mouse_screen_pos", 
				Vector2(
					clampf((card_object.get_global_mouse_position()-(card_object.position+card_object.size/2)).x*2,-value,value),
					clampf((card_object.get_global_mouse_position()-(card_object.position+card_object.size/2)).y*2,-value,value)))
	else:
		if material:
			card_object.scale = lerp(card_object.scale,Vector2(1,1),0.25)
			material.set_shader_parameter("hovering", 0)
			blaa = 0
	suit.material = material

func start_movement() -> void:
	time_since_movement_start = 0.0
	at_rest = false
	movement_start_pos = card_object.global_position

# card_object signals processing 
func _on_card_object_mouse_entered() -> void:
	is_mouse_over = true

func _on_card_object_mouse_exited() -> void:
	is_mouse_over = false

func _on_card_object_button_down() -> void:
	mouse_grab_offset = card_object.get_global_mouse_position() - card_object.global_position
	is_grabbed = true
	start_movement()

func _on_card_object_button_up() -> void:
	is_grabbed = false
	start_movement()
