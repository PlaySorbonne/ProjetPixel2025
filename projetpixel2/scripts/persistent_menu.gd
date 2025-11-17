extends Node
class_name PersistentMenu


@onready var current_menu : Submenu = $CanvasLayer/MainMenu
@onready var current_pos := Vector2.ZERO


func _ready() -> void:
	if len(CardData.cards_data.values()) == 0:
		CardData.load_cards_data()
	GV.persistent_menu = self
	RunData.reset_run_data()
	SaveData.load_game()

func transition_to_scene() -> void:
	pass

func transition_to_menu(new_menu : Submenu) -> void:
	const MENU_TRANSITION_TIME := 0.3
	var old_menu := current_menu
	var tween := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	$CanvasLayer.add_child(new_menu)
	current_menu = new_menu
	new_menu.position = new_menu.size * new_menu.submenu_pos - current_pos
	tween.tween_property(new_menu, "position", Vector2.ZERO, MENU_TRANSITION_TIME)
	tween.tween_property(old_menu, "position", 
				old_menu.size * new_menu.submenu_pos * -1, MENU_TRANSITION_TIME)
	await tween.finished
	old_menu.queue_free()
	current_pos = new_menu.submenu_pos
