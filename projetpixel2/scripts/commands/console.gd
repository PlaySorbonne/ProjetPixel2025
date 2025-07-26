extends Control
class_name Console

@onready var prompt: LineEdit = $VBoxContainer/Prompt
@onready var logger: CommandsLogger = $VBoxContainer/Logs

var pre_parsing: Dictionary[String, Variant]
var commands_history: Array[String] = []
var history_index = 0
var is_tab_selecting = false

func restore_focus():
	await get_tree().process_frame
	prompt.release_focus()
	prompt.grab_focus()

func _input(event: InputEvent) -> void:
	if prompt.has_focus():
		if Input.is_key_pressed(KEY_ENTER):
			var command_text = prompt.text
			prompt.text = ""
			var pre_parsing = Parser.pre_parse(command_text)
			var command_name: String = pre_parsing["command"]
			if pre_parsing.error:
				restore_focus()
				return
			var command = Parser.parse(command_text, logger)
			if command.error:
				if command_text != "":
					commands_history.append(command_text)
				logger.print(command.error_message, logger.log_types.ERROR)
				restore_focus()
				return
			command.execute()
			commands_history.append(command_text)
			restore_focus()
		if Input.is_key_pressed(KEY_UP):
			if len(commands_history) > 0:
				prompt.text = commands_history[history_index]
				if history_index >= len(commands_history) - 1:
					history_index = 0
				else:
					history_index += 1
		if Input.is_key_pressed(KEY_TAB):
			pass
			
