extends StatusObjectBase
class_name StatusLinkedObject


func _ready() -> void:
	var status_linked : StatusLinked = status
	enemy.enemy_killed.connect(on_enemy_death)
	status_linked.linked_enemies.append(enemy)

func on_enemy_death() -> void:
	print("enemy death!")
	for enemy : BaseEnemy in status.linked_enemies:
		print("\tkill " + str(enemy))
		enemy.death()

func _on_area_3d_body_entered(body: BaseEnemy) -> void:
	if body.is_in_group("linked"):
		print("try to add body but no -> " + str(body))
		return
	print("add body -> " + str(body))
	body.add_to_group("linked")
	status.inflict_status(enemy)
