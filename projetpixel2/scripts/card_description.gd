extends ObjectDescription
class_name CardDescription


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
