extends Button
class_name NextWaveButton

signal next_wave_triggered

var wave : WaveManager.EnemyWave
var is_next_wave := false
var is_triggered := false

func set_next_wave(is_next := true) -> void:
	is_next_wave = is_next
	disabled = not is_next
	$AnimationPlayer.play("set_current_wave")

func set_wave(w : WaveManager.EnemyWave) -> void:
	wave = w
	$LabelWaveNum.text = str(wave.wave_number)
	$TextureCircle/LabelWaveNum2.text = $LabelWaveNum.text
	$VBoxContainer/LabelThreat.text = "Threat level: " + str(wave.wave_difficulty)
	$VBoxContainer/LabelNumberOfEnemies.text = str(wave.wave_number_of_enemies) + " hostiles"
	var enemy_names : String = ""
	for enemy : BaseEnemy in wave.wave_enemies:
		if enemy_names != "":
			enemy_names += ", "
		enemy_names += enemy.enemy_data.enemy_type
	$LabelEnemies.text = enemy_names

func remove_button() -> void:
	is_triggered = true
	$AnimationPlayer.play("remove_button")
	await $AnimationPlayer.animation_finished
	queue_free()

func trigger_wave() -> void:
	if is_triggered:
		return
	is_triggered = true
	emit_signal("next_wave_triggered")

func _on_pressed() -> void:
	trigger_wave()
