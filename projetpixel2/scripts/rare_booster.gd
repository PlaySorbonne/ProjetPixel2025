extends Booster
class_name RareBooster


@export var drawn_cards_number := 2
@export var selected_cards_number := 1
@export var cards_choice_size := 3

var cards_selected := 0


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	super._on_animation_player_animation_finished(_anim_name)
	GV.hud.cards_container.booster_cards_spawned.connect(_on_common_cards_spawned)
	draw_cards(drawn_cards_number, CardData.CardRarities.Common)

func _on_common_cards_spawned(booster : Booster) -> void:
	if booster != self:
		return
	display_cards_choice(cards_choice_size)

func _on_card_selected() -> void:
	cards_selected += 1
	if cards_selected >= selected_cards_number:
		display_cards_choice(cards_choice_size)
