extends Button
class_name CardObject


signal card_clicked

const FAMILY_COLORS := {
	CardData.CardFamilies.Military : Color.RED,
	CardData.CardFamilies.Scientists : Color.SKY_BLUE,
	CardData.CardFamilies.Traders : Color.YELLOW,
	CardData.CardFamilies.Revolution : Color.WHITE,
}

var card : CardData:
	set(value):
		card = value
		$Label.text = card.name
		$TextureRect.self_modulate = FAMILY_COLORS[card.family]
		$TextureRect/Description.text = card.description
var is_dragged := false
var can_be_dropped_on_objects := false:
	set(value):
		can_be_dropped_on_objects = value
		if can_be_dropped_on_objects:
			$TextureRect/Description.visible = false
		else:
			$TextureRect/Description.visible = true


func _on_button_down() -> void:
	print('button down')
	card_clicked.emit()
	$DragAndDrop2D.press()

func release_card() -> void:
	print("release_card")
	await get_tree().process_frame
	$DragAndDrop2D.was_just_pressed = false
	$DragAndDrop2D.release()
	is_dragged = true
	$DragAndDrop2D.drop()

func _process(_delta: float) -> void:
	return
	print("drag_and_drop.is_pressed = " + str(
$DragAndDrop2D.is_pressed) + " ; drag_and_drop.was_just_pressed = " + str(
$DragAndDrop2D.was_just_pressed) + " ; mouse = " + str(mouse_filter))

"""
"can_be_dropped_on_objects = "+ str(can_be_dropped_on_objects
) + " ; is_dragged = " + str(is_dragged) + " ; drag_and_drop.is_dragged = " + str(
$DragAndDrop2D.is_dragged) + 
"""

func _input(event: InputEvent) -> void:
	var debug_text := "INPUT DETECTED"
	if not is_dragged:
		debug_text += ("   not dragged -> return")
		print(debug_text)
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
	print(debug_text)

func _on_drag_and_drop_2d_dragged() -> void:
	print("_on_drag_and_drop_2d_dragged")
	$TextureRect.modulate = Color(1.0, 1.0, 1.0, 0.5)
	is_dragged = true
	GV.is_dragging_object = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	GV.hud.update_card_description(card.description)

func _on_drag_and_drop_2d_dropped() -> void:
	print("_on_drag_and_drop_2d_dropped")
	is_dragged = false
	GV.is_dragging_object = false
	GV.hud.clear_card_description()
	$TextureRect.modulate = Color.WHITE
	if not can_be_dropped_on_objects:
		print("HYAAAAAAAAAAAAAAH")
		mouse_filter = Control.MOUSE_FILTER_PASS
		return
	# interaction2D
	var control_object : Control = GV.mouse_2d_interaction.get_hovered_node()
	#print("control object = " + str(control_object))
	if control_object != null:
		if control_object.has_method("drop_card"):
			print("card dropped on " + str(control_object))
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
	
	# no interaction: return to original position
	#TODO
	#print_debug("TODO: return card to original pos if dropped on nothing")
	mouse_filter = Control.MOUSE_FILTER_PASS

func destroy_card_object() -> void:
	queue_free()
