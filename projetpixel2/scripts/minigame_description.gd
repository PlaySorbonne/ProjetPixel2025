extends ObjectDescription
class_name MinigameDescription


const MINIGAME_DESCRIPTION_RES := preload("res://scenes/interface/descriptions/minigame_description.tscn")

static func add_minigame_description(n_minigame : CasinoMinigameButton) -> MinigameDescription:
	var minigame_descr : MinigameDescription = MINIGAME_DESCRIPTION_RES.instantiate()
	minigame_descr.minigame = n_minigame
	minigame_descr._init_description_popup(n_minigame)
	return minigame_descr


var minigame : CasinoMinigameButton

func _ready() -> void:
	super._ready()
	await get_tree().process_frame
	$LabelDescription.text = minigame.minigame_description
	$LabelTitle.text = minigame.minigame_name
