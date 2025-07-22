extends Node
class_name Parser

static func get_command_name(text: String) -> String:
	var command_elements = text.split(" ")
	if len(command_elements) < 1: 
		return ""
	return command_elements[0]

# Séparer la commande de ses arguments / checker les erreurs
static func pre_parse(text: String) -> Dictionary[String, Variant]:
	var result: Dictionary[String, Variant] = {
		"command": "",
		"arguments": [],
		"error": false
	}
	var command_elements = text.split(" ")
	if len(command_elements) < 1: 
		result["error"] = true
		return result
	result["command"] = command_elements[0]
	if len(command_elements) > 1:
		result["arguments"] = command_elements.slice(1)
	return result

# Parser la commande
static func parse(text: String, logger: CommandsLogger) -> Command:
	var pre_parsed := Parser.pre_parse(text)
	var command_name: String = pre_parsed["command"]
	var command_arguments : Array = pre_parsed["arguments"]
	match command_name:
		"ping":
			return PingCommand.new(logger)
	return Command.new(true)
