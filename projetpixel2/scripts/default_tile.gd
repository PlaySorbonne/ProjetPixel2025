extends Node3D
class_name DefaultTile

enum TileTypes {Rock, Sand, Water}

const DEFAULT_TILE_RES = preload("res://scenes/world/levels/tiles/default_tile.tscn")
const TILE_TYPES_RES : Dictionary[TileTypes, Resource] = {
	TileTypes.Rock : preload("res://resources/3d_models/tiles/hex_rock.fbx"),
	TileTypes.Sand : preload("res://resources/3d_models/tiles/hex_sand.fbx"),
	TileTypes.Water : preload("res://resources/3d_models/tiles/hex_water.fbx"),
}

static func spawn_tile(tile_position : Vector3, tile_type : TileTypes = TileTypes.Rock) -> void:
	var tile : DefaultTile = DEFAULT_TILE_RES.instantiate()
	tile.set_type(tile_type)
	
	tile.position = tile_position

var type : TileTypes = TileTypes.Rock

func set_type(new_type : TileTypes) -> void:
	type = new_type
	add_child(TILE_TYPES_RES[type].instantiate())
