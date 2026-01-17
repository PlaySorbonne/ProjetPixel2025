extends CasinoWindow
class_name CasinoTextWindow


@export var lifetime : float = 4.0
@export var message : String = "Generic Message"
@export var forced_position := false

var text_label : Label
var title_node : Control


func _ready() -> void:
	super._ready()
	await get_tree().process_frame
	if not forced_position:
		position = random_popup_position()
	open_window()

func force_popup_position(popup_pos : Vector2) -> void:
	position = popup_pos
	forced_position = true

func init_text_popup(ntext_label : Label, ntitle_node : Control) -> void:
	text_label = ntext_label
	title_node = ntitle_node
	title_node.scale.x = 0.0
	text_label.text = message
	text_label.visible_ratio = 0.0

func animate_text_popup() -> void:
	var t := create_tween().set_parallel()
	t.tween_property(title_node, "scale", Vector2.ONE, 0.3
						).set_ease(Tween.EASE_OUT)
	t.tween_property(text_label, "visible_ratio", 1.0, 0.2
						).set_delay(0.1)
	if lifetime >= 0.0:
		t.tween_property(text_label, "visible_ratio", 0.0, 0.2
							).set_delay(lifetime)
		t.finished.connect(close_window)
