extends RichTextLabel


func _process(_delta):
	if text != "":
		fit_content_height = true
	else:
		fit_content_height = false
