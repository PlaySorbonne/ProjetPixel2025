extends InfoPopup
class_name EnemyInfoPopup


static var popup_res := load("res://scenes/interface/gameplay_hud/info_popups/enemy_info_popup.tscn")

var enemy_obj : BaseEnemy


func _ready() -> void:
	enemy_obj = object
	enemy_obj.enemy_hit.connect(update_enemy_health_infos)
	update_enemy_health_infos()

func update_enemy_health_infos() -> void:
	$LabelHealth.text = "Health:\n     " + str(enemy_obj.get_health()
									)+ "/" + str(enemy_obj.health)
