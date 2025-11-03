extends TextureButton
class_name DeckButton


const DECK_BUTTON_RES := preload("res://scenes/interface/menus/objects/deck_button.tscn")

static func create_deck_button(n_deck : Deck) -> DeckButton:
	var deck_button := DECK_BUTTON_RES.instantiate()
	deck_button.deck = n_deck
	return deck_button


var deck : Deck


func _ready() -> void:
	# set button gradient
	var button_gradient := GradientTexture1D.new()
	button_gradient.gradient = Gradient.new()
	button_gradient.gradient.add_point(0.0, Color.BLACK)
	button_gradient.gradient.add_point(0.85, deck.color)
	texture_pressed = button_gradient
	texture_normal = button_gradient
	texture_hover = button_gradient
	$TextureSelect.modulate = deck.color
	# set button text
	$Label.text = deck.name

func select_button() -> void:
	$TextureSelect.visible = true

func deselect_button() -> void:
	$TextureSelect.visible = false

func destroy_button() -> void:
	queue_free()
