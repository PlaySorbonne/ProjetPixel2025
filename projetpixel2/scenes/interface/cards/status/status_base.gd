extends Resource
class_name StatusBase

enum StatusEffects {Burning, Rooted, Poisoned, Bleeding, Frozen}

var status_type : StatusEffects


# abstract functions, to be implemented in status effects
func get_status_object_ref() -> PackedScene:
	print_debug("Implement get_object_ref() is child status effects!")
	return null

func stack_status_effect() -> void:
	print_debug("Implement stack_status_effect() is child status effects!")

func apply_effect() -> void:
	print_debug("Implement apply_effect() is child status effects!")

func infict_status(enemy : BaseEnemy) -> void:
	var has_effect := false
	for effect : StatusObjectBase in enemy.status_effects:
		if effect.status_type == status_type:
			has_effect = true
			break
	if has_effect:
		pass
	else:
		var status_object := get_status_object_ref().instantiate()
		status_object.status = self
		enemy.add_child(status_object)
