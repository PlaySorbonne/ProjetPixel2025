extends Command
class_name HelpCommand

var logger: CommandsLogger
var registry: CommandsRegistry

func _init(logger: CommandsLogger, registry: CommandsRegistry):
	super("help", [])
	self.logger = logger
	self.registry = registry
	self.infos = {
		"usage": "help",
		"description": "Affiche ce message d'aide"
	}

func execute(arguments: Array):
	logger.print("Commandes disponibles :")
	for command: Command in registry.get_commands():
		var command_infos = command.infos
		logger.print("[b]- " + command_infos["usage"] + "[/b]")
		logger.print("    " + command_infos["description"])
