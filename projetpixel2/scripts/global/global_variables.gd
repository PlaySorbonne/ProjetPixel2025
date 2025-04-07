extends Node


# game objects
var world : World = null
var space_ship : Spaceship = null
var towers : Array[TowerBase] = []
var spawners : Array[EnemySpawner] = []
var wave_manager : WaveManager = null
var hud : PlayerHud = null
var mouse_3d_interaction : Mouse3dInteraction = null


func reset_gameplay_variables() -> void:
	world = null
	space_ship = null
	towers = []
	spawners = []
	wave_manager = null
	hud = null
	mouse_3d_interaction = null
