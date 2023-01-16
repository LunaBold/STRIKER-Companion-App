extends Button

func _on_Clash_pressed():
	$"../../../..".FocusPoints = max($"../../../..".FocusPoints-1, 0)
