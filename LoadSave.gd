extends FileDialog


func _on_LoadSave_file_selected(path):
	$"../Load".Load(path)
