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

static func display_damage(entity : Node3D, damage : int, is_crit : bool) -> void:
	var popup := POPUP_RES.instantiate()
	popup.text = str(damage)
	if is_crit:
		popup.modulate = Color.DARK_RED
		popup.font_size = 74
	GV.world.add_child(popup)
	popup.position = entity.position + Vector3(0, 0.25, 0)


var direction := Vector3.ZERO

func _process(delta: float) -> void:
	position += direction * delta

func _ready() -> void:
	$Timer.start(ANIM_TIME)
	direction = POSSIBLE_OFFSETS.pick_random()
	var t := create_tween().set_parallel().set_ease(Tween.EASE_OUT)
	t.tween_property(self, "modulate", Color.TRANSPARENT, ANIM_TIME)
	t.tween_property(self, "outline_modulate", Color.TRANSPARENT, ANIM_TIME)

func _on_timer_timeout() -> void:
	queue_free()
