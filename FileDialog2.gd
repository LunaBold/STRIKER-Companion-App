extends FileDialog




func _on_FileDialog_file_selected(path):
	var image = Image.new()
	image.load(path)
	var texture = ImageTexture.new()
	texture.create_from_image(image, 0)
	$"../MechImage".texture_normal = texture
	$"../MechImage".texture_pressed = texture
	$"../MechImage".texture_focused = texture
	$"../MechImage".texture_hover = texture
	$"../MechImage".texture_disabled = texture
