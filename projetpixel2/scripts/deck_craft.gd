extends Control
class_name DeckCraftSubmenu


const DECK_COLORS : Array[Color] = [Color.RED, Color.AQUAMARINE, Color.BLUE,
				Color.MEDIUM_VIOLET_RED, Color.PURPLE, Color.DARK_GOLDENROD, 
				Color.GREEN, Color.MEDIUM_TURQUOISE, Color.SALMON]

var deck_buttons : Dictionary[Deck, DeckButton] = {}
var current_deck : Deck
var displayed_cards : Array[CardObject] = []
var display_cards_checkmarks : Dictionary[CardObject, CardCheck] = {}
var selected_cards : Array[CardObject] = []
var cards_count := 0:
	set(value):
		cards_count = value
		$LabelCardsCount.text = str(value)
@onready var spacer := $CardsScrollContainer/CardContainer/Spacer
@onready var cards_container := $CardsScrollContainer/CardContainer
@onready var decks_container := $ScrollContainer/VBoxContainer


func _ready() -> void:
	add_decks()
	if not SaveData.player_decks.is_empty():
		select_deck(SaveData.player_decks[0])

func add_decks() -> void:
	for deck_button : DeckButton in deck_buttons.values():
		if is_instance_valid(deck_button):
			deck_button.queue_free()
	deck_buttons.clear()
	for d : Deck in SaveData.player_decks:
		add_deck_button(d)

func add_deck_button(deck : Deck) -> void:
	var deck_button := DeckButton.create_deck_button(deck)
	decks_container.add_child(deck_button, false, Node.INTERNAL_MODE_FRONT)
	deck_buttons[deck] = deck_button
	deck_button.pressed.connect(select_deck.bind(deck))

func update_cards() -> void:
	selected_cards.clear()
	var currently_selected_cards : Array[CardData] = []
	if current_deck != null:
		currently_selected_cards = current_deck.cards
	for card_obj : CardObject in displayed_cards:
		var card_check := CardCheck.add_card_check(card_obj)
		if card_obj.card in currently_selected_cards:
			display_cards_checkmarks[card_obj].force_select(true)
			selected_cards.append(card_obj)
		else:
			display_cards_checkmarks[card_obj].force_select(false)

func add_cards() -> void:
	cards_container.custom_minimum_size = $CardsScrollContainer.size
	spacer.custom_minimum_size.x = cards_container.custom_minimum_size.x
	var currently_selected_cards : Array[CardData] = []
	if current_deck != null:
		currently_selected_cards = current_deck.cards
	for card : CardData in CardData.cards_data.values():
		var card_obj := CardObject.create_card_object(card)
		cards_container.add_child(card_obj)
		var card_check := CardCheck.add_card_check(card_obj)
		displayed_cards.append(card_obj)
		if card in currently_selected_cards:
			card_check.force_select(true)
		card_check.selection_changed.connect(card_selection_changed.bind(card_obj))
		display_cards_checkmarks[card_obj] = card_check

func remove_cards_display() -> void:
	for card_obj : CardObject in displayed_cards:
		card_obj.queue_free()
	displayed_cards = []
	selected_cards  = []
	cards_count = 0

func card_selection_changed(new_selection : bool, card : CardObject) -> void:
	if new_selection:
		selected_cards.append(card)
	else:
		selected_cards.erase(card)

func get_selected_cards() -> Array[CardData]:
	var current_cards : Array[CardData] = []
	for card_obj : CardObject in selected_cards:
		current_cards.append(card_obj.card)
	return current_cards

func get_deck_index() -> int:
	var deck_index := SaveData.player_decks.find(current_deck)
	if deck_index == -1:
		assert(false, "Current deck not found")
	return deck_index

func _on_color_button_pressed() -> void:
	$ColorButton.modulate = DECK_COLORS.pick_random()

func _on_button_add_deck_pressed() -> void:
	current_deck = Deck.new("My Deck", DECK_COLORS.pick_random(), [])
	add_deck_button(current_deck)

func select_deck(deck : Deck) -> void:
	if current_deck != null and current_deck != deck:
		deck_buttons[current_deck].deselect_button()
	deck_buttons[deck].select_button()
	current_deck = deck
	$ColorButton.modulate = deck.color
	$DeckName.text = deck.name
	if displayed_cards.is_empty():
		add_cards()
	else:
		update_cards()

func _on_button_save_pressed() -> void:
	var deck_index := SaveData.player_decks.find(current_deck)
	if deck_index == -1:
		deck_index = len(SaveData.player_decks)
		SaveData.player_decks.append(current_deck)
	current_deck.color = $ColorButton.modulate
	current_deck.name = $DeckName.text
	current_deck.cards = get_selected_cards()
	SaveData.player_decks
	SaveData.save_game()
	for deck : Deck in SaveData.player_decks:
		print(deck.deck_to_string())

func _on_button_erase_pressed() -> void:
	deck_buttons[current_deck].destroy_button()
	deck_buttons.erase(current_deck)
	assert(SaveData.player_decks.find(current_deck), "Current deck not found!")
	SaveData.player_decks.erase(current_deck)
	current_deck = null
	remove_cards_display()
	SaveData.save_game()
