extends Command
class_name GiveCardCommand

var logger: CommandsLogger
var card: CardData
static var infos: Dictionary[String, String] = {
	"usage": "give-card <carte>",
	"description": "Ajoute la carte dans votre inventaire. Les noms sont insensibles à la casse, et les espaces doivent être remplacés par des underscores."
}

func _init(logger: CommandsLogger, card: CardData) -> void:
	super(false, "")
	self.logger = logger
	self.card = card

func execute():
	if GV.hud == null:
		logger.print("Erreur : vous n'êtes pas dans une partie.", logger.log_types.ERROR)
		return
	GV.hud.add_card_to_hand(card)
	logger.print("Carte " + card.name + " ajoutée à la main.")
	
