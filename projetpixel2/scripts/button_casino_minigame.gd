extends Button
class_name CasinoMinigameButton


enum Minigames{Dice, RussianRoulette, RouletteWheel}


@export var minigame_name := "Russian Roulette"
@export var minigame_type : Minigames
@export_multiline var minigame_description := "Russian Roulette"
@export var minigame_popup : PackedScene
@export var game_delay := 20.0
@export var current_delay := 20.0
@export var manually_start_minigame := false
@export var bet_cost := 6
@export var average_reward := 50
@export var min_reset_level := 1

var current_investment := 0
var current_level := 1
var can_launch_minigame := true



func _ready() -> void:
	$LabelTime.text = "%.2f" % current_delay
	$LabelName.text = minigame_name
	$LabelCost.text = str(bet_cost) + "$"
	_update_investment_text()
	GV.minigame_buttons[minigame_type] = self

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
	var popup : CasinoMinigameWindow = minigame_popup.instantiate()
	popup.minigame_level = current_level
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
	current_level = min_reset_level
	_update_investment_text()

func _update_investment_text() -> void:
	$LabelInvestment.text = "  " + str(current_investment) \
	+ "$\n  " + str(current_level) \
	+ "\n  " + str(average_reward * current_level) + "$ " 

func _on_button_bet_pressed() -> void:
	if RunData.current_chips >= bet_cost:
		RunData.current_chips -= bet_cost
		var t : Tween = $ButtonBet.get_tween()
		t.tween_property($ButtonBet, "scale", Vector2(1.2, 1.2), 0.15)
		t.tween_property($ButtonBet, "scale", Vector2(1.05, 1.05), 0.15)
		invest()
	else:
		var t : Tween = $ButtonBet.get_tween()
		t.tween_property($ButtonBet, "scale", Vector2(0.9, 0.9), 0.15)
		t.tween_property($ButtonBet, "scale", Vector2(1.05, 1.05), 0.15).set_delay(0.4)

func _on_mouse_entered() -> void:
	MinigameDescription.add_minigame_description(self)
