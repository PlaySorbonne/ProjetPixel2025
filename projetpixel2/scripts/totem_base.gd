extends MeshInstance3D
class_name TotemBase


var tower : TowerBase


func trigger_effect() -> void:
	$TimeAfterTrigger.start()

func stack_totem() -> void:
	pass

func destroy_totem() -> void:
	queue_free()

func _on_time_after_trigger_timeout() -> void:
	destroy_totem()
