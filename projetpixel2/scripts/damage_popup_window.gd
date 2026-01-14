extends CasinoTextWindow
class_name WarningPopupWindow


const WARNING_POPUP_RES := preload("res://scenes/interface/casino_minigames/warning_popup_window.tscn")

static func spawn_warning_popup(warning_msg : String, popup_lifetime := 4.0) -> void:
	var popup : WarningPopupWindow = WARNING_POPUP_RES.instantiate()
	popup.message = warning_msg
	popup.lifetime = popup_lifetime
	spawn_popup(popup)


func _ready() -> void:
	super._ready()
	init_text_popup($Contents/ColorRect/LabelMessage, $Contents/ColorRectWarning)
	position = random_popup_position()
	open_window()

func _on_window_opened() -> void:
	animate_text_popup()
