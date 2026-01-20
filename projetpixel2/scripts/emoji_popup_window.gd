extends CasinoWindow
class_name EmojiPopupWindow


const EMOJI_POPUP_RES := preload("res://scenes/interface/casino_minigames/emoji_popup_window.tscn")

static func spawn_message_popup(message_txt : String, popup_lifetime := 4.0) -> void:
	var popup : MessagePopupWindow = EMOJI_POPUP_RES.instantiate()
	popup.message = message_txt
	popup.lifetime = popup_lifetime
	spawn_popup(popup)


func _ready() -> void:
	super._ready()

func _on_window_opened() -> void:
	pass

func _on_timer_timeout() -> void:
	pass # Replace with function body.
