extends ColorRect
class_name InfoPopupBase


enum PopupTypes {
	Default,
	TowerPopup,
	SpaceshipPopup,
	EnemyPopup
}


const INFO_POPUP : Dictionary[PopupTypes, PackedScene]= {
	PopupTypes.Default : preload("res://scenes/interface/gameplay_hud/info_popups/info_popup.tscn"),
	PopupTypes.TowerPopup : preload("res://scenes/interface/gameplay_hud/info_popups/tower_info_popup.tscn"),
#	PopupTypes.SpaceshipPopup : preload("res://scenes/interface/gameplay_hud/info_popups/spaceship_info_popup.tscn"),
#	PopupTypes.EnemyPopup : preload("res://scenes/interface/gameplay_hud/info_popups/enemy_info_popup.tscn")
}

static var popups : Dictionary[Node, InfoPopupBase] = {}

static func reset_popups() -> void:
	popups.clear()

static func remove_all_popups() -> void:
	for popup : InfoPopupBase in popups.values():
		popup.close_popup()
	reset_popups()

static func add_popup(obj : Node) -> void:
	print_debug("PROBLEM WITH PARSING POPUP CLASS WITH ENEMY AND SPACESHIP POPUPS")
	var popup : InfoPopupBase
	if obj in popups.keys():
		popup = popups[obj]
	else:
		if obj is TowerBase:
			popup = INFO_POPUP[PopupTypes.TowerPopup].instantiate()
			var tower_popup : TowerInfoPopup = popup
			tower_popup.tower = obj
		elif obj is Spaceship:
			pass
			#popup = INFO_POPUP[PopupTypes.SpaceshipPopup].instantiate()
		elif obj is BaseEnemy:
			pass
			#popup = INFO_POPUP[PopupTypes.EnemyPopup].instantiate()
		else:
			print('obj type is unknown: ' + str(obj.get_class()))
			popup = INFO_POPUP[PopupTypes.Default].instantiate()
		popup.object = obj
		GV.hud.add_child(popup)
		popups[obj] = popup
	popup.position = popup.get_global_mouse_position() + Vector2(100, -50)


var object : Node
var object_name : String
var object_description : String


func _ready() -> void:
	$LabelTitle.text = object_name
	$LabelDescription.text = object_description
	popups[object] = self

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
