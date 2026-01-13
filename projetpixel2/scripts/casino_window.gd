extends Control
class_name CasinoWindow


const SIZE_ANIM_TIME := 0.175
const MIN_Y_SIZE := 60.0

var size_tween : Tween

@onready var default_size := size


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_right"):
		visible = false
		open_window()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			$DragAndDrop2D.press()
		else:
			$DragAndDrop2D.release()

func _init_size_tween() -> void:
	if is_instance_valid(size_tween):
		size_tween.kill()
	size_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(
			Tween.TRANS_CUBIC).set_parallel()

func open_window() -> void:
	_init_size_tween()
	$CloseButton.modulate = Color.TRANSPARENT
	pivot_offset = default_size / 2.0
	size = Vector2(0.0, MIN_Y_SIZE)
	# horizontal
	size_tween.tween_property(self, "size", Vector2(default_size.x, MIN_Y_SIZE), 
			SIZE_ANIM_TIME)
	var next_window_pos := position - Vector2(default_size.x/2.0, 0.0)
	size_tween.tween_property(self, "position", next_window_pos, SIZE_ANIM_TIME)
	# vertical
	size_tween.tween_property(self, "size", default_size, SIZE_ANIM_TIME
			).set_delay(SIZE_ANIM_TIME)
	size_tween.tween_property(self, "position", next_window_pos -
			Vector2(0.0, default_size.y/2.0), SIZE_ANIM_TIME).set_delay(SIZE_ANIM_TIME)
	size_tween.tween_property($CloseButton, "modulate", Color.WHITE, SIZE_ANIM_TIME)
	visible = true

func close_window() -> void:
	_init_size_tween()
	pivot_offset = default_size / 2.0
	# vertical
	size_tween.tween_property(self, "size", Vector2(default_size.x, MIN_Y_SIZE), 
			SIZE_ANIM_TIME)
	var next_window_pos := position + Vector2(0.0, default_size.y/2.0)
	size_tween.tween_property(self, "position", next_window_pos, SIZE_ANIM_TIME)
	# horizontal
	size_tween.tween_property(self, "size", Vector2(0.0, MIN_Y_SIZE), SIZE_ANIM_TIME
			).set_delay(SIZE_ANIM_TIME)
	size_tween.tween_property(self, "position", next_window_pos +
			Vector2(default_size.x/2.0, 0.0), SIZE_ANIM_TIME).set_delay(SIZE_ANIM_TIME)
	size_tween.tween_property($CloseButton, "modulate", Color.TRANSPARENT, SIZE_ANIM_TIME)
	size_tween.finished.connect(_finish_closing_window)

func _finish_closing_window() -> void:
	queue_free()

func _on_close_button_pressed() -> void:
	close_window()
