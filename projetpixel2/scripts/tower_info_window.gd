extends CasinoWindow
class_name TowerInfoWindow


const CARD_INFOS := preload("res://scenes/interface/gameplay_hud/info_popups/card_infos.tscn")


var tower : TowerBase
@onready var cards_container := $Contents/ScrollContainer/VBoxContainer
@onready var label_stat_vals_1 := $Contents/LabelStatsVals1
@onready var label_stat_vals_2 := $Contents/LabelStatsVals2


func _ready() -> void:
	super._ready()
	tower.tower_card_added.connect(_add_card_infos)
	tower.projectile_updated.connect(_update_tower_stats)
	for card : CardData in tower.cards:
		_add_card_infos(card)
	_update_tower_stats()

func _update_tower_stats() -> void:
	label_stat_vals_1.text = \
	str(tower.projectile_template.damage)  + "\n"\
	+ str(tower.projectile_template.speed) + "\n"\
	+ str(tower.projectile_template.size)  + "\n"\
	+ str(tower.projectile_template.critical_hit_chance)
	label_stat_vals_2.text = \
	str(tower.projectile_template.critical_hit_intensity) + "\n"\
	+ str(tower.projectile_template.pierce) + "\n"\
	+ str(tower.projectile_template.bounce) + "\n"\
	+ str(tower.projectile_template.damage_type) 
	

func _add_card_infos(new_card : CardData) -> void:
	var card_infos := CARD_INFOS.instantiate()
	card_infos.card = new_card
	cards_container.add_child(card_infos)
