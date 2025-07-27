extends Node
class_name Parser

static var commands_infos: Dictionary[String, Dictionary] = {
	"help": HelpCommand.infos,
	"ping": PingCommand.infos,
	"give-card": GiveCardCommand.infos,
	"give-tower": GiveTowerCommand.infos,
}

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

static func parse_positive_int_argument(text: String) -> int:
	var value = text.to_int()
	if value < 1:
		return -1
	return value

# Parse command
static func parse(text: String, logger: CommandsLogger) -> Command:
	var pre_parsed := Parser.pre_parse(text)
	var command_name: String = pre_parsed["command"]
	var command_arguments : Array = pre_parsed["arguments"]
	match command_name:
		"help":
			return HelpCommand.new(logger)
		"ping":
			return PingCommand.new(logger)
		"give-card":
			if len(command_arguments) > 1 or len(command_arguments) == 0:
				logger.error()
				return Command.new(true, "Usage : " + GiveCardCommand.infos["usage"])
			var card := parse_card_argument(command_arguments[0])
			if card == null:
				return Command.new(true, "Usage : " + GiveCardCommand.infos["usage"])
			return GiveCardCommand.new(logger, card)
		"give-tower":
			if len(command_arguments) > 1:
				return Command.new(true, "Usage : " + GiveTowerCommand.infos["usage"])
			if len(command_arguments) == 0:
				return GiveTowerCommand.new(logger, 1)
			var n = Parser.parse_positive_int_argument(command_arguments[0])
			if n == -1:
				return Command.new(true, "Erreur : l'argument n'est pas un entier positif valide")
			return GiveTowerCommand.new(logger, n)
	return Command.new(true, "Erreur: cette command n'existe pas.") # true here is "error = true" (godot really need an error handling system.........)
