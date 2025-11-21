extends Button
class_name NextWaveButton

signal next_wave_triggered

var wave : WaveManager.EnemyWave
var is_next_wave := false
var is_triggered := false

func set_next_wave(is_next := true) -> void:
	is_next_wave = is_next
	disabled = not is_next

func set_wave(w : WaveManager.EnemyWave) -> void:
	wave = w
	text = "Wave "+str(wave.wave_number)+" ("+str(wave.wave_number_of_enemies)+")"

func remove_button() -> void:
	is_triggered = true
	queue_free()

func trigger_wave() -> void:
	if is_triggered:
		return
	is_triggered = true
	emit_signal("next_wave_triggered")

func _on_pressed() -> void:
	trigger_wave()
