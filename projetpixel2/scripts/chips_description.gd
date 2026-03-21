extends ObjectDescription
class_name ChipsDescription


const CHIPS_DESCRIPTION_RES := preload("res://scenes/interface/descriptions/chips_description.tscn")

static func add_minigame_description(chips_viewport : ChipsViewportContainer) -> ChipsDescription:
	var chips_descr : ChipsDescription = CHIPS_DESCRIPTION_RES.instantiate()
	chips_descr._init_description_popup(chips_viewport)
	return chips_descr


func _ready() -> void:
	super._ready()
