extends CasinoWindow
class_name WarningPopupWindow


const WARNING_POPUP_RES := preload("res://scenes/interface/casino_minigames/warning_popup_window.tscn")

static func spawn_warning_popup(warning_msg : String) -> void:
	var popup : WarningPopupWindow = WARNING_POPUP_RES.instantiate()
	popup
	spawn_popup(popup)


func _ready() -> void:
	super._ready()
	random_popup_position()

func _on_window_opened() -> void:
	pass # Replace with function body.
