extends Control
class_name Console

@onready var prompt: LineEdit = $VBoxContainer/Prompt
@onready var logger: CommandsLogger = $VBoxContainer/Logs

# commands vars
var registry: CommandsRegistry = CommandsRegistry.new()
var pre_parsing: Dictionary[String, Variant]
var commands_history: Array[String] = []
var history_index = len(commands_history)

# tab completion vars
var is_tab_selecting = false
var tab_selection_index: Dictionary[int, int] = {}
var current_completions: Array = []
var current_token: String = ""
var current_token_index: int = 0

func _ready():
	# Simple commands can be added directly
	registry.register_command("ping", Command.new("ping", 
	  [],
	  func(): logger.print("pong"), 
	  {"usage": "ping", "description": "Affiche \"pong\""}))
	
	# Complex commands can have their own classes
	registry.register_command("help", HelpCommand.new(logger, registry))
	registry.register_command("give-tower", GiveTowerCommand.new(logger))
	await get_tree().create_timer(1).timeout # hack (wait for cards to load before registering give-card)
	registry.register_command("give-card", GiveCardCommand.new(logger))

func restore_focus():
	await get_tree().process_frame
	prompt.release_focus()
	prompt.grab_focus()

func add_to_history(command: String) -> void:
	commands_history.append(command)
	history_index = len(commands_history) - 1

func get_token_index(splitted: Array, string_index: int) -> int:
	var s := 0
	var i := 0
	for word in splitted:
		s += len(word)
		if (s > string_index):
			return i
		i += 1
	return i - 1
	
func recreate_command(splitted: Array, word: String, index: int) -> void:
	splitted[index] = word
	var new_cursor_index = 0
	for i in range(index + 1):
		new_cursor_index += len(splitted[i])
	prompt.text = " ".join(splitted)
	prompt.caret_column = new_cursor_index if index == 0 else new_cursor_index + 1

func _input(event: InputEvent) -> void:
	if prompt.has_focus():	
		if (event is InputEventKey) and (event as InputEventKey).physical_keycode != KEY_TAB:
			is_tab_selecting = false
		var command_text = prompt.text
		var pre_parsing = Parser.pre_parse(command_text)
		var command_name: String = pre_parsing["command"]
		var tokens: Array = [command_name] + Array(pre_parsing["arguments"])
		
		if Input.is_key_pressed(KEY_ENTER):
			prompt.text = ""
			if pre_parsing.error:
				restore_focus()
				return
				
			var parsing_result = Parser.parse(command_text, registry)
			if parsing_result.get("error") != null:
				if command_text != "":
					add_to_history(command_text)
				logger.print("Erreur : " + parsing_result["error"], logger.log_types.ERROR)
				restore_focus()
				return
			
			var command: Command = parsing_result["command"]
			var arguments: Array = parsing_result["arguments"]
			
			command.execute(arguments)
			add_to_history(command_text)
			restore_focus()
		if Input.is_key_pressed(KEY_UP):
			if len(commands_history) > 0:
				prompt.text = commands_history[history_index]
				if history_index == 0:
					history_index = len(commands_history) - 1
				else:
					history_index -= 1
		if Input.is_key_pressed(KEY_TAB):
			if !is_tab_selecting:
				var cursor_pos = prompt.caret_column
				current_token_index = get_token_index(tokens, cursor_pos)
				current_token = tokens[current_token_index]
				tab_selection_index[current_token_index] = 0
				is_tab_selecting = true
			if current_token_index == 0:
				var commands := registry.commands.keys()
				current_completions = Parser.filter_completions(current_token, commands)
			else:
				var command := registry.get_command(command_name)
				if command == null:
					return
				if current_token_index - 1 >= command.arguments.size():
					return
				var arg_type = command.arguments[current_token_index - 1]
				current_completions = Parser.filter_completions(current_token, arg_type.get_completions())
			if current_completions.size() == 0:
				return
			var new_current_token: String = current_completions[tab_selection_index[current_token_index]]
			print(current_token_index)
			recreate_command(tokens, new_current_token, current_token_index)
			tab_selection_index[current_token_index] += 1
			if tab_selection_index[current_token_index] >= current_completions.size():
				tab_selection_index[current_token_index] = 0
			
