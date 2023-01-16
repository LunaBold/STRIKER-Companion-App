extends Button



var path 
func _ready():
	if OS.has_feature("standalone"):
		path = OS.get_executable_path().get_base_dir()
	else:
		path = OS.get_user_data_dir()
	var dir = Directory.new()
	dir.open(path)
	dir.make_dir("Save Files")

func _on_Delete_pressed():
	$"../DeleteSave".popup_centered()
	$"../DeleteSave".set_current_dir("%s/Save Files" % path)
	$"../DeleteSave".window_title = "Delete a File"

func Delete(filePath):
	var _error = OS.move_to_trash(filePath)
