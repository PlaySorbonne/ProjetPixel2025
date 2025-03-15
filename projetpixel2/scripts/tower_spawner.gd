extends Node
class_name TowerSpawner

func spawn_tower(res : PackedScene, position : Vector3) -> TowerBase:
	var new_tower : TowerBase = res.instantiate()
	GV.world.add_child(new_tower)
	new_tower.position = position
	return new_tower
