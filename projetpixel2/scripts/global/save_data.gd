extends Node


const SAVE_FILE_NAME := "user://tower_survivor.savefile"
# properties saved directly (no parser)
const DIRECT_SAVED_PROPERTIES := ["current_language", "selected_deck"] 


## Settings
var current_language := "english"

## Decks & Cards
var player_decks : Array[Deck] = []
var selected_deck := 0
var unlocked_cards : Dictionary[String, int] = {}


func save_game() -> void:
	var data : Dictionary[String, Variant]= {
		"settings": {
			"current_language": current_language
		},
		"decks": [],
		"selected_deck": selected_deck
	}

	# Serialize decks
	for deck : Deck in player_decks:
		data["decks"].append({
			"name": deck.name,
			"texture_index" : deck.texture_index,
			"cards": deck.cards.duplicate()
		})

	var save_file := FileAccess.open(SAVE_FILE_NAME, FileAccess.WRITE)
	save_file.store_string(JSON.stringify(data, "\t"))
	#print("SAVE GAME:\n" + JSON.stringify(data, "\t"))
	save_file.close()

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_FILE_NAME):
		push_warning("No save file found at %s" % SAVE_FILE_NAME)
		return
	
	var save_file = FileAccess.open(SAVE_FILE_NAME, FileAccess.READ)
	var content = save_file.get_as_text()
	save_file.close()
	
	var data : Dictionary = JSON.parse_string(content)
	if typeof(data) != TYPE_DICTIONARY:
		push_error("Invalid save format!")
		return
	
	current_language = data["settings"]["current_language"]
	player_decks = []
	selected_deck = data["selected_deck"]
	#print("LOAD GAME:")
	#print("current_language = " + str(current_language))
	#print("selected_deck = " + str(selected_deck))
	#print("player_decks = ")
	
	# Deserialize decks
	for d : Dictionary in data["decks"]:
		var deck_cards : Array[String] = []
		for card_name : String in d["cards"]:
			deck_cards.append(card_name)
		var deck := Deck.new(
			d["name"],
			d["texture_index"],
			deck_cards
		)
		player_decks.append(deck)
		#print("\t" + deck.deck_to_string())
