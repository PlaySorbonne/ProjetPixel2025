extends ObjectDescription
class_name CardDescription


const CARD_DESCRIPTION_RES := preload("res://scenes/interface/descriptions/card_description.tscn")

static func add_card_description(n_card_object : CardObject) -> CardDescription:
	var card_description : CardDescription = CARD_DESCRIPTION_RES.instantiate()
	card_description.card_object = n_card_object
	card_description._init_description_popup(n_card_object)
	return card_description


var card_object : CardObject = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	await get_tree().process_frame
	$LabelTitle.text = card_object.card.name
	$LabelDescription.text = card_object.card.description
	#$LabelFamily.text = CardData.CardFamilies.keys()[card_object.card.family]
	$LabelRarity.text = CardData.CardRarities.keys()[card_object.card.rarity]
