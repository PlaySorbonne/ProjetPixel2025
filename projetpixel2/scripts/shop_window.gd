extends CasinoWindow
class_name ShopWindow


const SHOP_RES := preload("res://scenes/interface/casino_minigames/shop_window.tscn")
const TOWER_RES := preload("res://scenes/spaceship/towers/tower_base.tscn")

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


@export var prices : Array[int] = [10, 13, 15]

@onready var buy_message_label := $Contents/LabelBuyMessage
var message_tween : Tween


func _ready() -> void:
	super._ready()
	await get_tree().process_frame
	position = GV.hud.get_shop_pos()
	buy_message_label.scale = Vector2(0.5, 0.5)
	buy_message_label.modulate = Color.TRANSPARENT
	open_window()

func try_buy_item(item_price : int) -> bool:
	if RunData.current_chips >= item_price:
		RunData.current_chips -= item_price
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

func _on_button_booster_pressed() -> void:
	if try_buy_item(prices[0]):
		Booster.spawn_booster(GV.hud.booster_container, Vector2(108, 11))

func _on_button_rare_booster_pressed() -> void:
	if try_buy_item(prices[1]):
		var b := Booster.spawn_booster(GV.hud.booster_container, Vector2(108, 11))
		b.set_family(Booster.BoosterFamilies.Spades)

func _on_button_tower_pressed() -> void:
	if try_buy_item(prices[2]):
		add_tower()

func add_tower() -> void:
	await get_tree().create_timer(0.1).timeout
	var tower_pos := GV.player_camera.project_position(
		Vector2(50, 50), 50.0)
	var new_tower := TOWER_RES.instantiate()
	new_tower.is_hologram = true
	GV.world.add_child(new_tower)
	new_tower.position = tower_pos
