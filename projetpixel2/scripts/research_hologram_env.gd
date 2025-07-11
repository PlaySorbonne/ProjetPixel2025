extends SubViewport
class_name ResearchHologramEnv


const ROTATION_SPEED := 0.5

@onready var enemy : Node3D = $Node3D/enemy


func _process(delta: float) -> void:
	enemy.rotation.y += delta * ROTATION_SPEED
