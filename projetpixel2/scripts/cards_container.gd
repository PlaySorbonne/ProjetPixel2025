extends Control
class_name CardsContainer


signal card_drawn

@export var common_cards : Array[CardData] 
@export var rare_cards : Array[CardData] 

var cards_hand : Array[CardObject] = []


func _ready() -> void:
	GV.cards_container = self

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_p"):
		draw_cards(3, CardData.CardRarities.Common)

func draw_cards(cards_to_draw : int, rarity : CardData.CardRarities) -> void:
	for _i in range(cards_to_draw):
		_draw_card(rarity)
		await card_drawn

func _draw_card(rarity : CardData.CardRarities) -> void:
	var draw_pile : Array[CardData]
	match rarity:
		CardData.CardRarities.Common:
			draw_pile = common_cards
		CardData.CardRarities.Uncommon:
			draw_pile = common_cards
		CardData.CardRarities.Rare:
			draw_pile = rare_cards
		CardData.CardRarities.Legendary:
			draw_pile = rare_cards
		CardData.CardRarities.Secret:
			draw_pile = rare_cards
	
	var new_card := create_card_object(draw_pile.pick_random())
	_add_playable_card(new_card)
	await get_tree().create_timer(0.15).timeout
	card_drawn.emit()

func create_card_object(card_data : CardData) -> CardObject:
	var new_card : CardObject = PlayerHud.CARD_OBJ_RES.instantiate()
	new_card.card = card_data
	new_card.card_played.connect(on_card_played.bind(new_card))
	return new_card

func on_card_played(card : CardObject) -> void:
	consume_card(card)

func add_card_to_hand(card_data: CardData, forced_position := Vector2.ZERO) -> void:
	var new_card := create_card_object(card_data)
	if forced_position != Vector2.ZERO:
		new_card.global_position = forced_position
	_add_playable_card(new_card)

func _add_playable_card(new_card : CardObject) -> void:
	cards_hand.append(new_card)
	new_card.global_position = GV.hud.booster_container.global_position
	add_child(new_card)
	reorder_hand()
	await get_tree().process_frame
	new_card.can_be_dropped_on_objects = true

func consume_card(card_object : CardObject) -> void:
	cards_hand.erase(card_object)
	destroy_card(card_object)

func destroy_card(card_object : CardObject) -> void:
	var t := create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	t.tween_property(card_object, "scale", Vector2(0.75, 0.75), 0.4)
	t.tween_property(card_object, "modulate", Color.TRANSPARENT, 0.4)
	t.finished.connect(card_object.queue_free)
	t.finished.connect(reorder_hand)

#func discard_card(card_object : CardObject) -> void:
	#remove_child(card_object)
	#cards_hand.erase(card_object)
	#discard_pile.append(card_object)
	#discard_pile_updated.emit()
	#reorder_hand()

func reorder_hand() -> void:
	var card_count : int = cards_hand.size()
	if card_count == 0:
		return
	
	var container_size : Vector2 = size
	var base_x : float = container_size.x / 2.0 - (cards_hand[0
					].size.x * cards_hand[0].scale.x / 2.0) - 30.0
	var base_y : float = -30.0
	if card_count == 1:
		cards_hand[0].deck_position = Vector2(base_x, base_y)
		cards_hand[0].deck_rotation = 0.0
		cards_hand[0].return_to_hand()
		return
	
	const MAX_X_SPACING := 150.0
	const MAX_Y_SPACING := 40.0
	const MAX_ROTATION_SPACING := PI / 6
	
	var spacing_x : float = min(container_size.x / max(card_count, 1), MAX_X_SPACING)
	
	for i in range(card_count):
		var card : CardObject = cards_hand[i]
		
		var t : float = float(i) / max(card_count - 1, 1)
		var x : float = t * (spacing_x * (card_count - 1))
		var offset_x : float = x - (spacing_x * (card_count - 1) / 2.0)
		
		var offset_norm : float = offset_x / (spacing_x * (card_count - 1) / 2.0)
		var y_offset : float = -pow(offset_norm, 2) * MAX_Y_SPACING
		
		card.deck_position = Vector2(
			base_x + offset_x,
			base_y - y_offset
		)
		card.deck_rotation = lerp(-MAX_ROTATION_SPACING / 2.0, MAX_ROTATION_SPACING / 2.0, t)
		card.z_index = i
	
	for card : CardObject in cards_hand:
		card.return_to_hand()
