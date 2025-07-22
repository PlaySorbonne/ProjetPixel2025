extends Command
class_name GiveCommand

var logger: CommandsLogger
var Card: CardData

func _init(logger: CommandsLogger, card: CardArgument) -> void:
	super(false)
	self.logger = logger

func execute():
	# TODO: add card to hand
	pass
