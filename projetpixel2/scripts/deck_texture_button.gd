@tool
extends Button
class_name DeckTextureButton


@export var texture_index : int:
	set(value):
		texture_index = value
		icon = Deck.DECK_TEXTURES[value]
