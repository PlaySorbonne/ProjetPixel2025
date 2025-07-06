extends Control
class_name Console

@onready var prompt: LineEdit = $VBoxContainer/Prompt
@onready var logger: CommandsLogger = $VBoxContainer/Logs

var pre_parsing: Dictionary[String, Variant]
var commands_history: Array[String] = []
var history_index = 0
var is_tab_selecting = false

func _input(event: InputEvent) -> void:
	if prompt.has_focus():
		if Input.is_key_pressed(KEY_ENTER):
			var command_text = prompt.text
			prompt.text = ""
			var pre_parsing = Parser.pre_parse(command_text)
			var command_name: String = pre_parsing["command"]
			if pre_parsing.error:
				await get_tree().process_frame
				prompt.release_focus()
				prompt.grab_focus()
				return
			var command = Parser.parse(command_text, logger)
			if command.error:
				commands_history.append(command_text)
				logger.print("Erreur : cette commande n'existe pas.", logger.log_types.ERROR)
				await get_tree().process_frame
				prompt.release_focus()
				prompt.grab_focus()
				return
			command.execute()
			commands_history.append(command_text)
			await get_tree().process_frame
			prompt.release_focus()
			prompt.grab_focus()
		if Input.is_key_pressed(KEY_UP):
			if len(commands_history) > 0:
				prompt.text = commands_history[history_index]
				if history_index >= len(commands_history) - 1:
					history_index = 0
				else:
					history_index += 1
		if Input.is_key_pressed(KEY_TAB):
			pass
			
