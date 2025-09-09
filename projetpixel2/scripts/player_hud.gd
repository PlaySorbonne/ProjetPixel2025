extends CanvasLayer
class_name PlayerHud


const CARD_OBJ_RES := preload("res://scenes/interface/cards/card_object.tscn")
const TOWER_RES := preload("res://scenes/spaceship/towers/tower_base.tscn")
const TOWERS_OFFSET := Vector2(-10, 0)

var in_combo := false
var available_towers := 2
var new_level_cards : Array[CardObject] = []
var number_of_choosable_cards := 3

# components
@onready var mouse_cursor_hint : MouseCursorHint = $MouseCursorHint
@onready var tower_spawner : TowerSpawner = $TowerSpawner
@onready var mouse_3d_interaction : Mouse3dInteraction = $Mouse3dInteraction
@onready var combo_label : Label = $ComboCounter/Label
@onready var console : Console = $Console
var health_bar_tween : Tween
var shields_bar_tween : Tween

func _ready() -> void:
	GV.hud = self
	console.visible = GV.debug_mode
	RunData.connect("enemy_killed", new_kill)
	RunData.connect("experience_gained", update_experience)
	RunData.connect("level_gained", gain_level)
	update_level()
	await get_tree().process_frame
	var ship_health : DamageableObject = GV.space_ship.get_node("ShipHealth")
	ship_health.update_health.connect(_update_ship_health)
	$ShipHealth/HealthProgressBar.max_value = ship_health.max_health
	$ShipHealth/HealthProgressBar.value = ship_health.health
	var shields_health : DamageableObject = GV.space_ship.get_node("ShieldHealth")
	shields_health.update_health.connect(_update_ship_shields)
	$ShipHealth/ShieldProgressBar.max_value = shields_health.max_health
	$ShipHealth/ShieldProgressBar.value = shields_health.health

func _update_ship_health(new_health : int) -> void:
	if health_bar_tween:
		health_bar_tween.kill()
	health_bar_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	health_bar_tween.tween_property($ShipHealth/HealthProgressBar, 
					"value", new_health, 0.2)

func _update_ship_shields(new_shields : int) -> void:
	if shields_bar_tween:
		shields_bar_tween.kill()
	shields_bar_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	shields_bar_tween.tween_property($ShipHealth/ShieldProgressBar, 
					"value", new_shields, 0.2)

func clear_card_description() -> void:
	$LabelCardDescription.text = ""

func update_card_description(new_text := "") -> void:
	$LabelCardDescription.text = new_text

func update_experience() -> void:
	$ExperienceBar.value = RunData.current_experience
	
func update_available_towers() -> void:
	$hud_control/ButtonSpawnTower.text = "Towers (" + str(available_towers) + ")"

func add_card_to_hand(card_data: CardData) -> void:
	var new_card : CardObject = CARD_OBJ_RES.instantiate()
	new_card.card = card_data
	$CardsContainer.add_child(new_card)
	await get_tree().process_frame
	new_card.can_be_dropped_on_objects = true

func gain_level() -> void:
	update_level()
	if RunData.current_level > 1:
		Engine.time_scale = 0.0
		new_level_cards = []
		for i : int in range(number_of_choosable_cards):
			var new_card : CardObject = CARD_OBJ_RES.instantiate()
			$NewCardsContainer.add_child(new_card)
			new_card.card_clicked.connect(on_card_level_clicked.bind(new_card))
			new_level_cards.append(new_card)
			new_card.card = CardData.get_random_card()

func on_card_level_clicked(chosen_card : CardObject) -> void:
	Engine.time_scale = 1.0
	chosen_card.card_clicked.disconnect(on_card_level_clicked)
	for card : CardObject in new_level_cards:
		if card != chosen_card:
			card.destroy_card_object()
	chosen_card.release_card()
	chosen_card.get_parent().remove_child(chosen_card)
	$CardsContainer.add_child(chosen_card)
	new_level_cards = []
	await get_tree().process_frame
	chosen_card.can_be_dropped_on_objects = true

func update_level() -> void:
	$ExperienceBar/Label.text = "Level " + str(RunData.current_level)
	$ExperienceBar.max_value = RunData.level_experience_threshold

func new_kill() -> void:
	$ComboCounter/ComboTimer.start(RunData.combo_max_time)
	if in_combo:
		RunData.current_combo += RunData.combo_increment
	else:
		in_combo = true
	update_combo_label()

func update_combo_label() -> void:
	combo_label.text = "Combo: " + str(RunData.current_combo)

func add_available_tower() -> void:
	if available_towers == 0:
		return
	var tower_pos := GV.player_camera.project_position(
		Vector2(50, 50) + TOWERS_OFFSET * available_towers, 50.0)
	available_towers -= 1
	var new_tower := TOWER_RES.instantiate()
	new_tower.is_hologram = true
	GV.world.add_child(new_tower)
	new_tower.position = tower_pos

func _on_create_tower_window_tower_placed() -> void:
	tower_spawner.spawn_tower(
		TowersData.tower_types[0],
		mouse_3d_interaction.mouse_3d_position
	)

func _on_combo_timer_timeout() -> void:
	in_combo = false
	RunData.current_combo = 0
	update_combo_label()

func _on_button_spawn_tower_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	add_available_tower()
	if available_towers == 0:
		$hud_control/ButtonSpawnTower.text = "No more\ntowers\n:("
	else:
		$hud_control/ButtonSpawnTower.text = "Towers (" + str(available_towers) + ")"
