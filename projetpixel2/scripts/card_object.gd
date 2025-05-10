extends Button
class_name CardObject


signal card_clicked

const FAMILY_COLORS := {
	Card.CardFamilies.Military : Color.RED,
	Card.CardFamilies.Scientists : Color.SKY_BLUE,
	Card.CardFamilies.Traders : Color.YELLOW,
	Card.CardFamilies.Revolution : Color.WHITE,
}

var card : Card:
	set(value):	
		card = value
		$Label.text = card.name
		$TextureRect.self_modulate = FAMILY_COLORS[card.family]
var is_dragged := false


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
	if not is_dragged:
		return
	if event is InputEventMouseButton:
		if event.is_released():
			$DragAndDrop2D.release()
		else:
			$DragAndDrop2D.press()

func _on_drag_and_drop_2d_dragged() -> void:
	$TextureRect.modulate = Color(1.0, 1.0, 1.0, 0.5)
	is_dragged = true
	GV.is_dragging_object = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_drag_and_drop_2d_dropped() -> void:
	is_dragged = false
	GV.is_dragging_object = false
	$TextureRect.modulate = Color.WHITE
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
	print_debug("TODO: return card to original pos if dropped on nothing")
	mouse_filter = Control.MOUSE_FILTER_PASS

func destroy_card_object() -> void:
	queue_free()
