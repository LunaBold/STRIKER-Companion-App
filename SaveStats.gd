extends Control


func save():
	var savearray = []
	savearray.append(name)
	for i in $Boarder/MarginContainer/VBoxContainer.get_children():
		if i.get_child_count() > 1:
			savearray.append(i.get_child(1).value)
	var save_dict = {
		"filename" : get_filename(),
		"stats" : savearray
	}
	return save_dict
