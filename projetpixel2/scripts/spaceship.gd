extends Node3D
class_name Spaceship


signal hit

## amount the shields will regen per 0.5 second
@export var shields_regeneration := 2
## delay before regen when shields are hit
@export var shields_regeneration_delay := 3.0
## delay before regen when shields are lost
@export var loss_shields_regeneration_delay := 9.0
## initial regen amount when shields are lost (between 0.0 and 1.0)
@export_range(0.0, 1.0, 0.01) var loss_shields_regeneration_amount := 0.15
var has_shields := true
var alive := true

var _update_shield_shaders_color := false
var _shield_shader_color : Color
var can_regenerate := true

# components
@onready var damageable : DamageableObject = $ShieldHealth
@onready var shield_shaders : MeshInstance3D = $ShieldShader
@onready var clickable : ClickableObject = $ClickableObject

func _ready() -> void:
	GV.space_ship = self

func _process(_delta: float) -> void:
	if _update_shield_shaders_color:
		shield_shaders.mesh.material.set_shader_parameter("color1", _shield_shader_color)

func get_health() -> int:
	return $ShipHealth.health

func get_shields() -> int:
	return $ShieldHealth.health

func shield_damage_animation() -> void:
	_update_shield_shaders_color = true
	var t := create_tween().set_ease(Tween.EASE_OUT)
	t.tween_property(self, "_shield_shader_color", Color(0.7, 0.13, 0.0, 0.024), 0.1)
	t.tween_property(self, "_shield_shader_color", Color(0.0, 1.0, 1.0, 0.024), 0.25)
	await t.finished
	_update_shield_shaders_color = false

func stop_all_towers() -> void:
	for tower : TowerBase in GV.towers:
		tower.set_tower_enable(false)

func _on_shield_health_hit(damage_amount: int, new_health: int, damage_type : DamageableObject.DamagingTypes) -> void:
	#print("shields hit for " + str(damage_amount) + " ; " + str(new_health) + " remaining")
	shield_damage_animation()
	hit.emit()

func _on_shield_health_death() -> void:
	$CollisionShip.disabled = true
	$ShieldShader.visible = false
	has_shields = false
	damageable = $ShipHealth
	$TimerShieldRegeneration.start(loss_shields_regeneration_delay)

func restore_shields() -> void:
	$CollisionShip.disabled = false
	has_shields = true
	damageable = $ShieldHealth
	damageable.health = damageable.max_health * loss_shields_regeneration_amount
	can_regenerate = true
	$TimerShieldRegeneration.wait_time = 0.5

func _on_ship_health_hit(damage_amount: int, new_health: int, damage_type : DamageableObject.DamagingTypes) -> void:
	#print("ship hit for " + str(damage_amount) + " ; " + str(new_health) + " remaining")
	hit.emit()

func death() -> void:
	if not alive:
		return
	alive = false
	visible = false
	stop_all_towers()
	var game_ober := preload("res://scenes/interface/menus/game_over_screen.tscn").instantiate()
	GV.hud.add_child(game_ober)

func _on_ship_health_death() -> void:
	death()

func _on_timer_shield_regeneration_timeout() -> void:
	if not has_shields:
		restore_shields()
	elif can_regenerate:
		if $ShieldHealth.health < $ShieldHealth.max_health:
			$ShieldHealth.health = min(
				$ShieldHealth.max_health, 
				$ShieldHealth.health + shields_regeneration
			)
	else:
		can_regenerate = true
		$TimerShieldRegeneration.wait_time = 0.5

func _on_hit() -> void:
	can_regenerate = false
	if has_shields:
		$TimerShieldRegeneration.start(shields_regeneration_delay)
	else:
		$TimerShieldRegeneration.start(loss_shields_regeneration_delay)
