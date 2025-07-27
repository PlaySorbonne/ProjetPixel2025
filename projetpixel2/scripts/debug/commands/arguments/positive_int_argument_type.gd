extends ArgumentType
class_name PositiveIntArgumentType
	
func parse(value: String) -> int:
	var n = value.to_int()
	if n < 1:
		return -1
	return n
