extends Submenu
class_name ResearchMenu


func _on_button_toggle_enemy_view_pressed() -> void:
	$ColorRect/AnatomicDrawing.visible = not $ColorRect/AnatomicDrawing.visible


func _on_button_wip_pressed() -> void:
	if $ColorRectResearchSlots.visible:
		$ColorRectResearchSlots.visible = false
		$ResearchButton.visible = false
		$EnemyStats.visible = true
		$EnemyDescription.visible = true
	else:
		$ColorRectResearchSlots.visible = true
		$ResearchButton.visible = true
		$EnemyStats.visible = false
		$EnemyDescription.visible = false
