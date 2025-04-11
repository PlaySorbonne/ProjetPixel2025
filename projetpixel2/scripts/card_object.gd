extends Button
class_name CardObject


var card := Card.new()
var tower : TowerBase
var projectile : ProjectileBase
var enemy : BaseEnemy


func execute_card() -> bool:
	# if trigger condition ok, execute effect
	if card.card_trigger_condition.execute([], self):
		for effect : Expression in card.effect:
			effect.execute([], self)
		return true
	else:
		return false

func _on_button_down() -> void:
	$DragAndDrop2D.press()

func _on_button_up() -> void:
	$DragAndDrop2D.release()

func _on_drag_and_drop_2d_dragged() -> void:
	$TextureRect.modulate = Color(1.0, 1.0, 1.0, 0.5)

func _on_drag_and_drop_2d_dropped() -> void:
	$TextureRect.modulate = Color.WHITE
	# interaction2D
	#TODO
	print_debug("TODO: handle card 2d interactions (other cards, buttons, etc)")
	
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
