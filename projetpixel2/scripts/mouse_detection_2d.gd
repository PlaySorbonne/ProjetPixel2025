extends Node
class_name MouseDetection2D

@onready var parent_node : Control = get_parent()

func _ready() -> void:
	parent_node.connect("mouse_entered", self.node_hovered)
	parent_node.connect("mouse_exited", self.node_hover_stop)

func node_hovered() -> void:
	GV.mouse_2d_interaction.start_hover_node(parent_node)

func node_hover_stop() -> void:
	GV.mouse_2d_interaction.stop_hover_node(parent_node)
