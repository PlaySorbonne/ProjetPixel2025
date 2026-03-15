extends CasinoWindow
class_name SpaceshipInfoWindow


static var SPACESHIP_INFO_RES := load("res://scenes/interface/casino_minigames/spaceship_info_window.tscn")

static func spawn_spaceship_info_popup() -> SpaceshipInfoWindow:
	var popup : SpaceshipInfoWindow = SPACESHIP_INFO_RES.instantiate()
	popup.position = random_popup_position()
	spawn_popup(popup)
	return popup


func _ready() -> void:
	super._ready()
	GV.space_ship.hit.connect(self._update_stats)
	_update_stats()

func _update_stats() -> void:
	$Contents/LabelStats.text = \
	"Health: " + str(GV.space_ship.get_health()) + \
	"/" + str(GV.space_ship.get_max_health()) + \
	"Shields: " + str(GV.space_ship.get_shields()) + \
	"/" + str(GV.space_ship.get_max_shields())
	
