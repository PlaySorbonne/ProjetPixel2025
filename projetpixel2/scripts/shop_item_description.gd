extends ObjectDescription
class_name ShopItemDescription


const ITEM_DESCRIPTION_RES := preload("res://scenes/interface/descriptions/shop_item_description.tscn")

static func add_item_description(n_shop_item : ShopItemButton, nshop : ShopWindow) -> ShopItemDescription:
	var item_description : ShopItemDescription = ITEM_DESCRIPTION_RES.instantiate()
	item_description.shop_item = n_shop_item
	item_description.shop = nshop
	item_description._init_description_popup(n_shop_item)
	return item_description


var shop_item : ShopItemButton = null
var shop : ShopWindow = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	await get_tree().process_frame
	$LabelTitle.text = shop_item.text
	$LabelDescription.text = shop_item.description
	$LabelCurrentPrice.text = "Starting: " + str(shop_item.price)
	$LabelPriceIncrease.text = "Increase: " + str(shop_item.price_increase)
