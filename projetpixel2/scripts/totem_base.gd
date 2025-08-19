extends Node3D
class_name TotemBase


var tower : TowerBase


func trigger_effect() -> void:
	pass

func stack_totem() -> void:
	pass

func destroy_totem() -> void:
	queue_free()
