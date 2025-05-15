extends InfoPopup
class_name SpaceshipInfoPopup


static var popup_res := load("res://scenes/interface/gameplay_hud/info_popups/spaceship_info_popup.tscn")


func _ready() -> void:
	GV.space_ship.hit.connect(self.update_ship_health_infos)
	update_ship_health_infos()

func update_ship_health_infos() -> void:
	print("UPDATE THINGY UI")
	$LabelHealth.text = "Health:\n     " + str(GV.space_ship.get_health()
											) + "/" + str(GV.space_ship.max_health)
	$LabelShields.text = "Shields:\n     " + str(GV.space_ship.get_shields()
											) + "/" + str(GV.space_ship.max_shields)
