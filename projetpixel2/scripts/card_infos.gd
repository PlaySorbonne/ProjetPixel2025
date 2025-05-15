extends HBoxContainer
class_name CardInfos


var card : Card:
	set(new_val):
		card = new_val
		if is_inside_tree():
			update_card_data()


func _ready() -> void:
	update_card_data()

func update_card_data() -> void:
	$LabelName.text = card.name
	$LabelEffect.text = card.description
