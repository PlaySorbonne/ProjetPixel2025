extends CasinoWindow
class_name ShopWindow


const SHOP_RES := preload("res://scenes/interface/casino_minigames/shop_window.tscn")

static func spawn_shop_popup() -> ShopWindow:
	var shop_popup : ShopWindow = SHOP_RES.instantiate()
	spawn_popup(shop_popup)
	return shop_popup
