extends Control
class_name NextWaveButton

signal next_wave_triggered

var is_triggered := false

func trigger_wave() -> void:
	if is_triggered:
		return
	is_triggered = true
	emit_signal("next_wave_triggered")
	queue_free()


func _on_button_pressed() -> void:
	trigger_wave()
