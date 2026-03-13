extends Control
class_name Booster


signal booster_opened

const BOOSTER_RES := preload("res://scenes/interface/cards/booster.tscn")

var booster_cards : Array[CardData]
var card_objects : Array[CardObject]


static func spawn_booster(nparent : Node, pos : Vector2) -> Booster:
	var new_booster := BOOSTER_RES.instantiate()
	new_booster.scale = Vector2(0.5, 0.5)
	new_booster.modulate = Color.TRANSPARENT
	new_booster.position = pos
	nparent.add_child(new_booster)
	return new_booster


func _ready() -> void:
	tween_intro(self)

func open_booster(new_cards : Array[CardData]) -> void:
	booster_cards = new_cards
	await get_tree().create_timer(0.5).timeout
	$AnimationPlayer.play("open_booster")

func tween_intro(obj : CanvasItem) -> void:
	var t := create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
	t.tween_property(obj, "scale", Vector2.ONE, 0.25)
	t.tween_property(obj, "modulate", Color.WHITE, 0.25)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	booster_opened.emit()
	card_objects = []
	for i : int in range(len(booster_cards)):
		var card := GV.cards_container.create_card_object(booster_cards[i])
		card.modulate = Color.TRANSPARENT
		card.scale = Vector2(0.5, 0.5)
		$NewCardsContainer.add_child(card)
		card_objects.append(card)
		var select_button := SelectCardButton.add_select_button_to_card(card)
		select_button.card_selected.connect(_on_card_level_clicked.bind(card, select_button))
	for i : int in range(len(booster_cards)):
		tween_intro(card_objects[i])
		if i != len(booster_cards)-1:
			await get_tree().create_timer(0.25).timeout

func _on_card_level_clicked(chosen_card : CardObject, card_button : SelectCardButton) -> void:
	card_button.queue_free()
	#Engine.time_scale = 1.0
	for card : CardObject in card_objects:
		if card != chosen_card:
			destroy_object(card)
	chosen_card.get_parent().remove_child(chosen_card)
	GV.hud.cards_container._add_playable_card(chosen_card)

func destroy_object(obj : CanvasItem) -> void:
	var t := create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	t.tween_property(obj, "scale", Vector2.ZERO, 0.75)
	t.tween_property(obj, "modulate", Color.TRANSPARENT, 0.5)
	t.finished.connect(queue_free)
