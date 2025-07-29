extends Node
class_name CommandsRegistry

var commands: Dictionary[String, Command] = {}

func register_command(name: String, command: Command) -> void:
	commands.set(name, command)
	
func get_command(name: String) -> Command:
	return commands.get(name)

func get_commands() -> Array[Command]:
	return commands.values()
