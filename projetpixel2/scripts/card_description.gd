extends ObjectDescription
class_name CardDescription


const CARD_DESCRIPTION_RES := preload("res://scenes/interface/descriptions/card_description.tscn")

static func add_card_description(n_card_object : CardObject) -> CardDescription:
	var card_description : CardDescription = CARD_DESCRIPTION_RES.instantiate()
	card_description.parent_object = n_card_object
	card_description.card_object = n_card_object
	card_description.visible = false
	n_card_object.add_child(card_description)
	return card_description


var card_object : CardObject = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	card_object.mouse_exited.connect(destroy_description)
	await get_tree().process_frame
	$LabelTitle.text = card_object.card.name
	$LabelDescription.text = card_object.card.description
	#$LabelFamily.text = CardData.CardFamilies.keys()[card_object.card.family]
	$LabelRarity.text = CardData.CardRarities.keys()[card_object.card.rarity]
