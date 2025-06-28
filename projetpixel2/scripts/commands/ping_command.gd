extends Command
class_name PingCommand

func _init(logger: CommandsLogger) -> void:
	super(logger)

func parse(text: String) -> void:
	var command_elements = text.split(" ")
	self.name = command_elements[0]

func execute():
	logger.print("pong")
