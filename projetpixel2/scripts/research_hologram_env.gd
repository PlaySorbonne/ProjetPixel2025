extends SubViewport
class_name ResearchHologramEnv


const ROTATION_SPEED := 0.5

@onready var enemy : Node3D = $Node3D/enemy


func _ready() -> void:
	if not is_instance_valid(enemy):
		set_process(false)
		push_warning("Enemy not valid in ResearchHologramEnv.")
		print_debug("Enemy not valid in ResearchHologramEnv.")

func _process(delta: float) -> void:
	enemy.rotation.y += delta * ROTATION_SPEED
