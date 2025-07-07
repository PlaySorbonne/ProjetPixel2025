extends MinimalEnemy


func _ready() -> void:
	super._ready()
	$"figurine-cube-detailed/AnimationPlayer".play("walk")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$"figurine-cube-detailed/AnimationPlayer".play("walk")
