extends CasinoWindow
class_name WarningPopupWindow


const WARNING_POPUP_RES := preload("res://scenes/interface/casino_minigames/warning_popup_window.tscn")

static func spawn_warning_popup(warning_msg : String, popup_lifetime := 4.0) -> void:
	var popup : WarningPopupWindow = WARNING_POPUP_RES.instantiate()
	popup.message = warning_msg
	popup.lifetime = popup_lifetime
	spawn_popup(popup)


var message : String = "Warning Message"
var lifetime := 4.0


func _ready() -> void:
	super._ready()
	$Contents/ColorRectWarning.scale.x = 0.0
	$Contents/ColorRect/LabelMessage.text = message
	$Contents/ColorRect/LabelMessage.visible_ratio = 0.0
	position = random_popup_position()
	open_window()

func _on_window_opened() -> void:
	var t := create_tween().set_parallel()
	t.tween_property($Contents/ColorRectWarning, "scale", Vector2.ONE, 0.2
						).set_ease(Tween.EASE_OUT)
	t.tween_property($Contents/ColorRect/LabelMessage, "visible_ratio", 1.0, 0.4
						).set_delay(0.1)
	t.tween_property($Contents/ColorRect/LabelMessage, "visible_ratio", 0.0, 0.2
						).set_delay(lifetime)
	t.finished.connect(close_window)
