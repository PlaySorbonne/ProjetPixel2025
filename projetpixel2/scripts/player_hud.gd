extends CanvasLayer
class_name PlayerHud


signal level_updated

const CARD_OBJ_RES := preload("res://scenes/interface/cards/card_object.tscn")
const TOWER_RES := preload("res://scenes/spaceship/towers/tower_base.tscn")
const TOWERS_OFFSET := Vector2(-10, 0)

var in_combo := false
var available_towers := 2
var new_level_cards : Array[CardObject] = []
var cards_hand : Array[CardObject] = []
var number_of_choosable_cards := 3

# components
@onready var waves_container : VBoxContainer = $WavesContainer
@onready var waves_timer_label : Label = $WavesTimerLabel
@onready var mouse_cursor_hint : MouseCursorHint = $MouseCursorHint
@onready var tower_spawner : TowerSpawner = $TowerSpawner
@onready var mouse_3d_interaction : Mouse3dInteraction = $Mouse3dInteraction
@onready var combo_label : Label = $ComboCounter/Label
@onready var console : Console = $Console
@onready var shields_bar_color : Color = $ShipHealth/ShieldProgressBar.tint_progress
@onready var health_bar_color : Color = $ShipHealth/HealthProgressBar.tint_progress
@onready var revolver : RevolverRussianRoulette = $RevolverFrame/SubViewportContainer/SubViewport/RevolverWorld/RevolverRussianRoulette
var health_bar_tween : Tween
var shields_bar_tween : Tween
var experience_bar_tween : Tween
var displayed_level := RunData.current_level
var displayed_total_experience := RunData.total_experience


func _ready() -> void:
	GV.hud = self
	console.visible = GV.debug_mode
	RunData.enemy_killed.connect(new_kill)
	RunData.experience_gained.connect(update_experience)
	RunData.level_gained.connect(update_level)
	level_updated.connect(gain_level)
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
	$ExperienceBar.size = $ExperienceBar.custom_minimum_size
	$ExperienceBar.position = $ExperienceBarBackgroundTexture.position + Vector2(
							20.0, 52.0)

func _update_ship_health(new_health : int) -> void:
	health_bar_tween = tween_progress_bar(health_bar_tween, new_health,
		$ShipHealth/HealthProgressBar, health_bar_color)

func _update_ship_shields(new_shields : int) -> void:
	shields_bar_tween = tween_progress_bar(shields_bar_tween, new_shields,
		$ShipHealth/ShieldProgressBar, shields_bar_color)

func tween_progress_bar(t : Tween, new_val : float, 
					object : TextureProgressBar, tint : Color) -> Tween:
	if t:
		t.kill()
	t = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	t.tween_property(object, "value", new_val, 0.2)
	if new_val < object.value:
		t.tween_property(object, "tint_progress", Color.RED, 0.1)
		t.tween_property(object, "tint_progress", tint, 0.1).set_delay(0.1)
	return t

func clear_card_description() -> void:
	$LabelCardDescription.text = ""

func update_card_description(new_text := "") -> void:
	$LabelCardDescription.text = new_text

func update_experience() -> void:
	var final_val := RunData.total_experience - RunData.previous_experience_threshold
	if final_val == $ExperienceBar.value:
		return
	# initialize tween
	var tween_ease : Tween.EaseType
	if experience_bar_tween:
		experience_bar_tween.kill()
		tween_ease = Tween.EASE_OUT
	else:
		tween_ease = Tween.EASE_IN_OUT
	experience_bar_tween = create_tween().set_ease(tween_ease)
	# tween exp bar
	if final_val >= RunData.level_experience_threshold:
		experience_bar_tween.finished.connect(_loop_exp_tween)
		final_val = RunData.level_experience_threshold
	experience_bar_tween.tween_property($ExperienceBar, "value", 
							final_val, 0.1)

func _loop_exp_tween() -> void:
	RunData.gain_level()
	$ExperienceBar/Label.text = "Level " + str(RunData.current_level)
	level_updated.emit()
	await get_tree().create_timer(0.05).timeout
	$ExperienceBar.value = 0.0
	$ExperienceBar.max_value = RunData.level_experience_threshold
	update_experience()

