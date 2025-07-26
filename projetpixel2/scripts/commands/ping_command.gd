extends Command
class_name PingCommand

var logger: CommandsLogger
static var infos: Dictionary[String, String] = {
	"usage": "ping",
	"description": "Affiche \"pong\""
}

func _init(logger: CommandsLogger) -> void:
	super(false, "")
	self.logger = logger

func execute():
	logger.print("pong")
