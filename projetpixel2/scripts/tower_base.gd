extends Node3D
class_name TowerBase


var focused_enemies : Array[BaseEnemy] = []


func shoot(enemy : BaseEnemy) -> void:
	look_at(enemy.position)
	

func _process(delta: float) -> void:
	if len(focused_enemies) > 0:
		shoot(focused_enemies[0])

func _on_body_entered(body: Node3D) -> void:
	if body is BaseEnemy:
		focused_enemies.append(body)
