extends Command
class_name GiveCommand

var logger: CommandsLogger
var card: CardData

func _init(logger: CommandsLogger, card: CardData) -> void:
	super(false)
	self.logger = logger
	self.card = card

func execute():
	# TODO: add card to hand
	pass
