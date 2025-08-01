extends Node3D
class_name TowerMiningLaser


const MINING_LASER_RES := preload("res://scenes/spaceship/towers/projectiles/tower_mining_laser.tscn")


static func spawn_tower_mining_laser(pos : Vector3, xp_orb : ExperienceDrop) -> TowerMiningLaser:
	var mining_laser := MINING_LASER_RES.instantiate()
	GV.world.add_child(mining_laser)
	mining_laser.position = pos
	mining_laser._init_mine_object(xp_orb)
	return mining_laser


var focused_xp_object : ExperienceDrop


func destroy_laser() -> void:
	queue_free()

func _init_mine_object(xp_object : ExperienceDrop) -> void:
	focused_xp_object = xp_object
	var laser_dist : float = global_position.distance_to(xp_object.global_position)
	$LaserParent.look_at(xp_object.global_position)
	$GPUParticles3D.global_position = xp_object.global_position
	var t := create_tween().set_trans(Tween.TRANS_EXPO)
	t.tween_property($LaserParent, "scale", Vector3(1.0, 1.0, laser_dist), 0.2)

func _update_object_pos() -> void:
	$LaserParent.look_at(focused_xp_object.global_position)
	$LaserParent.scale = Vector3(
		1.0,
		1.0,
		global_position.distance_to(focused_xp_object.global_position)
	)
