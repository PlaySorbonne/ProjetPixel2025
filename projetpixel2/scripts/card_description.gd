extends Control
class_name CardDescription


const CARD_DECRIPTION_RES := preload("res://scenes/interface/cards/card_description.tscn")
const X_OFFSET := 10.0

static func add_card_description(n_card_object : CardObject) -> CardDescription:
	var card_description : CardDescription = CARD_DECRIPTION_RES.instantiate()
	card_description.card_object = n_card_object
	card_description.visible = false
	n_card_object.add_child(card_description)
	return card_description


var card_object : CardObject = null


func _ready() -> void:
	position = _set_description_position()
	scale = Vector2(0.8, 0.2)
	modulate = Color(1, 1, 1, 0.3)
	var t := create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(
				).set_ignore_time_scale(true)
	t.tween_property(self, "scale", Vector2.ONE, 0.15)
	t.tween_property(self, "modulate", Color.WHITE, 0.15)
	#rotation = -card_object.rotation
	card_object.mouse_exited.connect(destroy_description)
	await get_tree().process_frame
	$LabelTitle.text = card_object.card.name
	$LabelDescription.text = card_object.card.description
	$LabelFamily.text = CardData.CardFamilies.keys()[card_object.card.family]
	$LabelRarity.text = CardData.CardRarities.keys()[card_object.card.rarity]
	visible = true

func _set_description_position() -> Vector2:
	var viewport_width : float = get_viewport().get_visible_rect().size.x
	var card_pos_x : float = card_object.global_position.x + card_object.size.x
	var distance_from_right = viewport_width - card_pos_x
	if distance_from_right < 400:
		return Vector2(-self.size.x - X_OFFSET, 0.0)
	else:
		return Vector2(card_object.size.x + X_OFFSET, 0.0)

func destroy_description() -> void:
	var t := create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(
					).set_ignore_time_scale(true)
	t.tween_property(self, "scale", Vector2.ZERO, 0.15)
	t.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.15)
	await t.finished
	queue_free()
