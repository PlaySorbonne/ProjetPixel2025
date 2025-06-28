extends RefCounted
class_name Command

var is_valid: bool
var name: String
var arguments: Array[String]
var logger: CommandsLogger

func _init(logger: CommandsLogger):
	self.logger = logger

static func get_command_name(text: String) -> String:
	var command_elements = text.split(" ")
	if len(command_elements) < 1: 
		return ""
	return command_elements[0]

func parse(command_string: String) -> void:
	pass

func execute() -> void:
	pass
