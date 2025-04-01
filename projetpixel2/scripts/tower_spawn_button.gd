extends Control
class_name TowerSpawnButton


@export var tower_ref := preload("res://scenes/spaceship/towers/tower_base.tscn")


func _ready() -> void:
	pass
	#$Button.text = tower_ref.tower_name

func set_tower_ref(tower : PackedScene) -> void:
	tower_ref = tower
	$Button.text = tower.tower_name

func _on_button_pressed() -> void:
	var tower_obj : TowerBase = tower_ref.instantiate()
	GV.world.add_child(tower_obj)
