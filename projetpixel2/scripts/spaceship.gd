extends Node3D
class_name Spaceship

var shields := 500.0
var health := 100.0
var has_shields := true
var alive := true

var _update_shield_shaders_color := false
var _shield_shader_color : Color

# components
@onready var damageable : DamageableObject = $ShieldHealth
@onready var shield_shaders : MeshInstance3D = $ShieldShader
@onready var clickable : ClickableObject = $ClickableObject

func _ready() -> void:
	GV.space_ship = self

func _process(_delta: float) -> void:
	if _update_shield_shaders_color:
		shield_shaders.mesh.material.set_shader_parameter("color1", _shield_shader_color)

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

func _on_shield_health_hit(damage_amount: int, new_health: int) -> void:
	#print("shields hit for " + str(damage_amount) + " ; " + str(new_health) + " remaining")
	shield_damage_animation()

func _on_shield_health_death() -> void:
	$CollisionShip.disabled = true
	$ShieldShader.visible = false
	damageable = $ShipHealth

func _on_ship_health_hit(damage_amount: int, new_health: int) -> void:
	#print("ship hit for " + str(damage_amount) + " ; " + str(new_health) + " remaining")
	pass

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
