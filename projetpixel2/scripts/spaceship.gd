extends Node3D
class_name Spaceship

var shields := 500.0
var health := 100.0
var has_shields := true

var _update_shield_shaders_color := false
var _shield_shader_color : Color

@onready var damagable : DamagableObject = $ShieldBody/ShieldHealth
@onready var shield_shaders : MeshInstance3D = $ShieldShader

func _ready() -> void:
	GV.space_ship = self

func _process(_delta: float) -> void:
	if _update_shield_shaders_color:
		shield_shaders.material.set_shader_parameter("color_1", _shield_shader_color)

func shield_damage_animation() -> void:
	_update_shield_shaders_color = true
	var t := create_tween().set_ease(Tween.EASE_OUT)
	t.tween_property(self, "_shield_shader_color", Color(0.7, 0.13, 0.0, 0.024), 0.1)
	t.tween_property(self, "_shield_shader_color", Color(0.0, 1.0, 1.0, 0.024), 0.25)
	await t.finished
	_update_shield_shaders_color = false
