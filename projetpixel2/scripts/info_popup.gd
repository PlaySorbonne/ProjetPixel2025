extends ColorRect
class_name InfoPopup


static var popups : Dictionary[Node, InfoPopup] = {}

static func reset_popups() -> void:
	popups.clear()

static func remove_all_popups() -> void:
	for popup : InfoPopup in popups.values():
		popup.close_popup()
	reset_popups()

static func add_popup(obj : Node) -> void:
	var popup : InfoPopup
	if obj in popups.keys():
		popup = popups[obj]
	else:
		if obj is TowerBase:
			popup = TowerInfoPopup.popup_res.instantiate()
			var tower_popup : TowerInfoPopup = popup
			tower_popup.tower = obj
		elif obj is Spaceship:
			popup = SpaceshipInfoPopup.popup_res.instantiate()
		elif obj is BaseEnemy:
			popup = EnemyInfoPopup.popup_res.instantiate()
		else:
			print_debug('want to create popup for unknown object: ' + str(obj.get_class()))
			return
		popup.object = obj
		popups[obj] = popup
		GV.hud.add_child(popup)
	popup.position = popup.get_global_mouse_position() + Vector2(100, -50)


var object : Node


func _on_close_button_pressed() -> void:
	popups.erase(object)
	close_popup()

func close_popup() -> void:
	queue_free()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			$DragAndDrop2D.press()
		else:
			$DragAndDrop2D.release()
