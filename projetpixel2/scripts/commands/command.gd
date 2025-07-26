extends RefCounted
class_name Command

var is_valid: bool
var name: String
var arguments: Array[String]
var error: bool
var error_message: String

func _init(error: bool, error_message: String):
	self.error = error
	self.error_message = error_message

func execute() -> void:
	pass
