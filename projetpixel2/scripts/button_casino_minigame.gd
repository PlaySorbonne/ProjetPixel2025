extends Button
class_name CasinoMinigameButton


@export var minigame_popup : PackedScene
@export var game_delay := 20.0
@export var current_delay := 20.0
@export var manually_start_minigame := false

var can_launch_minigame := true


func _ready() -> void:
	$Label.text = "%.2f" % current_delay

func _process(delta: float) -> void:
	if not RunData.have_waves_started:
		return
	current_delay -= delta
	if current_delay <= 0.0:
		current_delay = 0.0
		if not manually_start_minigame:
			launch_minigame()
	$Label.text = "%.2f" % current_delay

func launch_minigame(force := false) -> void:
	if not can_launch_minigame and not force:
		return
	current_delay = game_delay
	var popup : CasinoWindow = minigame_popup.instantiate()
	CasinoWindow.spawn_popup(popup)
	await get_tree().process_frame
	popup.position = CasinoWindow.random_popup_position()
	popup.open_window()

func _on_pressed() -> void:
	if manually_start_minigame and current_delay <= 0.0:
		launch_minigame()
