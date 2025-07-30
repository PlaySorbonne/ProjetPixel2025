extends Node3D
class_name TowerMiningLaser


var focused_xp_object : ExperienceDrop


func _process(_delta: float) -> void:
	if is_instance_valid(focused_xp_object):
		if focused_xp_object.marked_for_deletion:
			_update_object_pos()

func mine_object(xp_object : ExperienceDrop) -> void:
	focused_xp_object = xp_object
	var laser_dist : float = global_position.distance_to(xp_object.global_position)
	$LaserParent.look_at(xp_object.global_position)
	var t := create_tween().set_trans(Tween.TRANS_EXPO)
	t.tween_property($LaserParent, "scale", Vector3(laser_dist, 1.0, 1.0), 0.1)

func _update_object_pos() -> void:
	$LaserParent.look_at(focused_xp_object.global_position)
	$LaserParent.scale = Vector3(
		global_position.distance_to(focused_xp_object.global_position),
		1.0,
		1.0
	)
