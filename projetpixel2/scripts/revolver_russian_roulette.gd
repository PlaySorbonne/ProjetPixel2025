extends Node3D
class_name RevolverRussianRoulette


signal revolver_shot(result : bool)

const BASE_PROBABILITY := 0.833333 # 5.0/6.0

@onready var animation_player : AnimationPlayer = $RevolverEmpty/AnimationPlayer


func _input(event):
	if event.is_action_pressed("ui_accept"):
		shoot_revolver()

func shoot_revolver() -> void:
	animation_player.play("spin")

func _fire() -> void:
	var success : bool = RunData.roll_probability(BASE_PROBABILITY)
	if success:
		animation_player.play("shoot_blank")
	else:
		animation_player.play("shoot_kill")
	revolver_shot.emit(success)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"spin":
			animation_player.play("shoot")
		"shoot":
			_fire()
		"shoot_blank":
			pass
