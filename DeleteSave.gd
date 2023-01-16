extends FileDialog




func _on_DeleteSave_file_selected(path):
	path = path.get_base_dir()
	print(path)
	$"../Delete".Delete(path)
