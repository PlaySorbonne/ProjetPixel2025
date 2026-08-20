extends ColorRect
class_name MinigamePauseCover


const NODE_RES := preload("res://scenes/interface/casino_minigames/sub_objects/minigame_pause_node.tscn")


static func add_minigame_pause_cover() -> MinigamePauseCover:
	var cover := NODE_RES.instantiate()
	GV.hud.add_child(cover)
	return cover


@export var pause_on_start := true


func _ready() -> void:
	if pause_on_start:
		pause_game()

func pause_game() -> void:
	get_tree().paused = true

func unpause_game() -> void:
	get_tree().paused = false
	queue_free()
