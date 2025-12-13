extends Button
class_name SelectCardButton


signal card_selected

const SELECT_CARD_RES := preload("res://scenes/interface/cards/misc/select_card_button.tscn")


static func add_select_button_to_card(card : CardObject) -> SelectCardButton:
	var select_button := SELECT_CARD_RES.instantiate()
	card.add_child(select_button)
	return select_button


func _on_pressed() -> void:
	card_selected.emit()
	await get_tree().process_frame
	queue_free()
