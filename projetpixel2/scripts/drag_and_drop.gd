extends Node
class_name DragAndDrop

signal dragged
signal dropped

const CLICK_MAX_TIME := 0.2

@export var can_be_dragged := true

# handles both
# (1)pressing mouse button and dragging and 
# (2)clicking, then moving, then clicking again
var is_dragged := false
var was_just_pressed := false
var is_pressed := false:
	set(value):
		#print("set pressed to ", value)
		is_pressed = value
		if is_pressed:
			if is_dragged:
				return
			drag()
			was_just_pressed = true
			var timer : SceneTreeTimer = get_tree().create_timer(CLICK_MAX_TIME)
			timer.connect("timeout", reset_just_pressed)
		else:
			if is_dragged and (not was_just_pressed):
				drop()

func press() -> void:
	is_pressed = true

func release() -> void:
	is_pressed = false

func reset_just_pressed() -> void:
	was_just_pressed = false

func drag() -> void:
	is_dragged = true
	emit_signal("dragged")

func drop() -> void:
	is_dragged = false
	emit_signal("dropped")
