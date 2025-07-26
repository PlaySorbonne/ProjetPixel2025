extends RichTextLabel
class_name CommandsLogger

enum log_types {
	INFO,
	WARNING,
	ERROR
}

func print(text: String, type=log_types.INFO) -> void:
	self.text += "\n"
	var to_append = ""
	match type:
		log_types.INFO:
			to_append = text
		log_types.WARNING:
			to_append = "[color=yellow]" + text + "[/color]"
		log_types.ERROR:
			to_append = "[color=red]" + text + "[/color]"
	self.text += to_append
	scroll_to_line(get_line_count())
