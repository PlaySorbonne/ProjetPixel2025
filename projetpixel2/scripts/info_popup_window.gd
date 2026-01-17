extends CasinoTextWindow
class_name MessagePopupWindow


const MESSAGE_POPUP_RES := preload("res://scenes/interface/casino_minigames/message_popup_window.tscn")

static func spawn_message_popup(message_txt : String, popup_lifetime := 4.0) -> void:
	var popup : MessagePopupWindow = MESSAGE_POPUP_RES.instantiate()
	popup.message = message_txt
	popup.lifetime = popup_lifetime
	spawn_popup(popup)


func _ready() -> void:
	super._ready()
	init_text_popup($Contents/ColorRect/LabelMessage, $Contents/ColorRectMessage)

func _on_window_opened() -> void:
	animate_text_popup()
