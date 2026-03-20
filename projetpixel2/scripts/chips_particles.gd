extends GPUParticles3D
class_name ChipsParticles


const CHIPS_PARTICLES_RES := preload("res://scenes/world/vfx/chips_particles.tscn")


static func spawn_chips_particles(p_amount : int) -> ChipsParticles:
	var particles : ChipsParticles = CHIPS_PARTICLES_RES.instantiate()
	particles.position = Vector3(0.0, 0.423, -0.509)
	particles.rotation_degrees = Vector3(90.0, 0, 0)
	particles.amount = p_amount
	GV.player_camera.add_child(particles)
	return particles


func _ready() -> void:
	emitting = true

func _on_finished() -> void:
	queue_free()
