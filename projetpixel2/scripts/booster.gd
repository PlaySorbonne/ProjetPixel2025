extends Control
class_name Booster


signal booster_opened

const BOOSTER_RES := preload("res://scenes/interface/cards/booster.tscn")

var booster_cards : Array[CardData]


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
	var cards : Array[CardObject] = []
	for i : int in range(len(booster_cards)):
		var card := GV.cards_container.create_card_object(booster_cards[i])
		card.modulate = Color.TRANSPARENT
		card.scale = Vector2(0.5, 0.5)
		$NewCardsContainer.add_child(card)
		cards.append(card)
	for i : int in range(len(booster_cards)):
		tween_intro(cards[i])
		if i != len(booster_cards)-1:
			await get_tree().create_timer(0.25).timeout

func destroy_booster() -> void:
	var t := create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	t.tween_property(self, "scale", Vector2.ZERO, 0.75)
	t.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	t.finished.connect(queue_free)
