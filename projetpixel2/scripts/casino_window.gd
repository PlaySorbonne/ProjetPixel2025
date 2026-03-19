extends Control
class_name CasinoWindow


signal window_opened
signal window_closed

const SIZE_ANIM_TIME := 0.175
const MIN_Y_SIZE := 60.0

var size_tween : Tween
var closed := false
var close_button_tween : Tween

@export var can_drag_window := true
@export var can_close_window := true
@export var anim_speed : float = 1.0
#@export var can_close_window := true:
	#set(value):
		#can_close_window = value
		#$Contents/CloseButton.visible = value

@onready var default_size := size
@onready var background_material : ShaderMaterial = $Panel/Background.material

const BACKGROUND_SHADER_PARAMS : Array[String] =  [
	"scroll_speed", "repeat_x", "repeat_y", "glitch_chance",
	"glitch_speed", "slice_density", "slice_strength", "shake_strength", 
	"chroma_offset", "noise_strength", "color_flash_strength", "scanline_strength",
	"local_warp_strength", "flip_chance"
]

static func spawn_popup(popup : CasinoWindow) -> CasinoWindow:
	popup.visible = false
	GV.hud.add_child(popup)
	return popup


func _ready() -> void:
	randomize_panel_background_parameters()
	if not can_close_window:
		$Contents/CloseButton.visible = false

static func random_popup_position() -> Vector2:
	var pos_rect := GV.hud.game_panel.size * 0.9
	const POSITION_MAX_OFFSET := 15.0
	# GV.hud.game_panel.position is popup min_pos (top left)
	return GV.hud.game_panel.position + Vector2(
		pos_rect.x * randf() + randf_range(-POSITION_MAX_OFFSET, POSITION_MAX_OFFSET),
		pos_rect.y * randf() + randf_range(-POSITION_MAX_OFFSET, POSITION_MAX_OFFSET)
	)

func get_mouse_position() -> Vector2:
	var offset := default_size / 2.0 + Vector2(10, 0.0)
	var mouse_pos := GV.hud.game_panel.get_global_mouse_position()
	var screen_height : float = get_viewport().size.y
	#print("screen_height = " + str(screen_height))
	#print("mouse_pos.y = " + str(mouse_pos.y))
	if mouse_pos.y > screen_height / 2:
		offset.y *= -1.0
	offset.y += 52.5
	return mouse_pos + offset

func randomize_panel_background_parameters() -> void:
	for param_str : String in BACKGROUND_SHADER_PARAMS:
		var param_value : float = background_material.get_shader_parameter(param_str)
		var param_randomness := param_value / 8.0
		background_material.set_shader_parameter(
			param_str,
			param_value + randf_range(-param_randomness, param_randomness)
		)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and can_drag_window:
		var parent : Node = get_parent()
		parent.move_child(self, parent.get_child_count() - 1)
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
	$Contents.modulate = Color.TRANSPARENT
	size = Vector2(0.0, MIN_Y_SIZE)
	pivot_offset = Vector2(default_size.x, MIN_Y_SIZE) / 2.0
	scale = Vector2(1.0, 0.25)
	var true_anim_time : float = SIZE_ANIM_TIME / anim_speed
	# horizontal
	size_tween.tween_property(self, "size", Vector2(default_size.x, MIN_Y_SIZE), 
			true_anim_time)
	size_tween.tween_property(self, "scale", Vector2.ONE, true_anim_time)
	var next_window_pos := position - Vector2(default_size.x/2.0, 0.0)
	size_tween.tween_property(self, "position", next_window_pos, true_anim_time)
	# vertical
	size_tween.tween_property(self, "size", default_size, true_anim_time
			).set_delay(true_anim_time)
	size_tween.tween_property(self, "position", next_window_pos -
			Vector2(0.0, default_size.y/2.0), true_anim_time).set_delay(true_anim_time)
	size_tween.tween_property($Contents, "modulate", Color.WHITE, true_anim_time
			).set_delay(true_anim_time)
	visible = true
	size_tween.finished.connect(emit_signal.bind("window_opened"))

func close_window(force_close := false) -> void:
	if closed or (not can_close_window and not force_close):
		return
	closed = true
	_init_size_tween()
	$DragAndDrop2D.can_be_dragged = false
	pivot_offset = Vector2(0.0, MIN_Y_SIZE/2.0)
	var true_anim_time : float = SIZE_ANIM_TIME / anim_speed
	# vertical
	size_tween.tween_property($Contents, "modulate", Color.TRANSPARENT, true_anim_time/2.0)
	size_tween.tween_property(self, "size", Vector2(default_size.x, MIN_Y_SIZE), 
			true_anim_time)
	var next_window_pos := position + Vector2(0.0, default_size.y/2.0)
	size_tween.tween_property(self, "position", next_window_pos, true_anim_time)
	# horizontal
	size_tween.tween_property(self, "size", Vector2(0.0, MIN_Y_SIZE), true_anim_time
			).set_delay(true_anim_time)
	size_tween.tween_property(self, "position", next_window_pos +
			Vector2(default_size.x/2.0, 0.0), true_anim_time).set_delay(true_anim_time)
	size_tween.tween_property(self, "scale", Vector2(1.0, 0.25), true_anim_time).set_delay(SIZE_ANIM_TIME)
	size_tween.finished.connect(_destroy_window)

func _destroy_window() -> void:
	window_closed.emit()
	queue_free()

func _on_close_button_pressed() -> void:
	close_window()

func _setup_close_button_tween() -> void:
	if close_button_tween:
		close_button_tween.kill()
	close_button_tween = create_tween().set_trans(Tween.TRANS_CUBIC)

func _on_close_button_mouse_entered() -> void:
	if closed:
		return
	_setup_close_button_tween()
	close_button_tween.tween_property($Contents/CloseButton, "scale", 
											Vector2(1.2, 1.2), 0.15)

func _on_close_button_mouse_exited() -> void:
	if closed:
		return
	_setup_close_button_tween()
	close_button_tween.tween_property($Contents/CloseButton, "scale", Vector2.ONE, 0.15)
