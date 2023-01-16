extends SpinBox

func _process(_delta):
	if get_line_edit().text == "" or value == null:
		value = get("min_value")
		get_line_edit().text = str(value)
		apply()
