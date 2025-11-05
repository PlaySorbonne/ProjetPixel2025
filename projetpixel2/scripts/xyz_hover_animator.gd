extends Node
class_name XYZHoverAnimator


@export var properties : Dictionary[String, Variant] = {
	"position" : Vector2(0.0, -15.0),
	"scale" : Vector2(1.05, 1.05),
}
@export var treat_as_offset : Array[String] = ["position"]
@export var anim_time : float = 0.17
@export var center_parent_pivot_offset := true

@onready var parent_node : Control = get_parent()
var properties_enter : Dictionary[String, Variant] = {}
var properties_exit : Dictionary[String, Variant] = {}
var tween : Tween


func _ready() -> void:
	if center_parent_pivot_offset:
		parent_node.pivot_offset = parent_node.size / 2.0
	_initialize_hover_parameters()

func _initialize_hover_parameters() -> void:
	for property_name : String in properties.keys():
		var reset_property : Variant = parent_node.get(property_name)
		if treat_as_offset.has(property_name):
			properties_enter[property_name] = properties[property_name] + reset_property
		else:
			properties_enter[property_name] = properties[property_name]
		properties_exit[property_name] = reset_property
	parent_node.mouse_entered.connect(_on_mouse_entered)
	parent_node.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	tween_to(properties_enter)

func _on_mouse_exited() -> void:
	tween_to(properties_exit)

func tween_to(new_values : Dictionary[String, Variant]) -> void:
	if tween:
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	for property_name : String in new_values.keys():
		tween.tween_property(
			parent_node,
			property_name,
			new_values[property_name],
			anim_time
		)
