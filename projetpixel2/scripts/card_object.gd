extends Button
class_name CardObject


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

static var currently_turned_card : CardObject = null

static func create_card_object(card_data : CardData) -> CardObject:
	var new_card : CardObject = CARD_OBJ_RES.instantiate()
	new_card.card = card_data
	return new_card

static func check_turned_card(new_card : CardObject) -> void:
	if is_instance_valid(currently_turned_card) and new_card != currently_turned_card:
		currently_turned_card.turn_card(false,
						currently_turned_card.previous_dissolve_uv)
	currently_turned_card = new_card


var card : CardData
var is_dragged := false
var can_be_dropped_on_objects := false
var deck_position : Vector2
var deck_rotation : float
var card_tweens : Dictionary[String, Tween] = {}
var sacrificing_card := false
var tween_dissolve : Tween
var mouse_over_card := false
var previous_dissolve_uv : Vector2

@onready var card_texture : TextureRect = $CardTexture
@onready var core_texture : TextureRect = $CoreTexture
@onready var card_texture_size : Vector2 = card_texture.texture.get_size()


func _ready() -> void:
	await get_tree().process_frame
	$CardTexture/Label.text = card.name
	#card_texture.self_modulate = FAMILY_COLORS[card.family]
	core_texture.material = FAMILY_CORE_SHADERS[card.family]
	if deck_position == Vector2.ZERO:
		deck_position = position
		deck_rotation = rotation

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
	print("card button down")
	card_clicked.emit()
	$DragAndDrop2D.press()

func release_card() -> void:
	await get_tree().process_frame
	$DragAndDrop2D.was_just_pressed = false
	$DragAndDrop2D.release()
	is_dragged = false
	$DragAndDrop2D.drop()

#func press_card() -> void:
	#$DragAndDrop2D.press()

func _input(event: InputEvent) -> void:
	if is_dragged:
		if event is InputEventMouseButton:
			if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
				$DragAndDrop2D.press()
			elif event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
				$DragAndDrop2D.release()
	elif mouse_over_card:
		if event is InputEventMouseButton:
			if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
				check_turned_card(self)
				turn_card(
					not sacrificing_card,  # flip current card side
					card_texture.get_local_mouse_position() / card_texture.size # uv
				)

func turn_card(new_turned : bool, uv : Vector2) -> void:
	print("turn card")
	if sacrificing_card == new_turned:
		return
	previous_dissolve_uv = uv
	if sacrificing_card:
		play_card_dissolve(uv, 0.0)
	else:
		play_card_dissolve(uv, 1.5)
	sacrificing_card = new_turned

func play_card_dissolve(from_uv : Vector2, end : float) -> void:
	const MAX_DISSOLVE_DURATION := 0.3
	card_texture.material.set_shader_parameter("position", from_uv)
	var start : float = card_texture.material.get_shader_parameter("radius")
	var time : float = abs(end - start) * MAX_DISSOLVE_DURATION
	if tween_dissolve:
		tween_dissolve.kill()
	tween_dissolve = create_tween().set_ease(Tween.EASE_IN)
	tween_dissolve.tween_method(_update_radius, start, end, time)

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
	
	if sacrificing_card:
		sacrifice_card()
	else:
		drop_card_on_tower()

func drop_card_on_tower() -> void:
	var spatial_object : Node3D = GV.mouse_3d_interaction.hovered_object
	if spatial_object != null:
		# match bahavior on spatial object
		if spatial_object is TowerBase:
			var hovered_tower : TowerBase = spatial_object
			hovered_tower.add_card(self)
			return
	return_to_hand()

func sacrifice_card() -> void:
	# interaction2D
	var control_object : Control = GV.mouse_2d_interaction.get_hovered_node()
	#print("control object = " + str(control_object))
	if control_object != null:
		if control_object.has_method("drop_card"):
			#print("card dropped on " + str(control_object))
			control_object.drop_card(card)
		destroy_card_object()
		return
	
	# interaction3D
	var spatial_object : Node3D = GV.mouse_3d_interaction.hovered_object
	if spatial_object != null:
		# match bahavior on spatial object
		if spatial_object is TowerBase:
			# ignore towers in sacrifice mode
			pass
		elif spatial_object is BaseEnemy:
			#TODO
			print_debug("TODO: handle card dropped on enemy")
		elif spatial_object is Spaceship:
			#TODO
			print_debug("TODO: handle card dropped on spaceship")
	return_to_hand()

func return_to_hand() -> void:
	tween_properties({
		"position" : deck_position,
		"rotation" : deck_rotation,
		"modulate" : Color.WHITE,
	})
	mouse_filter = Control.MOUSE_FILTER_PASS

func destroy_card_object() -> void:
	queue_free()
	if is_instance_valid(GV.hud):
		GV.hud.remove_card_from_hand(self)

func _on_mouse_entered() -> void:
	mouse_over_card = true
	CardDescription.add_card_description(self)
	tween_properties({
		"position" : Vector2(0.0, -20.0) + deck_position,
		"rotation" : 0.0
	})

func _on_mouse_exited() -> void:
	mouse_over_card = false
	if not is_dragged:
		tween_properties({
			"position" : deck_position,
			"rotation" : deck_rotation,
		})
