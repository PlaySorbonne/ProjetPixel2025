extends Label3D
class_name DamagePopup


const POPUP_RES := preload("res://scenes/interface/gameplay_hud/damage_popup.tscn")
const POSSIBLE_OFFSETS : Array[Vector3] = [
	Vector3(-1, 0, -1),
	Vector3(-1, 0, 0),
	Vector3(-1, 0, 1),
	Vector3(0, 0, -1),
	Vector3(0, 0, 1),
	Vector3(1, 0, -1),
	Vector3(1, 0, 0),
	Vector3(1, 0, 1),
]
const ANIM_TIME := 1.0


static func display_experience(amount : int, spawn_pos : Vector3) -> void:
	var popup := POPUP_RES.instantiate()
	popup.text = str(amount)
	popup.modulate = Color.BLUE
	popup.font_size = 74
	popup.global_position = spawn_pos + Vector3(0.0, 0.0, 0.0)
	#const EXP_POPUP_SPAWN_RADIUS := 1.0
	#popup.global_position = GV.space_ship.global_position + Vector3(
		#randf_range(-EXP_POPUP_SPAWN_RADIUS, EXP_POPUP_SPAWN_RADIUS),
		 #1.75, randf_range(-EXP_POPUP_SPAWN_RADIUS, EXP_POPUP_SPAWN_RADIUS))
	popup.pick_random_direction = false
	popup.direction = Vector3.UP
	GV.world.add_child(popup)

static func display_damage(entity : Node3D, damage : int, is_crit : bool) -> void:
	var popup := POPUP_RES.instantiate()
	popup.text = str(damage)
	if is_crit:
		popup.modulate = Color.DARK_RED
		popup.font_size = 74
	popup.position = entity.position + Vector3(0, 0.25, 0)
	GV.world.add_child(popup)


var direction := Vector3.ZERO
var pick_random_direction := true


func _process(delta: float) -> void:
	position += direction * delta

func _ready() -> void:
	$Timer.start(ANIM_TIME)
	if pick_random_direction:
		direction = POSSIBLE_OFFSETS.pick_random()
	var final_color := Color(modulate.r, modulate.g, modulate.b, 0.0)
	var t := create_tween().set_parallel().set_ease(Tween.EASE_OUT)
	t.tween_property(self, "modulate", final_color, ANIM_TIME)

func _on_timer_timeout() -> void:
	queue_free()
