extends ColorRect
class_name InfoPopup


static var popups : Dictionary[Node, CasinoWindow] = {}

static func reset_popups() -> void:
	popups.clear()

static func remove_all_popups() -> void:
	for popup : CasinoWindow in popups.values():
		popup.close_window()
	reset_popups()

static func add_popup(obj : Node) -> void:
	var popup : Node
	if obj in popups.keys():
		popup = popups[obj]
		if is_instance_valid(popup):
			popup.close_window()
		popups.erase(obj)
	else:
		if obj is TowerBase:
			popup = TowerInfoWindow.spawn_tower_info_popup(obj)
		elif obj is Spaceship:
			popup = SpaceshipInfoWindow.spawn_spaceship_info_popup()
		elif obj is BaseEnemy:
			popup
		else:
			print_debug('trying to create popup for unknown object: ' + str(obj.get_class()))
			return
		popups[obj] = popup


var object : Node
var is_mouse_over_popup := false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		close_popup()

func _on_close_button_pressed() -> void:
	close_popup()

func close_popup() -> void:
	popups.erase(object)
	queue_free()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			$DragAndDrop2D.press()
		else:
			$DragAndDrop2D.release()