func update_available_towers() -> void:
	$hud_control/ButtonSpawnTower.text = "Towers (" + str(available_towers) + ")"

func add_card_to_hand(card_data: CardData, forced_position := Vector2.ZERO) -> void:
	var new_card : CardObject = CARD_OBJ_RES.instantiate()
	new_card.card = card_data
	if forced_position != Vector2.ZERO:
		new_card.global_position = forced_position
	_add_playable_card(new_card)

func _add_playable_card(new_card : CardObject) -> void:
	cards_hand.append(new_card)
	$CardsContainer.add_child(new_card)
	reorder_hand()
	await get_tree().process_frame
	new_card.can_be_dropped_on_objects = true

func gain_level(force_level_up := false) -> void:
	if RunData.current_level > 1 or force_level_up:
		Engine.time_scale = 0.0
		new_level_cards = []
		for i : int in range(number_of_choosable_cards):
			var new_card : CardObject = CARD_OBJ_RES.instantiate()
			var select_button := SelectCardButton.add_select_button_to_card(new_card)
			#new_card.card_clicked.connect(_on_card_level_clicked.bind(new_card))
			select_button.card_selected.connect(_on_card_level_clicked.bind(new_card, select_button))
			new_level_cards.append(new_card)
			new_card.card = CardData.get_random_card_from_deck()
			$NewCardsContainer.add_child(new_card)

func remove_card_from_hand(card_object : CardObject) -> void:
	cards_hand.erase(card_object)
	reorder_hand()

func reorder_hand() -> void:
	var card_count : int = cards_hand.size()
	if card_count == 0:
		return
	
	var container_size : Vector2 = $CardsContainer.size
	var base_x : float = container_size.x / 2.0 - (cards_hand[0
					].size.x * cards_hand[0].scale.x / 2.0) - 30.0
	var base_y : float = -30.0
	if card_count == 1:
		cards_hand[0].deck_position = Vector2(base_x, base_y)
		cards_hand[0].deck_rotation = 0.0
		cards_hand[0].return_to_hand()
		return
	
	const MAX_X_SPACING := 150.0
	const MAX_Y_SPACING := 40.0
	const MAX_ROTATION_SPACING := PI / 6
	
	var spacing_x : float = min(container_size.x / max(card_count, 1), MAX_X_SPACING)
	var spacing_rot : float = MAX_ROTATION_SPACING / max(card_count - 1, 1)
	
	for i in range(card_count):
		var card : CardObject = cards_hand[i]
		
		var t : float = float(i) / max(card_count - 1, 1)
		var x : float = t * (spacing_x * (card_count - 1))
		var offset_x : float = x - (spacing_x * (card_count - 1) / 2.0)
		
		var offset_norm : float = offset_x / (spacing_x * (card_count - 1) / 2.0)
		var y_offset : float = -pow(offset_norm, 2) * MAX_Y_SPACING
		
		card.deck_position = Vector2(
			base_x + offset_x,
			base_y - y_offset
		)
		card.deck_rotation = lerp(-MAX_ROTATION_SPACING / 2.0, MAX_ROTATION_SPACING / 2.0, t)
		card.z_index = i
	
	for card : CardObject in cards_hand:
		card.return_to_hand()



func _on_card_level_clicked(chosen_card : CardObject, card_button : SelectCardButton) -> void:
	card_button.queue_free()
	Engine.time_scale = 1.0
	#chosen_card.card_clicked.disconnect(_on_card_level_clicked)
	for card : CardObject in new_level_cards:
		if card != chosen_card:
			card.destroy_card_object()
	#add_card_to_hand(chosen_card.card, chosen_card.global_position)
	#await get_tree().process_frame
	#chosen_card.queue_free()
	
	
	chosen_card.get_parent().remove_child(chosen_card)
	_add_playable_card(chosen_card)
	new_level_cards = []
	#await get_tree().create_timer(0.1).timeout
	#chosen_card.release_card()

func update_level() -> void:
	update_experience()

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
		$hud_control/ButtonSpawnTower.text = "Towers\n(" + str(available_towers) + ")"

func _on_revolver_frame_pressed() -> void:
	revolver.shoot_revolver()
