extends ObjectDescription
class_name ComboDescription


const COMBO_DESCRIPTION_RES := preload("res://scenes/interface/descriptions/combo_description.tscn")

static func add_combo_description(n_combo : ComboLabel) -> ComboDescription:
	var combo_descr : ComboDescription = COMBO_DESCRIPTION_RES.instantiate()
	combo_descr.combo_label = n_combo
	combo_descr._init_description_popup(n_combo)
	return combo_descr


var combo_label : ComboLabel

func _ready() -> void:
	super._ready()
	await get_tree().process_frame
	RunData.enemy_killed.connect(_update_text)
	RunData.combo_reset.connect(_update_text)
	_update_text()

func _update_text() -> void:
	$LabelDescription.text = "Combo increases when an enemy is killed, and resets after " \
	+ str(RunData.combo_max_time) + " seconds."
	$LabelComboVal.text = "Current combo: " + \
	str(RunData.current_combo) + ".\nMaximum run combo: " \
	+ str(RunData.max_run_combo) + "."
