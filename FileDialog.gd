extends FileDialog




func _on_FileDialog_file_selected(path):
	var image = Image.new()
	image.load(path)
	var texture = ImageTexture.new()
	texture.create_from_image(image, 0)
	
	$"../PilotImage".texture_normal = texture
	$"../PilotImage".texture_pressed = texture
	$"../PilotImage".texture_focused = texture
	$"../PilotImage".texture_hover = texture
	$"../PilotImage".texture_disabled = texture
