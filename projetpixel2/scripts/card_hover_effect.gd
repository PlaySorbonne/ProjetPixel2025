extends Node

const ROTATION_LIMIT := 50.0
const FOLLOW_SPEED := 20.0
const ROTATION_RETURN_SPEED: float = 10.0

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
var at_rest := true
var last_position := Vector2.ZERO

@onready var card_object : CardObject = get_parent()
@onready var initial_position : Vector2 = card_object.global_position
@onready var initial_rotation := card_object.rotation


func _process(delta: float) -> void:
	TIME += delta
	if enabled:
		process_shader_effect()
		process_card_movement(delta)

func process_card_movement(delta : float) -> void:
	if at_rest:
		return
	var target_pos = card_object.get_global_mouse_position()
	if is_grabbed:
		target_pos = card_object.get_global_mouse_position() - mouse_grab_offset
	else:
		target_pos = initial_position
	
	# position
	card_object.global_position = lerp(
		card_object.global_position,
		target_pos,
		FOLLOW_SPEED * delta
	)
	
	# rotation
	var velocity = target_pos - last_position
	last_position = card_object.global_position
	var target_rotation = max(min( (velocity.x) * velocity.length() / 1000.0,
				ROTATION_LIMIT ), -ROTATION_LIMIT )
	chip.rotation_degrees = lerp(
		chip.rotation_degrees,
		target_rotation,
		ROTATION_RETURN_SPEED * delta
	)
	# reset
	if not is_grabbed:
		if abs(chip.rotation - initial_rotation) < 0.005 and (card_object.global_position
								).distance_squared_to(initial_position) < 10.0:
			at_rest = true

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

# card_object signals processing 
func _on_card_object_mouse_entered() -> void:
	is_mouse_over = true

func _on_card_object_mouse_exited() -> void:
	is_mouse_over = false

func _on_card_object_button_down() -> void:
	mouse_grab_offset = card_object.get_global_mouse_position() - card_object.global_position
	is_grabbed = true
	at_rest = false

func _on_card_object_button_up() -> void:
	is_grabbed = false
