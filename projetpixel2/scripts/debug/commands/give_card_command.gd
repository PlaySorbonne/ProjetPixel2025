extends Command
class_name GiveCardCommand

var logger: CommandsLogger

func _init(logger: CommandsLogger) -> void:
	super("give-card", [
		EnumArgumentType.new(CardData.cards_data.keys())
	])
	self.logger = logger
	self.infos = {
		"usage": "give-card <carte>",
		"description": "Ajoute la carte dans votre inventaire. Les noms sont insensibles à la casse, et les espaces doivent être remplacés par des underscores."
	}

func execute(arguments: Array):
	if arguments[0] == "":
		logger.print("Erreur : la carte n'existe pas.", logger.log_types.ERROR)
		return
	var card: CardData = CardData.cards_data[arguments[0]]
	if GV.hud == null:
		logger.print("Erreur : vous n'êtes pas dans une partie.", logger.log_types.ERROR)
		return
	GV.hud.add_card_to_hand(card)
	logger.print("Carte " + card.name + " ajoutée à la main.")
	
