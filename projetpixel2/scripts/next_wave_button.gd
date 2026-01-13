extends Button
class_name NextWaveButton

signal next_wave_triggered

const TRIANGLE_BLACK := preload("res://resources/images/casino/ui_waves/backgammon_triangle_black.png")
const TRIANGLE_RED := preload("res://resources/images/casino/ui_waves/backgammon_triangle_red.png")
const TRIANGLE_END_BLACK := preload("res://resources/images/casino/ui_waves/triangle_black_end.png")
const TRIANGLE_END_RED := preload("res://resources/images/casino/ui_waves/triangle_red_end.png")
const WAVE_ENEMY_CHIP := preload("res://scenes/interface/gameplay_hud/wave_enemy_chip.tscn")


var wave : WaveManager.EnemyWave
var is_next_wave := false
var is_triggered := false

func set_next_wave(is_next := true) -> void:
	is_next_wave = is_next
	disabled = not is_next
	$AnimationPlayer.play("set_current_wave")

func set_wave(w : WaveManager.EnemyWave) -> void:
	wave = w
	if wave.wave_number%2 == 0:
		$Triangle.texture = TRIANGLE_BLACK
		$Triangle/TextureRect.texture = TRIANGLE_END_BLACK
	else:
		$Triangle.texture = TRIANGLE_RED
	$LabelWaveNum.text = str(wave.wave_number)
	# add chips for enemy types (TODO)
	for _i in range(randi_range(1, 4)):
		var chip := WAVE_ENEMY_CHIP.instantiate()
		$Triangle/HBoxContainer.add_child(chip)
	for enemy : BaseEnemy in wave.wave_enemies:
		enemy.enemy_data.enemy_type
		print("wave.wave_enemies len = " + str(len(wave.wave_enemies)))

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
