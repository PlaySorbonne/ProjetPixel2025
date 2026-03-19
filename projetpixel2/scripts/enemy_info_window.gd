extends CasinoWindow
class_name EnemyInfoWindow


static var ENEMY_INFO_RES := load("res://scenes/interface/casino_minigames/enemy_info_window.tscn")

static func spawn_tower_info_popup(e : BaseEnemy) -> EnemyInfoWindow:
	var popup : EnemyInfoWindow = ENEMY_INFO_RES.instantiate()
	popup.enemy = e
	spawn_popup(popup)
	return popup

var enemy : BaseEnemy
@onready var label_description : Label = $Contents/LabelEnemyDescription
@onready var label_power : Label = $Contents/LabelEnemyPower
@onready var label_stats_1 : Label = $Contents/LabelEnemyPower


func _ready() -> void:
	super._ready()
	#tower.tower_card_added.connect(_add_card_infos)
	#tower.projectile_template.projectile_updated.connect(_update_tower_stats)
	#for card : CardData in tower.cards:
		#_add_card_infos(card)
	#_update_tower_stats()
	position = get_mouse_position()
	open_window()
