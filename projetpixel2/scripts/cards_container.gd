extends Control
class_name CardsContainer


signal card_drawn
signal booster_cards_spawned(booster : Booster)
signal booster_cards_drawn(booster : Booster)

const CARD_OFFSET_INCREMENT := Vector2(10.0, 10.0)

@export var common_cards : Array[CardData] 
@export var rare_cards : Array[CardData] 

var cards_hand : Array[CardObject] = []


func _ready() -> void:
	GV.cards_container = self

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_p"):
		draw_cards(3, CardData.CardRarities.Common)

func draw_cards_of_rarity(cards_rarities : Array[CardData.CardRarities],
				booster : Booster = null) -> void:
	var card_pos_offset := Vector2.ZERO
	var nb_cards_to_draw := len(cards_rarities)
	for i : int in range(nb_cards_to_draw):
		_draw_card(cards_rarities[i], card_pos_offset)
		card_pos_offset += CARD_OFFSET_INCREMENT
		await card_drawn
		await get_tree().create_timer(0.05).timeout
	await get_tree().create_timer(0.15).timeout
	booster_cards_spawned.emit(booster)
	await get_tree().create_timer(0.2).timeout
	booster_cards_drawn.emit(booster)
	reorder_hand()

func draw_cards(cards_to_draw : int, rarity : CardData.CardRarities,
				booster : Booster = null) -> void:
	var cards_rarities : Array[CardData.CardRarities] = []
	for _i : int in range(len(cards_to_draw)):
		cards_rarities.append(rarity)
	draw_cards_of_rarity(cards_rarities, booster)

func _draw_card(rarity : CardData.CardRarities, pos_offset := Vector2.ZERO) -> void:
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
	var card_pos : Vector2 =                    \
	GV.hud.booster_container.global_position    \
	+ GV.hud.booster_container.size / 2.0       \
	- new_card.custom_minimum_size / 2.0        \
	+ pos_offset
	_add_playable_card(new_card, card_pos)
	await get_tree().create_timer(0.1).timeout
	card_drawn.emit()

func create_card_object(card_data : CardData) -> CardObject:
	var new_card : CardObject = PlayerHud.CARD_OBJ_RES.instantiate()
	new_card.card = card_data
	new_card.card_played.connect(on_card_played.bind(new_card))
	return new_card

func on_card_played(card : CardObject) -> void:
	consume_card(card)

func add_card_to_hand(card_data: CardData, pos_offset := Vector2.ZERO) -> void:
	var new_card := create_card_object(card_data)
	_add_playable_card(new_card, pos_offset)

func _add_playable_card(new_card : CardObject, 
		forced_pos := Vector2.ZERO, with_anim := true) -> void:
	if with_anim:
		new_card.modulate = Color.TRANSPARENT
	cards_hand.append(new_card)
	new_card.set_can_be_dragged(false)
	if forced_pos != Vector2.ZERO:
		new_card.global_position = forced_pos
	if new_card.get_parent():
		new_card.reparent(self)
	else:
		add_child(new_card)
	await get_tree().process_frame
	if forced_pos != Vector2.ZERO:
		new_card.global_position = forced_pos
	if with_anim:
		new_card.scale = Vector2(0.5, 0.5)
		var t := create_tween().set_ease(Tween.EASE_IN).set_parallel()
		t.tween_property(new_card, "modulate", Color.WHITE, 0.075)
		t.tween_property(new_card, "scale", Vector2.ONE, 0.075)
	await get_tree().create_timer(0.25).timeout
	new_card.set_can_be_dragged(true)
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
