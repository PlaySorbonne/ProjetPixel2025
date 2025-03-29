extends Node3D
class_name World

func _ready() -> void:
	GV.world = self
	RunData.reset_run_data()
