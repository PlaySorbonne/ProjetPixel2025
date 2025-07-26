extends Command
class_name GiveCommand

var logger: CommandsLogger
var card: CardData

func _init(logger: CommandsLogger, card: CardData) -> void:
	super(false)
	self.logger = logger
	self.card = card

func execute():
	if GV.hud == null:
		logger.print("Erreur : vous n'êtes pas dans une partie.", logger.log_types.ERROR)
		return
	GV.hud.add_card_to_hand(card)
	logger.print("Carte " + card.name + " ajoutée à la main.")
