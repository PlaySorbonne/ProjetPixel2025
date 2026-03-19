extends Button
class_name CasinoMinigameButton


@export var minigame_name := "Russian Roulette"
@export var bet_txt := " dice"
@export var reward_txt := " per 6"
@export var minigame_popup : PackedScene
@export var game_delay := 20.0
@export var current_delay := 20.0
@export var manually_start_minigame := false
@export var bet_cost := 6
@export var reward := 50

var current_investment := 0
var current_level := 0
var can_launch_minigame := true



func _ready() -> void:
	$LabelTime.text = "%.2f" % current_delay
	$LabelName.text = minigame_name
	_update_investment_text()

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
	reset_investment()

func _on_pressed() -> void:
	if manually_start_minigame and current_delay <= 0.0:
		launch_minigame()

func invest() -> void:
	current_level += 1
	current_investment += bet_cost
	_update_investment_text()

func reset_investment() -> void:
	current_investment = 0
	current_level = 0
	_update_investment_text()

func _update_investment_text() -> void:
	$LabelInvestment.text = "- " + str(current_investment) \
	+ "\n- " + str(current_level) + bet_txt \
	+ "\n- " + str(reward) + "$ " + reward_txt

func _on_button_bet_pressed() -> void:
	if RunData.current_chips >= bet_cost:
		RunData.current_chips -= bet_cost
		var t : Tween = $ButtonBet.get_tween()
		t.tween_property(self, "scale", Vector2(1.2, 1.2), 0.15)
		t.tween_property(self, "scale", Vector2(1.05, 1.05), 0.15)
		invest()
	else:
		var t : Tween = $ButtonBet.get_tween()
		t.tween_property(self, "scale", Vector2(0.9, 0.9), 0.15)
		t.tween_property(self, "scale", Vector2(1.05, 1.05), 0.15).set_delay(0.4)
