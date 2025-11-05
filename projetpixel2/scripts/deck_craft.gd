extends Control
class_name DeckCraftSubmenu


var initialized := false
var deck_buttons : Dictionary[Deck, DeckButton] = {}
var current_deck : Deck
var displayed_cards : Array[CardObject] = []
var display_cards_checkmarks : Dictionary[CardObject, CardCheck] = {}
var selected_cards : Array[CardObject] = []
var current_texture_index := -1
var cards_count := 0:
	set(value):
		cards_count = value
		$LabelCardsCount.text = str(value)
@onready var spacer := $CardsScrollContainer/CardContainer/Spacer
@onready var cards_container := $CardsScrollContainer/CardContainer
@onready var decks_container := $ScrollContainer/VBoxContainer


func _ready() -> void:
	$DeckTexturesContainer.visible = false
	add_decks()
	hide_deck_textures_container()
	if visible:
		initialize_cards()
	for button : DeckTextureButton in $DeckTexturesContainer.get_children():
		button.pressed.connect(_on_button_texture_pressed.bind(button))

func initialize_cards() -> void:
	if initialized:
		return
	initialized = true
	if len(SaveData.player_decks) > SaveData.selected_deck:
		select_deck(SaveData.player_decks[SaveData.selected_deck])

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
		currently_selected_cards = current_deck.get_cards()
	for card_obj : CardObject in displayed_cards:
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
		currently_selected_cards = current_deck.get_cards()
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

func get_selected_cards() -> Array[String]:
	var current_cards : Array[String] = []
	for card_obj : CardObject in selected_cards:
		current_cards.append(card_obj.card.name)
	return current_cards

func get_deck_index() -> int:
	var deck_index := SaveData.player_decks.find(current_deck)
	if deck_index == -1:
		assert(false, "Current deck not found")
	return deck_index

func _on_color_button_pressed() -> void:
	if current_texture_index == -1:
		return
	if $DeckTexturesContainer.visible:
		hide_deck_textures_container()
	else:
		$DeckTexturesContainer.visible = true
		var t := create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
		t.tween_property($DeckTexturesContainer, "modulate", Color.WHITE, 0.12)
		t.tween_property($DeckTexturesContainer, "scale", Vector2.ONE, 0.12)

func _on_button_texture_pressed(button : DeckTextureButton) -> void:
	current_texture_index = button.texture_index
	$ColorButton.icon = Deck.DECK_TEXTURES[current_texture_index]
	hide_deck_textures_container()

func hide_deck_textures_container() -> void:
	var t := create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	t.tween_property($DeckTexturesContainer, "modulate", Color(1, 1, 1, 0.4), 0.12)
	t.tween_property($DeckTexturesContainer, "scale", Vector2(0.8, 0.0), 0.12)
	await t.finished
	$DeckTexturesContainer.visible = false

func _on_button_add_deck_pressed() -> void:
	var new_deck : Deck = Deck.new(
		"My Deck " + str(len(deck_buttons)+1), 
		randi_range(0, len(Deck.DECK_TEXTURES)-1), 
		[]
	)
	add_deck_button(new_deck)
	select_deck(new_deck)

func select_deck(deck : Deck) -> void:
	if current_deck != null and current_deck != deck:
		deck_buttons[current_deck].deselect_button()
	deck_buttons[deck].select_button()
	current_deck = deck
	current_texture_index = deck.texture_index
	SaveData.selected_deck = SaveData.player_decks.find(current_deck)
	$ColorButton.icon = Deck.DECK_TEXTURES[current_texture_index]
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
	current_deck.texture_index = current_texture_index
	current_deck.name = $DeckName.text
	current_deck.cards = get_selected_cards()
	SaveData.player_decks[deck_index] = current_deck
	SaveData.save_game()
	deck_buttons[current_deck].update_deck_color()
	deck_buttons[current_deck].update_deck_name()

func _on_button_erase_pressed() -> void:
	deck_buttons[current_deck].destroy_button()
	deck_buttons.erase(current_deck)
	var removed_deck_index := SaveData.player_decks.find(current_deck)
	assert(removed_deck_index >= 0, "Current deck not found!")
	if SaveData.selected_deck >= removed_deck_index and SaveData.selected_deck != 0:
		SaveData.selected_deck -= 1
	SaveData.player_decks.erase(current_deck)
	current_deck = null
	remove_cards_display()
	SaveData.save_game()
