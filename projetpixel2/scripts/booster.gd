extends Control
class_name Booster


signal booster_opened

const BOOSTER_RES := preload("res://scenes/interface/cards/booster.tscn")

var card_objects : Array[CardObject]
var is_booster_open := false
var is_mouse_over := false
var is_card_selected := false
@onready var sides : Array[ColorRect] = [
	$ColorRect1, $ColorRect2, $ColorRect3, $ColorRect4
]

static func spawn_booster(nparent : Node, pos : Vector2) -> Booster:
	var new_booster := BOOSTER_RES.instantiate()
	new_booster.scale = Vector2(0.5, 0.5)
	new_booster.modulate = Color.TRANSPARENT
	new_booster.position = pos
	nparent.add_child(new_booster)
	return new_booster


func _ready() -> void:
	await tween_intro(self).finished
	$AnimationPlayer.play("idle")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") \
	and is_mouse_over and not is_booster_open:
		open_booster()

func open_booster() -> void:
	is_booster_open = true
	$AnimationPlayer.speed_scale = 1.0
	_update_scroll_speed(.75)
	$Background.mouse_default_cursor_shape = CursorShape.CURSOR_ARROW
	$Shaker.stop_shake()
	$AnimationPlayer.play("open_booster")

func tween_intro(obj : CanvasItem) -> Tween:
	var t := create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
	t.tween_property(obj, "scale", Vector2.ONE, 0.25)
	t.tween_property(obj, "modulate", Color.WHITE, 0.25)
	return t

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	booster_opened.emit()
	card_objects = []
	var booster_cards : Array[CardData] = []
	for _i : int in range(3):
		var new_card : CardData = CardData.get_random_card()
		booster_cards.append(new_card)
	for i : int in range(len(booster_cards)):
		var card := GV.cards_container.create_card_object(booster_cards[i])
		card.modulate = Color.TRANSPARENT
		card.scale = Vector2(5.0, 5.0)
		card.can_be_hovered = false
		$NewCardsContainer.add_child(card)
		card_objects.append(card)
		var select_button := SelectCardButton.add_select_button_to_card(card)
		select_button.card_selected.connect(_on_card_level_clicked.bind(card, select_button))
	arrange_new_cards(card_objects)
	for i : int in range(len(booster_cards)):
		tween_intro(card_objects[i]).finished.connect(_card_ready.bind(card_objects[i]))
		if i != len(booster_cards)-1:
			await get_tree().create_timer(0.25).timeout

func _card_ready(card : CardObject) -> void:
	GV.player_camera.shake(0.1, 15, 0.5)
	card.can_be_hovered = true

func arrange_new_cards(cards : Array[CardObject], spacing: float = 15.0) -> void:
	var container : Control = $NewCardsContainer
	# Compute total width
	var total_width := 0.0
	for card : CardObject in cards:
		total_width += card.size.x
	total_width += spacing * (cards.size() - 1)
	# Center row
	var start_x := (container.size.x - total_width) / 2.0
	# Position elements
	var x := start_x
	for card : CardObject in cards:
		card.position.x = x
		card.position.y = (container.size.y - card.size.y) / 2.0
		x += card.size.x + spacing

func _on_card_level_clicked(chosen_card : CardObject, card_button : SelectCardButton) -> void:
	if is_card_selected:
		return
	is_card_selected = true
	card_button.queue_free()
	#Engine.time_scale = 1.0
	for card : CardObject in card_objects:
		if card != chosen_card:
			destroy_object(card)
	await get_tree().create_timer(0.5).timeout
	chosen_card.get_parent().remove_child(chosen_card)
	GV.hud.cards_container._add_playable_card(chosen_card)
	$AnimationPlayer.stop(true)
	await get_tree().create_timer(0.25).timeout
	destroy_object(self)

func destroy_object(obj : CanvasItem) -> void:
	var t := create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	t.tween_property(obj, "scale", Vector2.ZERO, 0.75)
	t.tween_property(obj, "modulate", Color.TRANSPARENT, 0.5)
	t.finished.connect(obj.queue_free)

func _on_background_mouse_entered() -> void:
	is_mouse_over = true
	if not is_booster_open:
		$Shaker.shake(-1.0, 15, 5)
		$AnimationPlayer.speed_scale = 1.75
		var t := create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
		for side : ColorRect in sides:
			t.tween_property(side, "color", Color(0.0, 0.208, 0.094), 0.25)

func _on_background_mouse_exited() -> void:
	is_mouse_over = false
	if not is_booster_open:
		$Shaker.stop_shake()
		$AnimationPlayer.speed_scale = 1.0
		var t := create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
		for side : ColorRect in sides:
			t.tween_property(side, "color", Color.BLACK, 0.25)

func get_scroll_speed() -> float:
	return $Background.material.get_shader_parameter("scroll_speed")

func _update_scroll_speed(to_val : float) -> void:
	var bg_mat : ShaderMaterial = $Background.material
	bg_mat.set_shader_parameter("scroll_speed", to_val)
