extends CasinoWindow
class_name ShopWindow


const SHOP_RES := preload("res://scenes/interface/casino_minigames/shop_window.tscn")

static func spawn_shop_popup() -> ShopWindow:
	var shop_popup : ShopWindow = SHOP_RES.instantiate()
	spawn_popup(shop_popup)
	return shop_popup


@export var prices : Array[int] = [10, 13, 15]


func try_buy_item(item_price : int) -> bool:
	if RunData.current_chips >= item_price:
		RunData.current_chips -= item_price
		return true
	else:
		return false

func _on_button_booster_pressed() -> void:
	if try_buy_item(prices[0]):
		Booster.spawn_booster($BoosterContainer, Vector2(108, 11))

func _on_button_rare_booster_pressed() -> void:
	if try_buy_item(prices[1]):
		Booster.spawn_booster($BoosterContainer, Vector2(108, 11))

func _on_button_tower_pressed() -> void:
	if try_buy_item(prices[2]):
		Booster.spawn_booster($BoosterContainer, Vector2(108, 11))
