extends Resource
class_name CardBase

# Auras, Explosions and Totems
const AURA_BURNING := preload("res://scenes/spaceship/towers/spawnable_objects/aura_burning.tscn")
const EXPLOSION_DAMAGE := preload("res://scenes/spaceship/towers/spawnable_objects/explosion_damage.tscn")
const EXPLOSION_ROOT := preload("res://scenes/spaceship/towers/spawnable_objects/explosion_root.tscn")
const TOTEM_SHOOT := preload("res://scenes/spaceship/towers/spawnable_objects/totem_shoot.tscn")

# Tower Boosts
const BOOST_FIRE_RATE := preload("res://scenes/spaceship/towers/components/boost_fire_rate.tscn")

# active variables
var tower : TowerBase # tower the card was added to
var projectile : ProjectileBase # projectile that trigger the card (can be null if card was not triggered by a projectile)
var enemy : BaseEnemy # enemy that triggered the card (can be null if card was not triggered by an enemy)

# GAME DESIGNER FUNCTIONS
func spawn_burning_aura(aura_position : Vector3) -> BurningAura:
	return spawn_object(AURA_BURNING.instantiate(), aura_position)

func spawn_burning_aura_on_obj(parent_object : Node3D, offset := Vector3.ZERO) -> BurningAura:
	return spawn_object_on_object(AURA_BURNING.instantiate(), parent_object, offset)

func spawn_damage_explosion(explosion_position : Vector3) -> ExplosionDamage:
	return spawn_object(EXPLOSION_DAMAGE.instantiate(), explosion_position)

func spawn_damage_explosion_on_obj(parent_object : Node3D, offset := Vector3.ZERO) -> ExplosionDamage:
	return spawn_object_on_object(EXPLOSION_DAMAGE.instantiate(), parent_object, offset)


func get_component(object : Node, component : Resource) -> Node:
	for c : Node in object.get_children():
		if is_instance_of(c, component):
			return c
	return null


func spawn_object(object : Node3D, location : Vector3) -> Node3D:
	GV.world.add_child(object)
	object.position = location
	return object

func spawn_object_on_object(object : Node3D, parent_object : Node3D, 
				offset := Vector3.ZERO) -> Node3D:
	parent_object.add_child(object)
	object.position = offset
	return object
