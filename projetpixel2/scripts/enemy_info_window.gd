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
@onready var label_stats : Label = $Contents/LabelStatVals
@onready var label_name : Label = $Contents/ButtonEnemy


func _ready() -> void:
	super._ready()
	label_name.text = " " + enemy.enemy_data.enemy_type
	label_description.text = enemy.enemy_data.description
	label_power.text = "[Enemy power description (to add later)]"
	#tower.tower_card_added.connect(_add_card_infos)
	#tower.projectile_template.projectile_updated.connect(_update_tower_stats)
	#for card : CardData in tower.cards:
		#_add_card_infos(card)
	#_update_tower_stats()
	position = get_mouse_position()
	open_window()

func _update_enemy_stats() -> void:
	var stats_str := "- " + str(enemy.damageable.health) \
	+ "/" + str(enemy.damageable.max_health) + "\n- " \
	+ str(enemy.enemy_data.damage) + "\n- " \
	+ str(enemy.enemy_data.attack_speed) + "\n- " \
	+ str(enemy.enemy_data.defense) + "\n- " \
	+ str(enemy.enemy_data.speed)
	var weak_str := ""
	var res_str := ""
	for res : DamageableObject.DamagingTypes in enemy.enemy_data.resistances.keys():
		if enemy.enemy_data.resistances[res] < 0.0:
			if weak_str != "":
				weak_str += ", "
			res_str += str(res)
		elif enemy.enemy_data.resistances[res] > 0.0:
			if res_str != "":
				res_str += ", "
			res_str += str(res)
		#res_str += str(DamageableObject.DamagingTypes.keys()[res])
	stats_str += write_stats(res_str)
	stats_str += write_stats(weak_str)
	label_stats.text = stats_str

func write_stats(stats_str : String) -> String:
	var final_str : String
	if stats_str == "":
		final_str = "\n- None"
	else:
		final_str = "\n- " + stats_str
	return final_str
