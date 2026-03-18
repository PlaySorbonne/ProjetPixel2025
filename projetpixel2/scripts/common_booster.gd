extends Booster
class_name CommonBooster


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	super._on_animation_player_animation_finished(_anim_name)
	GV.hud.cards_container.booster_cards_spawned.connect(_on_cards_spawned)
	draw_cards()

func _on_cards_spawned(booster : Booster) -> void:
	if booster != self:
		return
	destroy_booster()
