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

# Renvoie null si erreur
static func parse_card_argument(text: String) -> CardData:
	for card_name in CardData.cards_data.keys():
		var lower_name = card_name.to_lower().replacen(" ", "_")
		if lower_name == text.to_lower():
			return CardData.cards_data[card_name]
	return null

# Parse command
static func parse(text: String, logger: CommandsLogger) -> Command:
	var pre_parsed := Parser.pre_parse(text)
	var command_name: String = pre_parsed["command"]
	var command_arguments : Array = pre_parsed["arguments"]
	match command_name:
		"ping":
			return PingCommand.new(logger)
		"give":
			if len(command_arguments) > 1 or len(command_arguments) == 0:
				return Command.new(true) # TODO: add an error message argument to the Give command to get the right error message
			var card := parse_card_argument(command_arguments[0])
			if card == null:
				return Command.new(true)
			return GiveCommand.new(logger, card)
	return Command.new(true) # true here is "error = true" (godot really need an error handling system.........)
