extends Control
class_name CardsContainer


signal draw_pile_shuffled
signal card_drawn

@export var hand_size := 6
@export var cards_hand : Array[CardObject] = []
@export var draw_pile : Array[CardObject] = []
@export var discard_pile : Array[CardObject] = []


func _ready() -> void:
	pass

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_p"):
		draw_hand()

func draw_hand() -> void:
	for _i in range(hand_size):
		draw_card()
		await card_drawn

func draw_card() -> void:
	if len(draw_pile) == 0:
		discard_pile_to_draw_pile()
		await draw_pile_shuffled
	var last_draw_pile_card := len(draw_pile)-1
	_add_playable_card(draw_pile[last_draw_pile_card])
	draw_pile.resize(last_draw_pile_card)
	await get_tree().create_timer(0.15).timeout
	card_drawn.emit()

func discard_pile_to_draw_pile() -> void:
	draw_pile = discard_pile.duplicate()
	draw_pile.shuffle()
	discard_pile.resize(0)
	await get_tree().create_timer(0.5).timeout
	draw_pile_shuffled.emit()

func add_card_to_hand(card_data: CardData, forced_position := Vector2.ZERO) -> void:
	var new_card : CardObject = PlayerHud.CARD_OBJ_RES.instantiate()
	new_card.card = card_data
	if forced_position != Vector2.ZERO:
		new_card.global_position = forced_position
	_add_playable_card(new_card)

func _add_playable_card(new_card : CardObject) -> void:
	cards_hand.append(new_card)
	add_child(new_card)
	reorder_hand()
	await get_tree().process_frame
	new_card.can_be_dropped_on_objects = true

func remove_card_from_hand(card_object : CardObject) -> void:
	cards_hand.erase(card_object)
	reorder_hand()

func reorder_hand() -> void:
	var card_count : int = cards_hand.size()
	if card_count == 0:
		return
	
	var container_size : Vector2 = $CardsContainer.size
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
