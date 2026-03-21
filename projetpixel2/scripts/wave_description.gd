extends ObjectDescription
class_name WaveDescription

const WAVE_DESCRIPTION_RES := preload("res://scenes/interface/descriptions/wave_description.tscn")

static func add_wave_description(wave_button : NextWaveButton) -> WaveDescription:
	var wave_description : WaveDescription = WAVE_DESCRIPTION_RES.instantiate()
	wave_description.wave_btn = wave_button
	wave_description._init_description_popup(wave_button)
	return wave_description


var wave_btn : NextWaveButton = null
#class EnemyWave:
	#var wave_number : int = 0
	#var wave_difficulty : float = 5.0
	#var wave_enemies : Array[BaseEnemy] = []
	#var wave_number_of_enemies : int = 5
	#var wave_duration := 30.0
	#var is_boss_wave := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	await get_tree().process_frame
	var wave := wave_btn.wave
	$LabelTitle.text = "Wave " + str(wave.wave_number)
	$LabelDescription.text = ""
