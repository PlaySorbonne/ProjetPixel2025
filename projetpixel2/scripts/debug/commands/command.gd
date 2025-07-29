extends RefCounted
class_name Command

var name: String
var arguments: Array[ArgumentType]
var callback: Callable
var infos: Dictionary[String, String]

func _init(name: String, arguments: Array[ArgumentType], callback: Callable = func(): pass, infos: Dictionary[String, String] = {"usage":"", "description":""}):
	self.name = name
	self.arguments = arguments
	self.callback = callback
	self.infos = infos
	
func execute(parsed_args: Array) -> void:
	if callback.is_valid():
		callback.callv(parsed_args)
