extends Command
class_name PingCommand

var logger: CommandsLogger

func _init(logger: CommandsLogger) -> void:
	super(false)
	self.logger = logger

func execute():
	logger.print("pong")
