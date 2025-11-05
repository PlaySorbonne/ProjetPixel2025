extends Submenu
class_name MissionMenu


func _ready() -> void:
	update_deck_button()

func update_deck_button() -> void:
	var current_deck := SaveData.player_decks[SaveData.selected_deck]
	$ButtonDeck/LabelDeck.text = current_deck.name
	$ButtonDeck.icon = Deck.DECK_TEXTURES[current_deck.texture_index]

func _on_button_play_pressed() -> void:
	GV.persistent_menu_world.camera_movement(
			GV.persistent_menu_world.markers_dict[
			PersistentMenuWorld.CameraMarkers.StartGame]
	)
	var tween := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($FadeTransition, "color", Color.BLACK, 0.5)
	await tween.finished
	get_tree().change_scene_to_file(GV.WORLD_FILE)

func _on_button_deck_pressed() -> void:
	$DeckCraft.visible = true
	$DeckCraft.initialize_cards()

func _on_button_deck_craft_back_pressed() -> void:
	$DeckCraft.visible = false
	update_deck_button()
