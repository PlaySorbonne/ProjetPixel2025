extends Node
class_name Mouse2DInteraction


var hovered_node : Control = null
var _hovered_nodes_stack : Array[Control] = []


func _ready() -> void:
	GV.mouse_2d_interaction = self

func _process(delta: float) -> void:
	print("hovered node = " + str(hovered_node) + " ; stack = " + str(_hovered_nodes_stack))

func get_hovered_node() -> Control:
	if is_instance_valid(hovered_node):
		return hovered_node
	else:
		hovered_node = null
		return null
	#if len(_hovered_nodes_stack) > 0:
		#return _hovered_nodes_stack[len(_hovered_nodes_stack) - 1]
	#else:
		#return null

func start_hover_node(new_node : Control) -> void:
	#_hovered_nodes_stack.append(new_node)
	hovered_node = new_node

func stop_hover_node(old_node : Control) -> void:
	#_hovered_nodes_stack.erase(old_node)
	if hovered_node == old_node:
		hovered_node = null
