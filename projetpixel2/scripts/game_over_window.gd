extends CasinoWindow
class_name GameOverWindow


const GAME_OVER_WINDOW_RES := preload("res://scenes/interface/casino_minigames/game_over_window.tscn")

static func spawn_game_over_window() -> void:
	var game_over_window : GameOverWindow = GAME_OVER_WINDOW_RES.instantiate()
	GV.hud.add_child(game_over_window)


func _ready() -> void:
	position = get_viewport().get_visible_rect().size / 2.0
	super._ready()
	open_window()
