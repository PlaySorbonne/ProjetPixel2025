extends Node


const SAVE_FILE_NAME := "user://tower_survivor.savefile"


## Settings
var current_language := "english"

## Decks & Cards
var player_decks : Array[Deck] = []
var selected_deck := 0
var unlocked_cards : Array[CardData] = []


func save_game():
	var save_game := FileAccess.open(SAVE_FILE_NAME, FileAccess.WRITE)
	var save_dict : Dictionary = {}
	var at_saved_data := false
	for property_dict : Dictionary in self.get_property_list():
		var property_name : String = property_dict["name"]
		if not at_saved_data:
			if property_name == "save_data.gd":
				at_saved_data = true
			continue
		print("property name = " + property_name)
		save_dict[property_name] = self.get(property_name)
	
	var json_string := JSON.stringify(save_dict)
	save_game.store_line(json_string)

func load_data():
	print_debug("Loading data...")
	if not FileAccess.file_exists(SAVE_FILE_NAME):
		print_debug("SAVE FILE NOT FOUND")
		return
	
	var save_game := FileAccess.open(SAVE_FILE_NAME, FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string := save_game.get_line()
		var json := JSON.new()
		var parse_result := json.parse(json_string)
		var save_data : Dictionary = json.get_data()
		print("Load save_data:")
		for k : String in save_data.keys():
			if self.get(k) != null:
				self.set(k, save_data[k])
				print("\t" + k + " : " + str(save_data[k]))
