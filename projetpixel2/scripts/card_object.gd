extends Button
class_name CardObject


signal card_clicked

const FAMILY_COLORS := {
	CardData.CardFamilies.Military : Color.RED,
	CardData.CardFamilies.Scientists : Color.SKY_BLUE,
	CardData.CardFamilies.Traders : Color.YELLOW,
	CardData.CardFamilies.Revolution : Color.WHITE,
}

const CARD_OBJ_RES := preload("res://scenes/interface/cards/card_object.tscn")


static func create_card_object(card_data : CardData) -> CardObject:
	var new_card : CardObject = CARD_OBJ_RES.instantiate()
	new_card.card = card_data
	return new_card


var card : CardData:
	set(value):
		card = value
		$Label.text = card.name
		$TextureRect.self_modulate = FAMILY_COLORS[card.family]
var is_dragged := false
var can_be_dropped_on_objects := false:
	set(value):
		can_be_dropped_on_objects = value
var deck_position : Vector2


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
	deck_position = position
	$TextureRect.modulate = Color(1.0, 1.0, 1.0, 0.5)
	is_dragged = true
	GV.is_dragging_object = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_drag_and_drop_2d_dropped() -> void:
	#print("_on_drag_and_drop_2d_dropped")
	is_dragged = false
	GV.is_dragging_object = false
	$TextureRect.modulate = Color.WHITE
	if not can_be_dropped_on_objects:
		mouse_filter = Control.MOUSE_FILTER_PASS
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
	var tween := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC
				).set_ignore_time_scale(true).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS
				).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", deck_position, 0.175)
	mouse_filter = Control.MOUSE_FILTER_PASS

func destroy_card_object() -> void:
	queue_free()

func _on_mouse_entered() -> void:
	CardDescription.add_card_description(self)

func _on_mouse_exited() -> void:
	pass # Replace with function body.
