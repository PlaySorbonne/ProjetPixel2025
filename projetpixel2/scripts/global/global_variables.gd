extends Node

var world : World
var space_ship : Spaceship
var towers : Array[TowerBase] = []
var spawners : Array[EnemySpawner] = []

func reset_gameplay_variables() -> void:
	world = null
	space_ship = null
	towers = []
	spawners = []
