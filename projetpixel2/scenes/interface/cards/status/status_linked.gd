extends StatusBase
class_name StatusLinked


var linked_enemies : Array[BaseEnemy] = []


func get_status_object_ref() -> PackedScene:
	return preload("res://scenes/interface/cards/status/status_linked_object.tscn")

func stack_status_effect(effect_object : StatusObjectBase) -> void:
	var status_linked : StatusLinked = effect_object.status

func apply_effect(enemy : BaseEnemy) -> void:
	pass
