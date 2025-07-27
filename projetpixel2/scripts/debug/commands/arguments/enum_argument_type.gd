extends ArgumentType
class_name EnumArgumentType

var options: Array[String]

func _init(enum_options: Array[String]):
	self.options = enum_options
	
func parse(value: String) -> String:
	for option in self.options:
		if value.to_lower() == option:
			return value.to_lower()
	return ""
	
func get_completions() -> Array[String]:
	return options
