extends Control
class_name CardCheck


signal selection_changed(new_selection : bool)

const FLIP_FULL := preload("res://resources/images/ui_assets/icons/flip_full.png")
const FLIP_EMPTY := preload("res://resources/images/ui_assets/icons/flip_empty.png")
const CARD_CHECK_RES := preload("res://scenes/interface/cards/misc/card_check.tscn")


static func add_card_check(parent_card : CardObject) -> CardCheck:
	var card_check := CARD_CHECK_RES.instantiate()
	parent_card.add_child(card_check)
	card_check.card_object = parent_card
	return card_check


var is_selected := false
var card_object : CardObject


func _ready() -> void:
	await get_tree().process_frame
	card_object.get_node("DragAndDrop2D").clicked.connect(toggle_select)

func toggle_select() -> void:
	if is_selected:
		is_selected = false
		$TextureRect.texture = FLIP_EMPTY 
	else:
		is_selected = true
		$TextureRect.texture = FLIP_FULL
	selection_changed.emit(is_selected)
