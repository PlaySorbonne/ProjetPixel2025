extends Resource
class_name StatusBase

enum StatusEffects {Burning, Rooted, Poisoned, Bleeding, Frozen, Linked}

var status_type : StatusEffects


# abstract functions, to be implemented in status effects
func get_status_object_ref() -> PackedScene:
	print_debug("Implement get_object_ref() is child status effects!")
	return null

func stack_status_effect(effect_object : StatusObjectBase) -> void:
	print_debug("Implement stack_status_effect() is child status effects!")

func apply_effect(enemy : BaseEnemy) -> void:
	print_debug("Implement apply_effect() is child status effects!")

func inflict_status(enemy : BaseEnemy) -> void:
	var has_effect := false
	for effect_object : StatusObjectBase in enemy.status_effects:
		if effect_object.status.get_status_object_ref() == get_status_object_ref():
			stack_status_effect(effect_object)
			has_effect = true
			break
	if not has_effect:
		var status_object := get_status_object_ref().instantiate()
		status_object.status = self
		enemy.add_child(status_object)
		enemy.status_effects.append(status_object)
