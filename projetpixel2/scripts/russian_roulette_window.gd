extends CasinoWindow
class_name RussianRouletteWindow


@onready var revolver : RevolverRussianRoulette = $Contents/SubViewportContainer/SubViewport/RevolverWorld/RevolverRussianRoulette


func _on_window_opened() -> void:
	await get_tree().create_timer(0.25).timeout
	revolver.shoot_revolver()

func _on_revolver_russian_roulette_revolver_shot(result: bool) -> void:
	if result:
		MessagePopupWindow.spawn_message_popup("Russian roulette won!")
	else:
		await get_tree().create_timer(0.35).timeout
		GV.space_ship.death()
	get_tree().create_timer(3.0).timeout.connect(close_window.bind(true))
