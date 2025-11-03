extends Control
class_name DeckCraftSubmenu


const DECK_COLORS : Array[Color] = [Color.RED, Color.AQUAMARINE, Color.BLUE,
				Color.MEDIUM_VIOLET_RED, Color.PURPLE, Color.DARK_GOLDENROD, 
				Color.GREEN, Color.MEDIUM_TURQUOISE, Color.SALMON]

var deck_buttons : Dictionary[Deck, DeckButton] = {}
var current_deck : Deck
var displayed_cards : Array[CardObject] = []
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
	add_cards()

func add_decks() -> void:
	for deck_button : DeckButton in deck_buttons.values():
		if is_instance_valid(deck_button):
			deck_button.queue_free()
	deck_buttons.clear()
	for d : Deck in SaveData.player_decks:
		var deck_button := DeckButton.create_deck_button(d)
		decks_container.add_child(deck_button, false, Node.INTERNAL_MODE_FRONT)
		deck_buttons[d] = deck_button

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
			card_check.toggle_select()
		card_check.selection_changed.connect(card_selection_changed.bind(card_obj))

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
	pass # Replace with function body.

func _on_button_save_pressed() -> void:
	var deck_index := get_deck_index()
	current_deck.color = $ColorButton.modulate
	current_deck.name = $DeckName.text
	current_deck.cards = get_selected_cards()
	SaveData.save_game()

func _on_button_erase_pressed() -> void:
	deck_buttons[current_deck].destroy_button()
	deck_buttons.erase(current_deck)
	SaveData.player_decks.erase(current_deck)
	current_deck = null
	remove_cards_display()
	SaveData.save_game()
