extends Node3D
class_name PersistentMenuWorld


@onready var camera_3d := $Camera3D
@onready var marker_cam_main_menu := $MarkerCamMainMenu
@onready var marker_cam_play := $MarkerCamPlay
@onready var marker_cam_collection := $MarkerCamCollection
@onready var marker_cam_title := $MarkerCamTitle


func _ready() -> void:
	GV.persistent_menu_world = self
	camera_3d.transform = marker_cam_title.transform

func camera_movement(to_marker : Marker3D) -> void:
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(camera_3d, "position", to_marker.position, 0.3)
	tween.tween_property(camera_3d, "rotation", to_marker.rotation, 0.3)
