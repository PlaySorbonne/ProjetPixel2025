extends Command
class_name GainLevelCommand

var logger: CommandsLogger

func _init(logger: CommandsLogger):
	super("gain-level", [])
	self.logger = logger
	self.infos = {
		"usage": "gain-level",
		"description": "Fait gagner un niveau au joueur"
	}

func execute(arguments: Array):
	logger.print("Level up!")
	GV.hud.gain_level(true)
