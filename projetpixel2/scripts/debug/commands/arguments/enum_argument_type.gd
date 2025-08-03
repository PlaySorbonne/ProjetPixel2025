extends ArgumentType
class_name EnumArgumentType

var options: Array[String]

func _init(enum_options: Array[String]):
	self.options = enum_options
	
func parse(value: String) -> String:
	var result := ""
	for option in self.options:
		var lower_name = option.to_lower().replacen(" ", "_")
		if lower_name == value.to_lower():
			result = option
			break
	return result
	
func get_completions() -> Array:
	return options.map(normalize_name)

func normalize_name(opt: String):
	return opt.to_lower().replacen(" ", "_")
