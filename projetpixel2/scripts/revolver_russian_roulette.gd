extends MeshInstance3D
class_name RevolverRussianRoulette


signal revolver_shot(result : bool)


func _input(event):
	if event.is_action_pressed("ui_accept"):
		pass

func shoot_revolver() -> void:
	pass

func _ready() -> void:
	pass
