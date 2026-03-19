extends Button
class_name CasinoMinigameButton


@export var minigame_name := "Russian Roulette"
@export var minigame_popup : PackedScene
@export var game_delay := 20.0
@export var current_delay := 20.0
@export var manually_start_minigame := false
@export var bet_cost := 2

var can_launch_minigame := true


func _ready() -> void:
	$LabelTime.text = "%.2f" % current_delay
	$LabelName.text = minigame_name

func _process(delta: float) -> void:
	if not RunData.have_waves_started:
		return
	current_delay -= delta
	if current_delay <= 0.0:
		current_delay = 0.0
		if not manually_start_minigame:
			launch_minigame()
	$LabelTime.text = "%.2f" % current_delay

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

func increase_bet() -> void:
	pass

func _on_button_bet_pressed() -> void:
	if RunData.current_chips >= bet_cost:
		RunData.current_chips -= bet_cost
		var t : Tween = $ButtonBet.get_tween()
		t.tween_property(self, "scale", Vector2(1.2, 1.2), 0.15)
		t.tween_property(self, "scale", Vector2(1.05, 1.05), 0.15)
		increase_bet()
	else:
		var t : Tween = $ButtonBet.get_tween()
		t.tween_property(self, "scale", Vector2(0.9, 0.9), 0.15)
		t.tween_property(self, "scale", Vector2(1.05, 1.05), 0.15).set_delay(0.4)
