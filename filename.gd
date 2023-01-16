extends ConfirmationDialog



func _on_FileDialog_confirmed():
	var text = $Control/LineEdit.text
	$"../Save".save_game(text)
	
