extends World
class_name WorldPerformanceTest


@export var enemy_to_test : PackedScene = preload("res://scenes/world/testing/minimal_enemy.tscn")
@export var enemies_per_second := 3.0
@export var enemies_per_spawn := 1
var time_since_last_spawn := 99999.0
var number_of_enemies := 0
var can_spawn_enemies := false
@onready var spawn_delay := (1.0 / enemies_per_second) * float(enemies_per_spawn)


func _ready() -> void:
	super._ready()
	await get_tree().create_timer(1.0).timeout
	can_spawn_enemies = true

func _process(delta: float) -> void:
	if not can_spawn_enemies:
		return
	time_since_last_spawn += delta
	if time_since_last_spawn > spawn_delay:
		time_since_last_spawn = 0.0
		spawn_enemy(enemies_per_spawn)

func spawn_enemy(nb_to_spawn := 1) -> void:
	number_of_enemies += nb_to_spawn
	print("SPAWN_ENEMY()")
	print("\tspawning " + str(nb_to_spawn) + " enemies")
	print("\tnumber_of_enemies = " + str(number_of_enemies))
	print("\taverage fps       = " + str(int(Engine.get_frames_per_second())))
	
	var spawner : EnemySpawner = GV.spawners.pick_random()
	for _i in range(nb_to_spawn):
		var enemy : Node3D = enemy_to_test.instantiate()
		add_child(enemy)
		enemy.position = spawner.position
