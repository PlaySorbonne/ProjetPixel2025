extends Button
class_name ShopItemButton


var item_index := -1
var shop : ShopWindow
@export_multiline var description = ""
@export var price := 5
@export var price_increase := "* 1.5"


func _ready() -> void:
	mouse_entered.connect(_add_item_description)

func _add_item_description() -> void:
	ShopItemDescription.add_item_description(self, shop)
