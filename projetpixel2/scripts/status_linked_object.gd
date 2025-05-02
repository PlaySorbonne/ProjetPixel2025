extends StatusObjectBase
class_name StatusLinkedObject


func _ready() -> void:
	var status_linked : StatusLinked = status
	status_linked.apply_effect(enemy)
	enemy.enemy_killed.connect(on_enemy_death)
	status_linked.linked_enemies.append(self)

func _process(delta: float) -> void:
	print("linked_enemies := " + str(status.linked_enemies))

func on_enemy_death() -> void:
	for enemy : BaseEnemy in status.linked_enemies:
		enemy.death()

func _on_area_3d_body_entered(body: BaseEnemy) -> void:
	var is_body_linked := false
	for status_obj : StatusObjectBase in body.status_effects:
		if status_obj is StatusLinkedObject:
			is_body_linked = true
			break
	if not is_body_linked:
		status.inflict_status(enemy)
