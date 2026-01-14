extends CasinoWindow
class_name MessagePopupWindow


const MESSAGE_POPUP_RES := preload("res://scenes/interface/casino_minigames/message_popup_window.tscn")

static func spawn_message_popup(message_txt : String, popup_lifetime := 4.0) -> void:
	var popup : MessagePopupWindow = MESSAGE_POPUP_RES.instantiate()
	popup.message = message_txt
	popup.lifetime = popup_lifetime
	spawn_popup(popup)


var message : String = "Informational Message"
var lifetime := 4.0


func _ready() -> void:
	super._ready()
	$Contents/ColorRectMessage.scale.x = 0.0
	$Contents/ColorRect/LabelMessage.text = message
	$Contents/ColorRect/LabelMessage.visible_ratio = 0.0
	position = random_popup_position()
	open_window()

func _on_window_opened() -> void:
	var t := create_tween().set_parallel()
	t.tween_property($Contents/ColorRectMessage, "scale", Vector2.ONE, 0.2
						).set_ease(Tween.EASE_OUT)
	t.tween_property($Contents/ColorRect/LabelMessage, "visible_ratio", 1.0, 0.4
						).set_delay(0.1)
	t.tween_property($Contents/ColorRect/LabelMessage, "visible_ratio", 0.0, 0.2
						).set_delay(lifetime)
	t.finished.connect(close_window)
