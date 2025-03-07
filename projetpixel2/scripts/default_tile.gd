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
	GV.world.add_child(tile)
	tile.position = tile_position

var type : TileTypes = TileTypes.Rock

func set_type(new_type : TileTypes) -> void:
	type = new_type
	var hex_tile : Node3D = TILE_TYPES_RES[type].instantiate()
	self.add_child(hex_tile)
	hex_tile.position = Vector3(0.0, 1.0, 0.0)
	var t := create_tween().set_trans(Tween.TRANS_ELASTIC)
	t.tween_property(hex_tile, "position", Vector3.ZERO, 1.0)
