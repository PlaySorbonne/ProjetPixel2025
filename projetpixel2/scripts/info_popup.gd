extends ColorRect
class_name InfoPopup

const INFO_POPUP := preload("res://scenes/interface/gameplay_hud/info_popup.tscn")

static var popups : Dictionary[Node,InfoPopup] = {}

static func reset_popups() -> void:
	popups.clear()

static func add_popup(obj : Node) -> void:
	var popup : InfoPopup
	if obj in popups.keys():
		popup = popups[obj]
	else:
		popup = INFO_POPUP.instantiate()
		popup.object = obj
		popup.object_name = str(obj).left(str(obj).find(":"))
		popup.object_description = "3D object description descriptino description"
		GV.hud.add_child(popup)
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
	queue_free()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			$DragAndDrop2D.press()
		else:
			$DragAndDrop2D.release()
