extends Node


# game objects
var world : World = null
var space_ship : Spaceship = null
var towers : Array[TowerBase] = []
var spawners : Array[EnemySpawner] = []
var wave_manager : WaveManager = null
var hud : PlayerHud = null
var mouse_3d_interaction : Mouse3dInteraction = null
var mouse_2d_interaction : Mouse2DInteraction = null
var player_camera : PlayerCamera = null
var is_dragging_object := false
var persistent_menu : PersistentMenu = null
var persistent_menu_world : PersistentMenuWorld = null

# game parameters
var debug_mode : bool = false

func reset_gameplay_variables() -> void:
	world = null
	space_ship = null
	BaseEnemy.living_enemies.clear()
	towers = []
	spawners = []
	wave_manager = null
	hud = null
	mouse_3d_interaction = null
	mouse_2d_interaction = null
	player_camera = null
	is_dragging_object = false
