extends Resource
class_name WaveData


@export_category("Wave stats")
## mobs that will be spawned in the wave
@export var mobs : Array
## weight of the wave in the selection
@export_range(0.0, 1.0, 0.01) var spawn_probability := 0.5
## before this wave, the group will not spawn (leave at -1 to ignore parameter)
@export_range(-1.0, 99.0, 1.0) var min_wave : int = -1
## after this wave, the group will not spawn (leave at -1 to ignore parameter)
@export_range(-1.0, 99.0, 1.0) var max_wave : int = -1
## difficulty cost of the group (balancing variable)
@export_range(1.0, 100.0, 1.0) var difficulty := 1.0
## value of the rewards for defeating the wave (in addition to the individual rewards for defeating the monsters)
@export_range(0.0, 1000.0, 1.0) var loot_value : int = 0
@export_category("Wave modifiers")
## if true, can be added to any other wave
@export var is_wild_mob := false
## if >0, will always be selected and treat that wave as a boss wave (and ignores min_wave and max_wave)
@export_range(-1.0, 99.0, 1.0) var boss_wave_number : int = -1
