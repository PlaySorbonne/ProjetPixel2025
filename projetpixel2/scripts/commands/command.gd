extends RefCounted
class_name Command

var is_valid: bool
var name: String
var arguments: Array[String]
var error: bool

func _init(error: bool):
	self.error = error

func execute() -> void:
	pass
