extends Node3D
class_name PersistentMenuWorld


enum CameraMarkers {main_menu, play_menu, collection_menu, title_screen}

@onready var camera_3d := $Camera3D
@onready var markers_dict : Dictionary[CameraMarkers, Marker3D] = {
	CameraMarkers.main_menu : $MarkerCamMainMenu,
	CameraMarkers.play_menu : $MarkerCamPlay,
	CameraMarkers.collection_menu : $MarkerCamCollection,
	CameraMarkers.title_screen : $MarkerCamTitle,
}


func _ready() -> void:
	GV.persistent_menu_world = self
	camera_3d.transform = markers_dict[CameraMarkers.title_screen].transform

func camera_movement(to_marker : Marker3D) -> void:
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(camera_3d, "position", to_marker.position, 0.3)
	tween.tween_property(camera_3d, "rotation", to_marker.rotation, 0.3)
