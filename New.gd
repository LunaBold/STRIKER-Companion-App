extends Button


func _on_New_pressed():
	$"../ConfirmationDialog".popup_centered()


func _on_ConfirmationDialog_confirmed():
	var _reload = get_tree().reload_current_scene()
