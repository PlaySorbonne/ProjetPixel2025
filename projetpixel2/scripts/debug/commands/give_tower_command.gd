extends Command
class_name GiveTowerCommand

var logger: CommandsLogger

func _init(logger: CommandsLogger) -> void:
	super("give-tower", [PositiveIntArgumentType.new()])
	self.logger = logger
	self.infos = {
		"usage": "give-tower <n>",
		"description": "Ajoute n tours à votre inventaire"
	}

func execute(arguments: Array):
	var n = arguments[0]
	if n <= 0:
		logger.print("Erreur : le nombre doit être un entier positif.", logger.log_types.ERROR)
		return
	if GV.hud == null:
		logger.print("Erreur : vous n'êtes pas dans une partie.", logger.log_types.ERROR)
		return
	GV.hud.available_towers += n
	GV.hud.update_available_towers()
	logger.print(str(n) + " tour" + ("s" if n > 1 else "") + " ajoutée" + ("s" if n > 1 else "") + " à l'inventaire.")
