extends Button
class_name CardObject


signal card_clicked

const FAMILY_COLORS := {
	CardData.CardFamilies.Military : Color.RED,
	CardData.CardFamilies.Scientists : Color.SKY_BLUE,
	CardData.CardFamilies.Traders : Color.YELLOW,
	CardData.CardFamilies.Revolution : Color.WHITE,
}
const ANIM_TIME := 0.175
const CARD_OBJ_RES := preload("res://scenes/interface/cards/card_object.tscn")


static func create_card_object(card_data : CardData) -> CardObject:
	var new_card : CardObject = CARD_OBJ_RES.instantiate()
	new_card.card = card_data
	return new_card


var card : CardData
var is_dragged := false
var can_be_dropped_on_objects := false
var deck_position : Vector2
var deck_rotation : float
var card_tweens : Dictionary[String, Tween] = {}


func _ready() -> void:
	await get_tree().process_frame
	$Label.text = card.name
	$TextureRect.self_modulate = FAMILY_COLORS[card.family]
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
	card_clicked.emit()
	$DragAndDrop2D.press()

func release_card() -> void:
	await get_tree().process_frame
	$DragAndDrop2D.was_just_pressed = false
	$DragAndDrop2D.release()
	is_dragged = true
	$DragAndDrop2D.drop()

func _input(event: InputEvent) -> void:
	var debug_text := "INPUT DETECTED"
	if not is_dragged:
		debug_text += ("   not dragged -> return")
		#print(debug_text)
		return
	if event is InputEventMouseButton:
		if event.is_released():
			$DragAndDrop2D.release()
			debug_text += ("   release")
		else:
			$DragAndDrop2D.press()
			debug_text += ("   press")
	else:
		debug_text += ("   event is not InputEventMouseButton")
	#print(debug_text)

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
			var hovered_tower : TowerBase = spatial_object
			hovered_tower.add_card(self)
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
	CardDescription.add_card_description(self)
	tween_properties({
		"position" : Vector2(0.0, -20.0) + deck_position,
		"rotation" : 0.0
	})

func _on_mouse_exited() -> void:
	if not is_dragged:
		tween_properties({
			"position" : deck_position,
			"rotation" : deck_rotation,
		})
