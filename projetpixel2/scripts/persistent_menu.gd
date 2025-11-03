extends Node
class_name PersistentMenu


const MENU_TRANSITION_TIME := 0.3

@onready var current_menu : Submenu = $CanvasLayer/MainMenu
@onready var current_pos := Vector2.ZERO


func _ready() -> void:
	SaveData.load_data()
	if len(CardData.cards_data.values()) == 0:
		CardData.load_cards_data()
	GV.persistent_menu = self
	RunData.reset_run_data()

func transition_to_scene() -> void:
	pass

func transition_to_menu(new_menu : Submenu) -> void:
	var current_menu_transition := current_pos - new_menu.submenu_pos
	var tween := get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	$CanvasLayer.add_child(new_menu)
	new_menu.position = new_menu.size * new_menu.submenu_pos - current_pos
	tween.tween_property(new_menu, "position", Vector2.ZERO, MENU_TRANSITION_TIME)
	tween.tween_property(current_menu, "position", 
				current_menu.size * current_menu_transition, MENU_TRANSITION_TIME)
	
	current_menu.queue_free()
	current_menu = new_menu
	current_pos = new_menu.submenu_pos
