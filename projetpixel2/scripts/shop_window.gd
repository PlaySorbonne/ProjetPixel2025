extends CasinoWindow
class_name ShopWindow


enum {
	ItemStandardBooster = 0,
	ItemSuperiorBooster = 1,
	ItemLargeBooster = 2,
	ItemPremiumBooster = 3,
	ItemDeluxeBooster = 4,
	ItemColossalBooster = 5,
	ItemPrestigeBooster = 6,
	ItemMasterworkBooster = 7,
	ItemTower = 0,
}

const SHOP_RES := preload("res://scenes/interface/casino_minigames/shop_window.tscn")
const TOWER_RES := preload("res://scenes/spaceship/towers/tower_base.tscn")
const SHOP_PRICE_RES := preload("res://scenes/interface/casino_minigames/sub_objects/label_shop_price.tscn")

static var last_shop_window : ShopWindow

static func spawn_shop_popup() -> ShopWindow:
	if last_shop_window:
		last_shop_window.close_window()
		last_shop_window = null
		return null
	else:
		var shop_popup : ShopWindow = SHOP_RES.instantiate()
		last_shop_window = shop_popup
		spawn_popup(shop_popup)
		return shop_popup


@export var prices : Array[int] = []

@onready var v_box_prices := $Contents/ScrollBoxItems/HBoxContainer/VBoxPrices
@onready var v_box_items := $Contents/ScrollBoxItems/HBoxContainer/VBoxItems
@onready var price_labels : Array[Label] = set_price_labels()
@onready var buy_message_label := $Contents/LabelBuyMessage
var message_tween : Tween


func _ready() -> void:
	super._ready()
	buy_message_label.scale = Vector2(0.5, 0.5)
	buy_message_label.modulate = Color.TRANSPARENT
	update_prices()
	$Contents/ScrollBoxItems.grab_focus()
	#await get_tree().process_frame
	#position = GV.hud.get_shop_pos()
	#open_window()

func set_price_labels() -> Array[Label]:
	var labels : Array[Label] = []
	for n : Node in v_box_items.get_children():
		if n is Button:
			var l : Label = SHOP_PRICE_RES.instantiate()
			v_box_prices.add_child(l)
			labels.append(l)
	return labels

func update_prices() -> void:
	if not v_box_prices:
		return
	for i : int in range(len(price_labels)):
		var l : Label = price_labels[i]
		l.text = str(prices[i]) + "$"

func get_shop_items() -> Array[Button]:
	var shop_items : Array[Button] = []
	for item : Node in v_box_items.get_children():
		if item is Button:
			shop_items.append(item)
	return shop_items

func refresh_shop_items() -> void:
	var shop_items : Array[Button] = get_shop_items()
	var items_visibility : Array[bool] = []
	items_visibility.resize(len(shop_items))
	for i : int in range(4):
		items_visibility[i] = true
	items_visibility.shuffle()
	for i : int in range(len(shop_items)):
		shop_items[i].visible = items_visibility[i]

func try_buy_item(item_price : int) -> bool:
	if RunData.current_chips >= item_price:
		RunData.current_chips -= item_price
		refresh_shop_items()
		display_message("Thank you for your patronage!", Color.GREEN)
		return true
	else:
		display_message("Not enough chips!", Color.RED)
		return false

func display_message(new_msg : String, msg_color : Color) -> void:
	buy_message_label.text = new_msg
	buy_message_label.scale = Vector2(0.5, 0.5)
	buy_message_label.modulate = Color.TRANSPARENT
	if message_tween:
		message_tween.kill()
	message_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	message_tween.tween_property(buy_message_label, "modulate", msg_color, 0.25)
	message_tween.tween_property(buy_message_label, "scale", Vector2.ONE, 0.25)
	$MessageTimer.start(2.0)

func _on_message_timer_timeout() -> void:
	var t := create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	t.tween_property(buy_message_label, "modulate", Color.TRANSPARENT, 0.25)
	t.tween_property(buy_message_label, "scale", Vector2(0.5, 0.5), 0.25)

func try_buy_booster(index : int, new_price : int, 
						booster_type : Booster.PackType) -> void:
	if try_buy_item(prices[index]):
		prices[index] = new_price
		update_prices()
		RareBooster.spawn_booster(GV.hud.booster_container, booster_type)

func add_tower() -> void:
	await get_tree().create_timer(0.1).timeout
	var tower_pos := GV.player_camera.project_position(
		Vector2(50, 50), 50.0)
	var new_tower := TOWER_RES.instantiate()
	new_tower.is_hologram = true
	GV.world.add_child(new_tower)
	new_tower.position = tower_pos

func _on_button_standard_booster_pressed() -> void:
	try_buy_booster(
		ItemStandardBooster,
		int(prices[ItemStandardBooster] + 2),
		Booster.PackType.Standard
	)

func _on_button_superior_booster_pressed() -> void:
	try_buy_booster(
		ItemSuperiorBooster,
		int(prices[ItemSuperiorBooster] + 4),
		Booster.PackType.Superior
	)

func _on_shop_large_booster_pressed() -> void:
	try_buy_booster(
		ItemLargeBooster,
		int(prices[ItemLargeBooster] + 7),
		Booster.PackType.Large
	)

func _on_button_premium_booster_pressed() -> void:
	try_buy_booster(
		ItemPremiumBooster,
		int(prices[ItemPremiumBooster] + 10),
		Booster.PackType.Premium
	)

func _on_button_deluxe_booster_pressed() -> void:
	try_buy_booster(
		ItemDeluxeBooster,
		int(prices[ItemDeluxeBooster] + 15),
		Booster.PackType.Deluxe
	)

func _on_button_colossal_booster_pressed() -> void:
	try_buy_booster(
		ItemColossalBooster,
		int(prices[ItemColossalBooster] * 1.2),
		Booster.PackType.Colossal
	)

func _on_button_prestige_booster_pressed() -> void:
	try_buy_booster(
		ItemPrestigeBooster,
		int(prices[ItemPrestigeBooster] * 1.1 + 4),
		Booster.PackType.Prestige
	)

func _on_button_masterwork_booster_pressed() -> void:
	try_buy_booster(
		ItemMasterworkBooster,
		int(prices[ItemMasterworkBooster] * 1.25 + 5),
		Booster.PackType.Masterwork
	)

func _on_button_tower_pressed() -> void:
	if try_buy_item(prices[ItemTower]):
		@warning_ignore("narrowing_conversion")
		prices[ItemTower] *= 1.5
		update_prices()
		add_tower()
