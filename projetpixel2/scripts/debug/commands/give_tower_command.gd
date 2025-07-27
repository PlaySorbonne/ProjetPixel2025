extends Command
class_name GiveTowerCommand

var logger: CommandsLogger
var n: int = 1
static var infos: Dictionary[String, String] = {
	"usage": "give-tower [n]",
	"description": "Ajoute n tours à votre inventaire (ou une si n non spécifié)."
}

func _init(logger: CommandsLogger, n: int) -> void:
	super(false, "")
	self.logger = logger
	self.n = n

func execute():
	if GV.hud == null:
		logger.print("Erreur : vous n'êtes pas dans une partie.", logger.log_types.ERROR)
		return
	GV.hud.available_towers += n
	GV.hud.update_available_towers()
	logger.print(str(n) + " tour" + ("s" if n > 1 else "") + " ajoutée" + ("s" if n > 1 else "") + " à l'inventaire.")
