extends Command
class_name HelpCommand

var logger: CommandsLogger
static var infos: Dictionary[String, String] = {
	"usage": "help",
	"description": "Affiche ce message d'aide"
}

func _init(logger: CommandsLogger) -> void:
	super(false, "")
	self.logger = logger

func execute():
	logger.print("Commandes disponibles :")
	for command_infos in Parser.commands_infos.values():
		logger.print("[b]- " + command_infos["usage"] + "[/b]")
		logger.print("    " + command_infos["description"])
