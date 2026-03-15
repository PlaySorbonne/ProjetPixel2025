extends GPUParticles3D
class_name UpgradeParticles


const UPGRADE_PARTICLES_RES := preload("res://scenes/world/vfx/upgrade_particles.tscn")


static func spawn_upgrade_particles(pos : Vector3) -> UpgradeParticles:
	var particles : UpgradeParticles = UPGRADE_PARTICLES_RES.instantiate()
	particles.position = pos
	GV.world.add_child(particles)
	return particles


func _on_finished() -> void:
	queue_free()
