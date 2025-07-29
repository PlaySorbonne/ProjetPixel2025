extends Control
class_name Console

@onready var prompt: LineEdit = $VBoxContainer/Prompt
@onready var logger: CommandsLogger = $VBoxContainer/Logs

var registry: CommandsRegistry = CommandsRegistry.new()
var pre_parsing: Dictionary[String, Variant]
var commands_history: Array[String] = []
var history_index = len(commands_history)
var is_tab_selecting = false

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

func get_token_index(splitted: Array[String], string_index: int) -> int:
	var s := 0
	var i := 0
	for word in splitted:
		s += len(word)
		if (s > string_index):
			return i
		i += 1
	return i

func _input(event: InputEvent) -> void:
	
	if prompt.has_focus():
		var command_text = prompt.text
		prompt.text = ""
		var pre_parsing = Parser.pre_parse(command_text)
		var command_name: String = pre_parsing["command"]
		
		if Input.is_key_pressed(KEY_ENTER):
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
			var commands := registry.commands.keys()
			var cursor_pos = prompt.caret_position
			var token_index = get_token_index([command_name] + pre_parsing["arguments"], cursor_pos)
			if token_index == 0:
				pass # TODO
			pass
			
