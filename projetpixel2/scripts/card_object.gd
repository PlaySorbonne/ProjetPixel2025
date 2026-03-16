extends Button
class_name CardObject


signal card_played
signal card_clicked

const FAMILY_COLORS := {
	CardData.CardFamilies.Military : Color.RED,
	CardData.CardFamilies.Scientists : Color.SKY_BLUE,
	CardData.CardFamilies.Traders : Color.YELLOW,
	CardData.CardFamilies.Revolution : Color.WHITE,
}
const FAMILY_CORE_SHADERS := {
	CardData.CardFamilies.Military : preload("res://resources/materials/flaring_star_military.tres"),
	CardData.CardFamilies.Scientists : preload("res://resources/materials/flaring_star_scientists.tres"),
	CardData.CardFamilies.Traders : preload("res://resources/materials/flaring_star_traders.tres"),
	CardData.CardFamilies.Revolution : preload("res://resources/materials/flaring_star_alien.tres"),
}
const ANIM_TIME := 0.175
const CARD_OBJ_RES := preload("res://scenes/interface/cards/card_object.tscn")
const MAX_OUTLINE_WIDTH := 15.

static var currently_turned_card : CardObject = null

static func create_card_object(card_data : CardData) -> CardObject:
	var new_card : CardObject = CARD_OBJ_RES.instantiate()
	new_card.card = card_data
	return new_card


@export var card : CardData
var is_dragged := false:
	set(value):
		if value:
			if not sacrificing_card:
				core_texture.visible = false
				background_texture.visible = false
		else:
			core_texture.visible = true
			background_texture.visible = true
		is_dragged = value
var can_be_dropped_on_objects := false
var deck_position : Vector2
var deck_rotation : float
var card_tweens : Dictionary[String, Tween] = {}
var sacrificing_card := false
var tween_dissolve : Tween
var mouse_over_card := false
var previous_dissolve_uv : Vector2
var target_outline_width := 0.0
@export var can_be_hovered := true

@onready var card_texture : TextureRect = $CardTexture
@onready var core_texture : TextureRect = $CoreTexture
@onready var background_texture : TextureRect = $CoreTextureBackground
@onready var card_texture_size : Vector2 = card_texture.texture.get_size()


func _ready() -> void:
	await get_tree().process_frame
	$CardTexture/Label.text = card.name
	#card_texture.self_modulate = FAMILY_COLORS[card.family]
	core_texture.material = FAMILY_CORE_SHADERS[card.family]
	if deck_position == Vector2.ZERO:
		deck_position = position
		deck_rotation = rotation

func _process(_delta: float) -> void:
	# set outline if can be dropped
	if is_dragged and can_drop_card():
		if target_outline_width != MAX_OUTLINE_WIDTH:
			target_outline_width = MAX_OUTLINE_WIDTH
			set_card_outline_width(target_outline_width)
	# remove outline if can't be dropped
	elif target_outline_width == MAX_OUTLINE_WIDTH:
		target_outline_width = 0.0
		set_card_outline_width(target_outline_width)

func can_drop_card() -> bool:
	if card.tactics:
		return global_position.y <= \
		GV.hud.cards_container.global_position.y \
		- GV.hud.cards_container.size.y * 1.25
	else:
		return GV.mouse_3d_interaction.hovered_object is TowerBase

func set_card_outline_width(new_width : float) -> void:
	var t := create_tween().set_trans(Tween.TRANS_CUBIC)
	var initial_width : float = $CardTexture.material.get_shader_parameter("width")
	t.tween_method(_update_card_outline, initial_width, new_width, 0.25)

func _update_card_outline(new_width : float) -> void:
	$CardTexture.material.set_shader_parameter("width", new_width)

func cancel_tween_properties(properties : Array[String]) -> void:
	for k : String in properties:
		if card_tweens.has(k) and card_tweens[k]:
			card_tweens[k].kill()

func tween_properties(properties : Dictionary[String, Variant]) -> void:
	for k : String in properties.keys():
		if card_tweens.has(k) and card_tweens[k]:
			card_tweens[k].kill()
		card_tweens[k] = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC
				).set_ignore_time_scale(true).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS
				).set_ease(Tween.EASE_OUT).set_parallel(true)
		card_tweens[k].tween_property(self, k, properties[k], ANIM_TIME)

func _on_button_down() -> void:
	card_clicked.emit()
	$DragAndDrop2D.press()

func release_card() -> void:
	await get_tree().process_frame
	$DragAndDrop2D.was_just_pressed = false
	$DragAndDrop2D.release()
	is_dragged = false
	$DragAndDrop2D.drop()

func _input(event: InputEvent) -> void:
	if is_dragged:
		if event is InputEventMouseButton:
			if event.is_pressed():
				$DragAndDrop2D.press()
			elif event.is_released():
				$DragAndDrop2D.release()

func _update_radius(value: float) -> void:
	card_texture.material.set_shader_parameter("radius", value)

func _on_drag_and_drop_2d_dragged() -> void:
	#print("_on_drag_and_drop_2d_dragged")
	if deck_position == Vector2.ZERO:
		deck_position = position
	is_dragged = true
	cancel_tween_properties(["position"])
	tween_properties({
		"rotation" : 0.0,
		"modulate" : Color(1.0, 1.0, 1.0, 0.5),
	})
	GV.is_dragging_object = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_drag_and_drop_2d_dropped() -> void:
	is_dragged = false
	GV.is_dragging_object = false
	modulate = Color.WHITE
	if not can_be_dropped_on_objects:
		mouse_filter = Control.MOUSE_FILTER_PASS
		return_to_hand()
		return
	if card.tactics:
		drop_tactics_card()
	else:
		drop_card_on_tower()

func drop_tactics_card() -> void:
	if can_drop_card():
		play_card(GV)
		destroy_card_object()
	else:
		return_to_hand()

func drop_card_on_tower() -> void:
	var spatial_object : Node3D = GV.mouse_3d_interaction.hovered_object
	if spatial_object != null:
		# match bahavior on spatial object
		if spatial_object is TowerBase:
			var hovered_tower : TowerBase = spatial_object
			if hovered_tower.can_add_card():
				hovered_tower.add_card(self)
				return
	return_to_hand()

func play_card(on_object : Node) -> void:
	if card.trigger_signal == "":
		card.execute_card(null, null)
	else:
		if on_object.has_signal(card.trigger_signal):
			on_object.connect(card.trigger_signal, card.execute_card)
		else:
			var obj_str : String
			if card.tactics:
				obj_str = "TACTICS: GV "
			else:
				obj_str = "UPGRADE: TOWER "
			print_debug("%sDOESN'T HAVE SIGNAL " % obj_str + card.trigger_signal)

func return_to_hand() -> void:
	tween_properties({
		"position" : deck_position,
		"rotation" : deck_rotation,
		"modulate" : Color.WHITE,
	})
	mouse_filter = Control.MOUSE_FILTER_PASS

func destroy_card_object() -> void:
	card_played.emit()

func _on_mouse_entered() -> void:
	if not can_be_hovered:
		return
	mouse_over_card = true
	CardDescription.add_card_description(self)
	tween_properties({
		"position" : Vector2(0.0, -20.0) + deck_position,
		"rotation" : 0.0
	})

func _on_mouse_exited() -> void:
	if not can_be_hovered:
		return
	mouse_over_card = false
	if not is_dragged:
		tween_properties({
			"position" : deck_position,
			"rotation" : deck_rotation,
		})
