extends Timer
class_name BoostFireRate


@export var fire_rate_multiplier := 1.5
@export var boost_duration := 1.0
@export var needed_shots := 20

@onready var tower : TowerBase = get_parent()
var in_boost := false
var current_shots := 0
var is_new_boost := true


func _ready() -> void:
	if not is_instance_valid(tower):
		print_debug("BoostFireRate component not attached to a tower")
		queue_free()
		return
	tower.tower_fired.connect(on_tower_killed_enemy)

func trigger_boost() -> void:
	if not in_boost:
		in_boost = true
		tower.fire_rate *= fire_rate_multiplier
	current_shots = 0
	start(boost_duration)

func _on_timeout() -> void:
	in_boost = false
	tower.fire_rate /= fire_rate_multiplier

func on_tower_killed_enemy(_projectile : ProjectileBase, _enemy : BaseEnemy) -> void:
	current_shots += 1
	if current_shots >= needed_shots:
		trigger_boost()
