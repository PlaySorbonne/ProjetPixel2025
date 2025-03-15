extends Control
class_name CreateTowerWindow

signal tower_placed


func _ready() -> void:
	pass

func hide_window() -> void:
	visible = false

func show_window() -> void:
	visible = true

func _on_button_pressed() -> void:
	emit_signal("tower_placed")
