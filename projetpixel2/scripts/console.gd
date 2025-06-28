extends Control
class_name Console

@onready var prompt: LineEdit = $VBoxContainer/Prompt
@onready var logs: CommandsLogger = $VBoxContainer/Logs
@onready var commands: Dictionary[String, Command] = {
	"ping": PingCommand.new(logs)
}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if prompt.has_focus():
			var command_text = prompt.text
			prompt.clear()
			var command_name = Command.get_command_name(command_text)
			var command = commands.get(command_name, null)
			if command == null:
				logs.print("erreur !!", logs.log_types.ERROR)
				return
			command.parse(command_text)
			command.execute()
			
