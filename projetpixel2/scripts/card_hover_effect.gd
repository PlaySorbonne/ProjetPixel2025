extends Node

@export var normal : Marker2D
@export var enabled : bool = true
@export var chip : Sprite2D 
@export var suit : Sprite2D 

var TIME := 0
var value := 2000
var mousepos := Vector2(0,0)
var blaa := 0
var veldir := Vector2(0,0)
var oldpos := Vector2(0,0)
var veldir2 := Vector2(0,0)
var oldpos2 := Vector2(0,0)
var is_mouse_over := false
var is_grabbed := false
var mouse_grab_offset : Vector2

@onready var card_object : CardObject = get_parent()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and enabled:
		mousepos = event.position - (Vector2(140,186)/2)
		veldir = clamp(event.velocity/4000,Vector2(-0.3,-0.3),Vector2(0.3,0.3))

func _process(delta: float) -> void:
	TIME += delta
	if enabled:
		process_shader_effect()
		process_card_movement()

func process_card_movement() -> void:
	if is_grabbed:
		card_object.global_position = card_object.get_global_mouse_position() - mouse_grab_offset
	else:
		pass

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

func _on_card_object_button_up() -> void:
	is_grabbed = false
