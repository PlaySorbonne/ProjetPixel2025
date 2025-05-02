extends Resource
class_name CardBase

const BURNING_AURA := preload("res://scenes/spaceship/towers/spawnable_objects/burning_aura.tscn")


# active variables
var tower : TowerBase
var projectile : ProjectileBase
var enemy : BaseEnemy

# GAME DESIGNER FUNCTIONS
func spawn_burning_aura(aura_position : Vector3) -> BurningAura:
	return spawn_object(BURNING_AURA.instantiate(), aura_position)

func spawn_burning_aura_on_obj(parent_object : Node3D, 
									offset := Vector3.ZERO) -> BurningAura:
	return spawn_object_on_object(BURNING_AURA.instantiate(), parent_object, offset)




func spawn_object(object : Node3D, location : Vector3) -> Node3D:
	GV.world.add_child(object)
	object.position = location
	return object

func spawn_object_on_object(object : Node3D, parent_object : Node3D, 
				offset := Vector3.ZERO) -> Node3D:
	parent_object.add_child(object)
	object.position = offset
	return object
